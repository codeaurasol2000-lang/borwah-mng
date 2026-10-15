import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ServicesSupervisorActivity {
  final String id;
  final String? entityId;
  final String? entityType;
  final String action;
  final String subject;
  final DateTime occurredAt;

  const ServicesSupervisorActivity({
    required this.id,
    this.entityId,
    this.entityType,
    required this.action,
    required this.subject,
    required this.occurredAt,
  });

  Map<String, Object?> toJson() => {
        'id': id,
        if (entityId != null) 'entityId': entityId,
        if (entityType != null) 'entityType': entityType,
        'action': action,
        'subject': subject,
        'occurredAt': occurredAt.toIso8601String(),
      };

  factory ServicesSupervisorActivity.fromJson(Map<String, dynamic> json) =>
      ServicesSupervisorActivity(
        id: json['id'] as String,
        entityId: json['entityId'] as String?,
        entityType: json['entityType'] as String?,
        action: json['action'] as String,
        subject: json['subject'] as String,
        occurredAt: DateTime.parse(json['occurredAt'] as String),
      );
}

class ServicesSupervisorActivityStore {
  static const _key = 'services_supervisor_actions_v1';

  Future<List<ServicesSupervisorActivity>> load() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_key);
    if (encoded == null) return const [];
    final decoded = jsonDecode(encoded);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Invalid services supervisor action log.');
    }
    return decoded.map((value) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Invalid services supervisor action.');
      }
      return ServicesSupervisorActivity.fromJson(value);
    }).toList(growable: false);
  }

  Future<void> record({
    required String action,
    required String subject,
    String? entityId,
    String? entityType,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final existing = await load();
    final updated = [
      ServicesSupervisorActivity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        entityId: entityId,
        entityType: entityType,
        action: action,
        subject: subject,
        occurredAt: DateTime.now(),
      ),
      ...existing,
    ].take(100);
    final saved = await preferences.setString(
      _key,
      jsonEncode(updated.map((entry) => entry.toJson()).toList()),
    );
    if (!saved) throw StateError('Could not save the supervisory action.');
  }
}
