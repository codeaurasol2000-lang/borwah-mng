import 'package:equatable/equatable.dart';

enum BankAccountEditRequestStatus { pending, approved, rejected }

class BankAccountEditRequestEntity extends Equatable {
  final String id;
  final String accountId;
  final String bankName;
  final String accountType;
  final String iban;
  final String proposedBankName;
  final String proposedAccountType;
  final String proposedIban;
  final DateTime submittedAt;
  final BankAccountEditRequestStatus status;

  const BankAccountEditRequestEntity({
    required this.id,
    required this.accountId,
    required this.bankName,
    required this.accountType,
    required this.iban,
    required this.proposedBankName,
    required this.proposedAccountType,
    required this.proposedIban,
    required this.submittedAt,
    this.status = BankAccountEditRequestStatus.pending,
  });

  @override
  List<Object> get props => [
        id,
        accountId,
        bankName,
        accountType,
        iban,
        proposedBankName,
        proposedAccountType,
        proposedIban,
        submittedAt,
        status,
      ];
}
