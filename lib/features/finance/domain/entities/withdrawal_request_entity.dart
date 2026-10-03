import 'package:equatable/equatable.dart';

enum BeneficiaryType { merchant, user, supervisor, serviceProvider }
enum RequestStatus { pending, underInvestigation, approved, frozen, rejected }

class WithdrawalRequestEntity extends Equatable {
  final String id;
  final String requestNumber;          // مثل: #TRD-8821 أو #SUP-409
  final String beneficiaryName;        // متجر الأفق، أ. سعد العتيبي..
  final String beneficiaryRole;        // فني صيانة، مشرف تجار معتمد..
  final BeneficiaryType beneficiaryType;
  final double grossAmount;            // إجمالي المبلغ المطلوب
  final double platformFeePercentage;  // نسبة عمولة المنصة
  final double platformFeeAmount;      // قيمة العمولة بالريال
  final double netAmount;              // صافي المبلغ المستحق للصرف
  final String bankName;               // مصرف الراجحي، البنك الأهلي السعودي..
  final String iban;
  final String dateText;
  final RequestStatus status;
  final String? auditCheckResult;      // نتيجة الفحص الآلي
  final String? alertNotice;           // مذكرة الإشعار الرقابي إن وجدت
  final bool isInstantTransferReady;   // هل متاح للصرف الفوري
  final String? sourceOfFunds;         // مصدر المستحقات أو تفاصيل الإنجاز الميداني
  final String? transferMethod;        // طريقة التحويل

  const WithdrawalRequestEntity({
    required this.id,
    required this.requestNumber,
    required this.beneficiaryName,
    required this.beneficiaryRole,
    required this.beneficiaryType,
    required this.grossAmount,
    required this.platformFeePercentage,
    required this.platformFeeAmount,
    required this.netAmount,
    required this.bankName,
    required this.iban,
    required this.dateText,
    required this.status,
    this.auditCheckResult,
    this.alertNotice,
    this.isInstantTransferReady = false,
    this.sourceOfFunds,
    this.transferMethod,
  });

  WithdrawalRequestEntity copyWith({
    String? id,
    String? requestNumber,
    String? beneficiaryName,
    String? beneficiaryRole,
    BeneficiaryType? beneficiaryType,
    double? grossAmount,
    double? platformFeePercentage,
    double? platformFeeAmount,
    double? netAmount,
    String? bankName,
    String? iban,
    String? dateText,
    RequestStatus? status,
    String? auditCheckResult,
    String? alertNotice,
    bool? isInstantTransferReady,
    String? sourceOfFunds,
    String? transferMethod,
  }) {
    return WithdrawalRequestEntity(
      id: id ?? this.id,
      requestNumber: requestNumber ?? this.requestNumber,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      beneficiaryRole: beneficiaryRole ?? this.beneficiaryRole,
      beneficiaryType: beneficiaryType ?? this.beneficiaryType,
      grossAmount: grossAmount ?? this.grossAmount,
      platformFeePercentage: platformFeePercentage ?? this.platformFeePercentage,
      platformFeeAmount: platformFeeAmount ?? this.platformFeeAmount,
      netAmount: netAmount ?? this.netAmount,
      bankName: bankName ?? this.bankName,
      iban: iban ?? this.iban,
      dateText: dateText ?? this.dateText,
      status: status ?? this.status,
      auditCheckResult: auditCheckResult ?? this.auditCheckResult,
      alertNotice: alertNotice ?? this.alertNotice,
      isInstantTransferReady: isInstantTransferReady ?? this.isInstantTransferReady,
      sourceOfFunds: sourceOfFunds ?? this.sourceOfFunds,
      transferMethod: transferMethod ?? this.transferMethod,
    );
  }

  @override
  List<Object?> get props => [id, requestNumber, netAmount, status];
}