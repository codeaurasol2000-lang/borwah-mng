import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../domain/entities/finance_summary_entity.dart';
import '../../domain/entities/subscription_request_entity.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../datasources/finance_remote_data_source.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceRemoteDataSource remoteDataSource;

  FinanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FinanceSummaryEntity>> getFinanceSummary() async {
    try {
      final result = await remoteDataSource.getFinanceSummary();
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<BankAccountEntity>>> getBankAccounts() async {
    try {
      final result = await remoteDataSource.getBankAccounts();
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WithdrawalRequestEntity>>> getMerchantWithdrawals() async {
    try {
      final result = await remoteDataSource.getMerchantWithdrawals();
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<WithdrawalRequestEntity>>> getSupervisorWithdrawals() async {
    try {
      final result = await remoteDataSource.getSupervisorWithdrawals();
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<SubscriptionRequestEntity>>> getSubscriptions() async {
    try {
      final result = await remoteDataSource.getSubscriptions();
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> approveWithdrawal(String requestId) async {
    try {
      await remoteDataSource.approveWithdrawal(requestId);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> freezeWithdrawal(String requestId, String reason) async {
    try {
      await remoteDataSource.freezeWithdrawal(requestId, reason);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}