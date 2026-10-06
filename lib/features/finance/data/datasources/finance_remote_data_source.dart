import '../../domain/entities/bank_account_edit_request_entity.dart';
import '../../domain/entities/bank_link_request_entity.dart';
import '../models/bank_account_model.dart';
import '../../domain/entities/department_wallet_entity.dart';
import '../../domain/entities/expense_request_entity.dart';
import '../../domain/entities/finance_summary_entity.dart';
import '../../domain/entities/subscription_request_entity.dart';
import '../../domain/entities/withdrawal_request_entity.dart';

abstract class FinanceRemoteDataSource {
  Future<FinanceSummaryEntity> getFinanceSummary();
  Future<List<BankAccountModel>> getBankAccounts();
  Future<List<BankAccountEditRequestEntity>> getBankAccountEditRequests();
  Future<BankAccountEditRequestEntity> submitBankAccountEditRequest({
    required String accountId,
    required String proposedBankName,
    required String proposedAccountType,
    required String proposedIban,
  });
  Future<List<ExpenseRequestEntity>> getExpenseRequests();
  Future<ExpenseRequestEntity> submitExpenseRequest({
    required double amount,
    required String bankAccountId,
    required String reason,
    String? attachmentName,
  });
  Future<List<WithdrawalRequestEntity>> getMerchantWithdrawals();
  Future<List<WithdrawalRequestEntity>> getSupervisorWithdrawals();
  Future<List<WithdrawalRequestEntity>> getFrozenWithdrawals();
  Future<void> restoreFrozenWithdrawal(
      String requestId, BeneficiaryType beneficiaryType);
  Future<void> rejectAndForfeitWithdrawal(
    String requestId,
    BeneficiaryType beneficiaryType,
    String reason,
  );
  Future<List<BankLinkRequestEntity>> getBankLinkRequests();
  Future<void> approveBankLinkRequest(String requestId);
  Future<void> requestIbanCertificate(String requestId);
  Future<void> freezeBankLinkRequest(String requestId, String reason);
  Future<void> rejectBankLinkRequest(String requestId, String reason);
  Future<void> restoreFrozenBankLinkRequest(String requestId);
  Future<void> rejectFrozenBankLinkRequest(String requestId, String reason);
  Future<List<SubscriptionRequestEntity>> getSubscriptions();
  Future<DepartmentWalletEntity> getDepartmentWallet(DepartmentType type);
  Future<void> approveWithdrawal(String requestId);
  Future<void> freezeWithdrawal(String requestId, String reason);
}