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
  });
  Future<List<WithdrawalRequestEntity>> getMerchantWithdrawals();
  Future<WithdrawalRequestEntity> submitMerchantFinancialRequest({
    required String beneficiaryName,
    required String requestTitle,
    required String sourceAccount,
    required double amount,
    BeneficiaryType beneficiaryType = BeneficiaryType.merchant,
    FinancialOperationType operationType = FinancialOperationType.deposit,
  });
  Future<void> approveMerchantFinancialRequest(String requestId);
  Future<void> freezeMerchantFinancialRequest(String requestId, String reason);
  Future<void> rejectMerchantFinancialRequest(String requestId, String reason);
  Future<List<WithdrawalRequestEntity>> getSupervisorWithdrawals();
  Future<WithdrawalRequestEntity> submitSupervisorFinancialRequest({
    required String beneficiaryName,
    required String beneficiaryRole,
    required String sourceAccount,
    required double amount,
    required FinancialOperationType operationType,
    required String bankName,
    required String iban,
    required String transferMethod,
    required String dateText,
    String? reference,
    String? notes,
    String? settlementMode,
  });
  Future<WithdrawalRequestEntity> submitSupervisorWithdrawal({
    required String beneficiaryName,
    required String beneficiaryRole,
    required String sourceAccount,
    required double amount,
    FinancialOperationType operationType = FinancialOperationType.withdrawal,
    required String bankName,
    required String iban,
    required String transferMethod,
  });
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
  Future<void> rejectWithdrawal(String requestId, String reason);
}
