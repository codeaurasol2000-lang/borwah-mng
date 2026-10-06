import 'package:equatable/equatable.dart';

enum BankLinkRequestStatus {
  pending,
  pendingManagementApproval,
  ibanCertificateRequested,
  frozen,
  rejected,
}

class BankLinkRequestEntity extends Equatable {
  final String id;
  final String commercialName;
  final String beneficiaryName;
  final String iban;
  final String bankName;
  final String crNumber;
  final String crExpiry;
  final String documentName;
  final String amlScore;
  final String requestType;
  final String matchDescription;
  final String warningNote;
  final String? commercialNameEn;
  final String? beneficiaryNameEn;
  final String? bankNameEn;
  final String? crExpiryEn;
  final String? requestTypeEn;
  final String? matchDescriptionEn;
  final String? warningNoteEn;
  final BankLinkRequestStatus status;
  final String? decisionReason;

  const BankLinkRequestEntity({
    required this.id,
    required this.commercialName,
    required this.beneficiaryName,
    required this.iban,
    required this.bankName,
    required this.crNumber,
    required this.crExpiry,
    required this.documentName,
    required this.amlScore,
    required this.requestType,
    required this.matchDescription,
    this.warningNote = '',
    this.commercialNameEn,
    this.beneficiaryNameEn,
    this.bankNameEn,
    this.crExpiryEn,
    this.requestTypeEn,
    this.matchDescriptionEn,
    this.warningNoteEn,
    this.status = BankLinkRequestStatus.pending,
    this.decisionReason,
  });

  String getCommercialName(bool isArabic) =>
      isArabic ? commercialName : (commercialNameEn ?? commercialName);
  String getBeneficiaryName(bool isArabic) =>
      isArabic ? beneficiaryName : (beneficiaryNameEn ?? beneficiaryName);
  String getBankName(bool isArabic) =>
      isArabic ? bankName : (bankNameEn ?? bankName);
  String getCrExpiry(bool isArabic) =>
      isArabic ? crExpiry : (crExpiryEn ?? crExpiry);
  String getRequestType(bool isArabic) =>
      isArabic ? requestType : (requestTypeEn ?? requestType);
  String getMatchDescription(bool isArabic) =>
      isArabic ? matchDescription : (matchDescriptionEn ?? matchDescription);
  String getWarningNote(bool isArabic) =>
      isArabic ? warningNote : (warningNoteEn ?? warningNote);

  BankLinkRequestEntity copyWith({
    BankLinkRequestStatus? status,
    String? decisionReason,
    bool clearDecisionReason = false,
  }) =>
      BankLinkRequestEntity(
        id: id,
        commercialName: commercialName,
        beneficiaryName: beneficiaryName,
        iban: iban,
        bankName: bankName,
        crNumber: crNumber,
        crExpiry: crExpiry,
        documentName: documentName,
        amlScore: amlScore,
        requestType: requestType,
        matchDescription: matchDescription,
        warningNote: warningNote,
        commercialNameEn: commercialNameEn,
        beneficiaryNameEn: beneficiaryNameEn,
        bankNameEn: bankNameEn,
        crExpiryEn: crExpiryEn,
        requestTypeEn: requestTypeEn,
        matchDescriptionEn: matchDescriptionEn,
        warningNoteEn: warningNoteEn,
        status: status ?? this.status,
        decisionReason:
            clearDecisionReason ? null : decisionReason ?? this.decisionReason,
      );

  @override
  List<Object?> get props => [
        id,
        commercialName,
        beneficiaryName,
        iban,
        bankName,
        crNumber,
        crExpiry,
        documentName,
        amlScore,
        requestType,
        matchDescription,
        warningNote,
        commercialNameEn,
        beneficiaryNameEn,
        bankNameEn,
        crExpiryEn,
        requestTypeEn,
        matchDescriptionEn,
        warningNoteEn,
        status,
        decisionReason,
      ];
}
