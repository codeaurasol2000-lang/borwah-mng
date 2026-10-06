import 'package:equatable/equatable.dart';

enum ExpenseRequestStatus { pendingAdminApproval }

class ExpenseRequestEntity extends Equatable {
  final String id;
  final double amount;
  final String bankAccountId;
  final String bankName;
  final String reason;
  final String? attachmentName;
  final DateTime submittedAt;
  final ExpenseRequestStatus status;

  const ExpenseRequestEntity({
    required this.id,
    required this.amount,
    required this.bankAccountId,
    required this.bankName,
    required this.reason,
    this.attachmentName,
    required this.submittedAt,
    this.status = ExpenseRequestStatus.pendingAdminApproval,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        bankAccountId,
        bankName,
        reason,
        attachmentName,
        submittedAt,
        status,
      ];
}
