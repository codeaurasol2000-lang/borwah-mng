import '../models/bank_account_model.dart';
import '../../domain/entities/finance_summary_entity.dart';
import '../../domain/entities/subscription_request_entity.dart';
import '../../domain/entities/withdrawal_request_entity.dart';

abstract class FinanceRemoteDataSource {
  Future<FinanceSummaryEntity> getFinanceSummary();
  Future<List<BankAccountModel>> getBankAccounts();
  Future<List<WithdrawalRequestEntity>> getMerchantWithdrawals();
  Future<List<WithdrawalRequestEntity>> getSupervisorWithdrawals();
  Future<List<SubscriptionRequestEntity>> getSubscriptions();
  Future<void> approveWithdrawal(String requestId);
  Future<void> freezeWithdrawal(String requestId, String reason);
}