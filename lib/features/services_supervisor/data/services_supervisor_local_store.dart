import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence for the services-supervisor demo workflows.
///
/// This store keeps the UI state across app restarts. It is not a replacement
/// for the server-side source of truth or audit log.
class ServicesSupervisorLocalStore {
  ServicesSupervisorLocalStore._();

  static const _storageKey = 'services_supervisor_workflows_v1';

  static Future<Map<String, dynamic>> loadRequestWorkflow() async {
    final state = await _readState();
    final workflow = state['requests'];
    if (workflow is! Map<String, dynamic>) {
      throw const FormatException('Stored service requests are invalid.');
    }
    return Map<String, dynamic>.from(workflow);
  }

  static Future<void> saveRequestWorkflow({
    required Set<String> resolvedRequestIds,
    required Map<String, List<String>> comments,
    required Map<String, String> assignedProviderIds,
    required Map<String, String> decisions,
  }) async {
    final state = await _readState();
    state['requests'] = {
      'resolvedIds': resolvedRequestIds.toList(growable: false),
      'comments': comments,
      'assignedProviderIds': assignedProviderIds,
      'decisions': decisions,
    };
    await _writeState(state);
  }

  static Future<Set<String>> loadEscalatedComplaintIds() async {
    final state = await _readState();
    final ids = state['escalatedComplaintIds'];
    if (ids is! List<dynamic> || ids.any((id) => id is! String)) {
      throw const FormatException(
          'Stored service complaint escalations are invalid.');
    }
    return ids.cast<String>().toSet();
  }

  static Future<void> saveEscalatedComplaintIds(Set<String> ids) async {
    final state = await _readState();
    state['escalatedComplaintIds'] = ids.toList(growable: false);
    await _writeState(state);
  }

  static Future<Map<String, dynamic>> _readState() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_storageKey);
    if (encoded == null) {
      return {
        'requests': <String, dynamic>{},
        'escalatedComplaintIds': <dynamic>[],
      };
    }
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic> ||
        decoded['requests'] is! Map<String, dynamic> ||
        decoded['escalatedComplaintIds'] is! List<dynamic>) {
      throw const FormatException(
          'Stored services-supervisor data is invalid.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  static Future<void> _writeState(Map<String, dynamic> state) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(_storageKey, jsonEncode(state));
    if (!saved) {
      throw StateError('Could not save services-supervisor workflow data.');
    }
  }
}
