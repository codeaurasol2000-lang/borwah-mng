class SupervisorStatsEntity {
  final String supervisorName;
  final String supervisorNameEn;
  final String supervisorTag;
  final String supervisorTagEn;
  final String region;
  final String regionEn;
  final int approvedMerchantsCount;
  final int pendingReviewCount;
  final int totalCount;
  final int activeVerifiedCount;
  final int underAuditCount;
  final int updateRequiredCount;
  final int suspendedCount;
  final int compliancePercentage;
  final int pendingAlertsCount;
  final String supervisorCode;
  final String supervisorFullName;
  final String supervisorFullNameEn;
  final String supervisionScope;
  final String supervisionScopeEn;

  const SupervisorStatsEntity({
    required this.supervisorName,
    required this.supervisorNameEn,
    required this.supervisorTag,
    required this.supervisorTagEn,
    required this.region,
    required this.regionEn,
    required this.approvedMerchantsCount,
    required this.pendingReviewCount,
    required this.totalCount,
    required this.activeVerifiedCount,
    required this.underAuditCount,
    required this.updateRequiredCount,
    required this.suspendedCount,
    this.compliancePercentage = 94,
    this.pendingAlertsCount = 2,
    this.supervisorCode = 'SUP-4092',
    this.supervisorFullName = 'أحمد بن عبد العزيز الخضيري',
    this.supervisorFullNameEn = 'Ahmed bin Abdulaziz Al-Khudairi',
    this.supervisionScope = 'منطقة الرياض (وسط وشمال العاصمة)',
    this.supervisionScopeEn = 'Riyadh Region (Central & North)',
  });

  String getSupervisorName(bool isArabic) =>
      isArabic ? supervisorName : supervisorNameEn;
  String getSupervisorTag(bool isArabic) =>
      isArabic ? supervisorTag : supervisorTagEn;
  String getRegion(bool isArabic) => isArabic ? region : regionEn;
  String getSupervisorFullName(bool isArabic) =>
      isArabic ? supervisorFullName : supervisorFullNameEn;
  String getSupervisionScope(bool isArabic) =>
      isArabic ? supervisionScope : supervisionScopeEn;
}
