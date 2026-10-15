import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ServicesSupervisorWorkStore {
  static const _requestsKey = 'services_supervisor_requests_v1';
  static const _complaintsKey = 'services_supervisor_complaints_v1';
  static const requestIds = <String>['SRV-3042', 'SRV-3041', 'SRV-3032'];
  static const complaintIds = <String>['CMP-3091', 'CMP-3038', 'CMP-3012'];
  static const requestIdsByProvider = <String, List<String>>{
    'PRO-1042': ['SRV-3042'],
    'PRO-1038': ['SRV-3041'],
    'PRO-1024': ['SRV-3032'],
    'PRO-1016': [],
  };
  static const complaintIdsByProvider = <String, List<String>>{
    'PRO-1042': ['CMP-3091'],
    'PRO-1038': ['CMP-3038'],
    'PRO-1024': ['CMP-3012'],
    'PRO-1016': [],
  };
  static const requestAgeMinutes = <String, int>{
    'SRV-3042': 45,
    'SRV-3041': 75,
    'SRV-3032': 140,
  };
  static const complaintAgeMinutes = <String, int>{
    'CMP-3091': 45,
    'CMP-3038': 120,
    'CMP-3012': 0,
  };
  static const defaultComplaintStatuses = <String, String>{
    'CMP-3012': 'closed',
  };

  Future<Map<String, dynamic>> loadRequests() => _load(_requestsKey);
  Future<Map<String, dynamic>> loadComplaints() => _load(_complaintsKey);

  Future<ServiceSupervisorOverview> loadOverview() async {
    final requests = await loadRequests();
    final complaints = await loadComplaints();
    final resolved = (requests['resolvedIds'] as List? ?? const [])
        .whereType<String>()
        .toSet();
    final complaintStatuses = complaints['statuses'] is Map
        ? complaints['statuses'] as Map
        : const <Object?, Object?>{};
    final escalated = (complaints['escalatedIds'] as List? ?? const [])
        .whereType<String>()
        .toSet();
    return ServiceSupervisorOverview(
      pendingRequests: requestIds.where((id) => !resolved.contains(id)).length,
      overdueRequests: requestIds
          .where((id) =>
              !resolved.contains(id) && (requestAgeMinutes[id] ?? 0) >= 60)
          .length,
      openComplaints: complaintIds
          .where((id) =>
              (complaintStatuses[id] ??
                  defaultComplaintStatuses[id] ??
                  'waiting') !=
              'closed')
          .length,
      overdueComplaints: complaintIds
          .where((id) =>
              (complaintStatuses[id] ?? defaultComplaintStatuses[id] ?? 'waiting') !=
                  'closed' &&
              (complaintAgeMinutes[id] ?? 0) >= 60)
          .length,
      escalatedComplaints: escalated.length,
    );
  }

  Future<ServiceProviderQualitySummary> loadProviderQuality(
    String providerId,
  ) async {
    final requests = await loadRequests();
    final complaints = await loadComplaints();
    final resolved = (requests['resolvedIds'] as List? ?? const [])
        .whereType<String>()
        .toSet();
    final rejectedIds = requests['rejectionReasons'] is Map
        ? (requests['rejectionReasons'] as Map).keys.whereType<String>().toSet()
        : <String>{};
    final complaintStatuses = complaints['statuses'] is Map
        ? complaints['statuses'] as Map
        : const <Object?, Object?>{};
    final providerRequests =
        requestIdsByProvider[providerId] ?? const <String>[];
    final providerComplaints =
        complaintIdsByProvider[providerId] ?? const <String>[];
    final rejectedCount = providerRequests.where(rejectedIds.contains).length;
    final acceptedCount = providerRequests
        .where((id) => resolved.contains(id) && !rejectedIds.contains(id))
        .length;
    final pendingCount = providerRequests.length - acceptedCount - rejectedCount;
    final openComplaintCount = providerComplaints.where((id) {
      final status =
          complaintStatuses[id] ?? defaultComplaintStatuses[id] ?? 'waiting';
      return status != 'closed';
    }).length;
    return ServiceProviderQualitySummary(
      acceptedRequests: acceptedCount,
      rejectedRequests: rejectedCount,
      pendingRequests: pendingCount,
      openComplaints: openComplaintCount,
    );
  }

  Future<void> saveRequests({
    required Set<String> resolvedIds,
    required Map<String, List<String>> comments,
    required Map<String, String> assignedProviderIds,
    required Map<String, String> rejectionReasons,
  }) =>
      _save(_requestsKey, {
        'resolvedIds': resolvedIds.toList(),
        'comments': comments,
        'assignedProviderIds': assignedProviderIds,
        'rejectionReasons': rejectionReasons,
      });

  Future<void> saveComplaints({
    required Set<String> escalatedIds,
    required Set<String> reassignedIds,
    required Map<String, String> statuses,
  }) =>
      _save(_complaintsKey, {
        'escalatedIds': escalatedIds.toList(),
        'reassignedIds': reassignedIds.toList(),
        'statuses': statuses,
      });

  Future<Map<String, dynamic>> _load(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(key);
    if (encoded == null) return <String, dynamic>{};
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid services supervisor work state.');
    }
    return decoded;
  }

  Future<void> _save(String key, Map<String, Object?> value) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(key, jsonEncode(value));
    if (!saved) throw StateError('Could not save services supervisor work state.');
  }
}

class ServiceProviderQualitySummary {
  final int acceptedRequests;
  final int rejectedRequests;
  final int pendingRequests;
  final int openComplaints;

  const ServiceProviderQualitySummary({
    required this.acceptedRequests,
    required this.rejectedRequests,
    required this.pendingRequests,
    required this.openComplaints,
  });
}

class ServiceSupervisorOverview {
  final int pendingRequests;
  final int overdueRequests;
  final int openComplaints;
  final int overdueComplaints;
  final int escalatedComplaints;

  const ServiceSupervisorOverview({
    required this.pendingRequests,
    required this.overdueRequests,
    required this.openComplaints,
    required this.overdueComplaints,
    required this.escalatedComplaints,
  });
}
