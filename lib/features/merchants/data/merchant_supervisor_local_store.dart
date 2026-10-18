import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MerchantSupervisorAuditEvent {
  final String? subjectId;
  final String action;
  final String subject;
  final String details;
  final DateTime occurredAt;

  const MerchantSupervisorAuditEvent({
    this.subjectId,
    required this.action,
    required this.subject,
    required this.details,
    required this.occurredAt,
  });
}

class MerchantSupervisorLocalStore {
  MerchantSupervisorLocalStore._();

  static const _storageKey = 'merchant_supervisor_local_operations_v1';
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

  static Future<Set<String>> getSuspendedMerchantIds() async {
    final state = await _readState();
    final merchants = state['merchants'];
    if (merchants is! Map<String, dynamic>) {
      throw const FormatException('Suspended merchant data is invalid.');
    }
    return merchants.entries
        .where((entry) =>
            entry.value is Map<String, dynamic> &&
            (entry.value as Map<String, dynamic>)['suspended'] == true)
        .map((entry) => entry.key)
        .toSet();
  }

  static Future<Map<String, bool>> getSuspensionOverrides() async {
    final state = await _readState();
    final merchants = state['merchants'] as Map<String, dynamic>;
    return {
      for (final entry in merchants.entries)
        if (entry.value is Map<String, dynamic> &&
            (entry.value as Map<String, dynamic>)['suspended'] is bool)
          entry.key: (entry.value as Map<String, dynamic>)['suspended'] as bool,
    };
  }

  static Future<Map<String, double>> getCommissionOverrides() async {
    final state = await _readState();
    final merchants = state['merchants'] as Map<String, dynamic>;
    return {
      for (final entry in merchants.entries)
        if (entry.value is Map<String, dynamic> &&
            (entry.value as Map<String, dynamic>)['commissionPercent'] is num)
          entry.key: ((entry.value as Map<String, dynamic>)['commissionPercent']
                  as num)
              .toDouble(),
    };
  }

  static Future<List<MerchantSupervisorAuditEvent>> getAuditEvents() async {
    final state = await _readState();
    final events = state['events'];
    if (events is! List<dynamic>) {
      throw const FormatException('Merchant audit events are invalid.');
    }
    return events.map((value) {
      if (value is! Map<String, dynamic> ||
          value['action'] is! String ||
          value['subject'] is! String ||
          value['details'] is! String ||
          value['occurredAt'] is! String) {
        throw const FormatException('Merchant audit event is invalid.');
      }
      return MerchantSupervisorAuditEvent(
        subjectId: value['subjectId'] as String?,
        action: value['action'] as String,
        subject: value['subject'] as String,
        details: value['details'] as String,
        occurredAt: DateTime.parse(value['occurredAt'] as String),
      );
    }).toList(growable: false);
  }

  static Future<Map<String, MerchantSupervisorAuditEvent>>
      getLatestMerchantActions() async {
    final events = await getAuditEvents();
    final latest = <String, MerchantSupervisorAuditEvent>{};
    for (final event in events) {
      final merchantId = event.subjectId;
      if (merchantId != null && !latest.containsKey(merchantId)) {
        latest[merchantId] = event;
      }
    }
    return Map.unmodifiable(latest);
  }

  static Future<void> setMerchantSuspended({
    required String merchantId,
    required String merchantName,
    required bool isSuspended,
    required String action,
    required String details,
  }) async {
    final state = await _readState();
    final merchants = state['merchants'] as Map<String, dynamic>;
    final existingMerchant = merchants[merchantId];
    merchants[merchantId] = {
      if (existingMerchant is Map<String, dynamic>) ...existingMerchant,
      'name': merchantName,
      'details': details,
      'suspended': isSuspended,
      'occurredAt': DateTime.now().toIso8601String(),
    };
    _appendAuditEvent(
      state,
      subjectId: merchantId,
      action: action,
      subject: merchantName,
      details: details,
    );
    await _writeState(state);
  }

  static Future<void> setMerchantCommission({
    required String merchantId,
    required String merchantName,
    required double commissionPercent,
    required String action,
  }) async {
    if (!commissionPercent.isFinite ||
        commissionPercent < 0 ||
        commissionPercent > 100) {
      throw ArgumentError.value(
        commissionPercent,
        'commissionPercent',
        'Commission must be between 0 and 100.',
      );
    }
    final state = await _readState();
    final merchants = state['merchants'] as Map<String, dynamic>;
    final existingMerchant = merchants[merchantId];
    merchants[merchantId] = {
      if (existingMerchant is Map<String, dynamic>) ...existingMerchant,
      'name': merchantName,
      'commissionPercent': commissionPercent,
    };
    _appendAuditEvent(
      state,
      subjectId: merchantId,
      action: action,
      subject: merchantName,
      details: '${commissionPercent.toStringAsFixed(1)}%',
    );
    await _writeState(state);
  }

  static Future<void> recordAction({
    required String action,
    required String subject,
    required String details,
  }) async {
    final state = await _readState();
    _appendAuditEvent(
      state,
      action: action,
      subject: subject,
      details: details,
    );
    await _writeState(state);
  }

  static void _appendAuditEvent(
    Map<String, dynamic> state, {
    String? subjectId,
    required String action,
    required String subject,
    required String details,
  }) {
    final events = state['events'] as List<dynamic>;
    events.insert(0, {
      if (subjectId != null) 'subjectId': subjectId,
      'action': action,
      'subject': subject,
      'details': details,
      'occurredAt': DateTime.now().toIso8601String(),
    });
    if (events.length > 100) events.removeRange(100, events.length);
  }

  static Future<Map<String, dynamic>> _readState() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_storageKey);
    if (encoded == null) {
      return {'merchants': <String, dynamic>{}, 'events': <dynamic>[]};
    }
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic> ||
        decoded['merchants'] is! Map<String, dynamic> ||
        decoded['events'] is! List<dynamic>) {
      throw const FormatException('Merchant supervisor local data is invalid.');
    }
    return {
      'merchants': Map<String, dynamic>.from(
        decoded['merchants'] as Map<String, dynamic>,
      ),
      'events': List<dynamic>.from(decoded['events'] as List<dynamic>),
    };
  }

  static Future<void> _writeState(Map<String, dynamic> state) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(_storageKey, jsonEncode(state));
    if (!saved) {
      throw StateError('Could not save merchant supervisor local data.');
    }
    revision.value++;
  }
}
