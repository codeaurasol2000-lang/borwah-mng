import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/bank_account_edit_request_entity.dart';
import '../entities/bank_link_request_entity.dart';
import '../entities/bank_account_entity.dart';
import '../entities/department_wallet_entity.dart';
import '../entities/expense_request_entity.dart';
import '../entities/finance_summary_entity.dart';
import '../entities/subscription_request_entity.dart';
import '../entities/withdrawal_request_entity.dart';

abstract class FinanceRepository {
  Future<Either<Failure, FinanceSummaryEntity>> getFinanceSummary();
  Future<Either<Failure, List<BankAccountEntity>>> getBankAccounts();
  Future<Either<Failure, List<BankAccountEditRequestEntity>>>
      getBankAccountEditRequests();
  Future<Either<Failure, BankAccountEditRequestEntity>>
      submitBankAccountEditRequest({
    required String accountId,
    required String proposedBankName,
    required String proposedAccountType,
    required String proposedIban,
  });
  Future<Either<Failure, List<ExpenseRequestEntity>>> getExpenseRequests();
  Future<Either<Failure, ExpenseRequestEntity>> submitExpenseRequest({
    required double amount,
    required String bankAccountId,
    required String reason,
    String? attachmentName,
  });
  Future<Either<Failure, List<WithdrawalRequestEntity>>> getMerchantWithdrawals();
  Future<Either<Failure, List<WithdrawalRequestEntity>>> getSupervisorWithdrawals();
  Future<Either<Failure, List<WithdrawalRequestEntity>>> getFrozenWithdrawals();
  Future<Either<Failure, void>> restoreFrozenWithdrawal(
      String requestId, BeneficiaryType beneficiaryType);
  Future<Either<Failure, void>> rejectAndForfeitWithdrawal(
    String requestId,
    BeneficiaryType beneficiaryType,
    String reason,
  );
  Future<Either<Failure, List<BankLinkRequestEntity>>> getBankLinkRequests();
  Future<Either<Failure, void>> approveBankLinkRequest(String requestId);
  Future<Either<Failure, void>> requestIbanCertificate(String requestId);
  Future<Either<Failure, void>> freezeBankLinkRequest(
      String requestId, String reason);
  Future<Either<Failure, void>> rejectBankLinkRequest(
      String requestId, String reason);
  Future<Either<Failure, void>> restoreFrozenBankLinkRequest(String requestId);
  Future<Either<Failure, void>> rejectFrozenBankLinkRequest(
      String requestId, String reason);
  Future<Either<Failure, List<SubscriptionRequestEntity>>> getSubscriptions();
  Future<Either<Failure, DepartmentWalletEntity>> getDepartmentWallet(
      DepartmentType type);
  Future<Either<Failure, void>> approveWithdrawal(String requestId);
  Future<Either<Failure, void>> freezeWithdrawal(String requestId, String reason);
}