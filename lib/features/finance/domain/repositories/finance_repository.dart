import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/bank_account_entity.dart';
import '../entities/finance_summary_entity.dart';
import '../entities/subscription_request_entity.dart';
import '../entities/withdrawal_request_entity.dart';

abstract class FinanceRepository {
  Future<Either<Failure, FinanceSummaryEntity>> getFinanceSummary();
  Future<Either<Failure, List<BankAccountEntity>>> getBankAccounts();
  Future<Either<Failure, List<WithdrawalRequestEntity>>> getMerchantWithdrawals();
  Future<Either<Failure, List<WithdrawalRequestEntity>>> getSupervisorWithdrawals();
  Future<Either<Failure, List<SubscriptionRequestEntity>>> getSubscriptions();
  Future<Either<Failure, void>> approveWithdrawal(String requestId);
  Future<Either<Failure, void>> freezeWithdrawal(String requestId, String reason);
}