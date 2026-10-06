import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/bank_account_edit_request_entity.dart';
import '../../domain/entities/bank_link_request_entity.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../domain/entities/department_wallet_entity.dart';
import '../../domain/entities/expense_request_entity.dart';
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
  Future<Either<Failure, List<BankAccountEditRequestEntity>>>
      getBankAccountEditRequests() async {
    try {
      final result = await remoteDataSource.getBankAccountEditRequests();
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, BankAccountEditRequestEntity>>
      submitBankAccountEditRequest({
    required String accountId,
    required String proposedBankName,
    required String proposedAccountType,
    required String proposedIban,
  }) async {
    try {
      final result = await remoteDataSource.submitBankAccountEditRequest(
        accountId: accountId,
        proposedBankName: proposedBankName,
        proposedAccountType: proposedAccountType,
        proposedIban: proposedIban,
      );
      return Right(result);
    } on ArgumentError catch (error) {
      return Left(ServerFailure(error.message.toString()));
    } on StateError catch (error) {
      return Left(ServerFailure(error.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ExpenseRequestEntity>>> getExpenseRequests() async {
    try {
      return Right(await remoteDataSource.getExpenseRequests());
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseRequestEntity>> submitExpenseRequest({
    required double amount,
    required String bankAccountId,
    required String reason,
    String? attachmentName,
  }) async {
    try {
      final request = await remoteDataSource.submitExpenseRequest(
        amount: amount,
        bankAccountId: bankAccountId,
        reason: reason,
        attachmentName: attachmentName,
      );
      return Right(request);
    } on ArgumentError catch (error) {
      return Left(ServerFailure(error.message.toString()));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
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
  Future<Either<Failure, List<WithdrawalRequestEntity>>> getFrozenWithdrawals() async {
    try {
      return Right(await remoteDataSource.getFrozenWithdrawals());
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> restoreFrozenWithdrawal(
    String requestId,
    BeneficiaryType beneficiaryType,
  ) async {
    try {
      await remoteDataSource.restoreFrozenWithdrawal(
          requestId, beneficiaryType);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectAndForfeitWithdrawal(
    String requestId,
    BeneficiaryType beneficiaryType,
    String reason,
  ) async {
    try {
      await remoteDataSource.rejectAndForfeitWithdrawal(
        requestId,
        beneficiaryType,
        reason,
      );
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BankLinkRequestEntity>>>
      getBankLinkRequests() async {
    try {
      return Right(await remoteDataSource.getBankLinkRequests());
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveBankLinkRequest(String requestId) async {
    try {
      await remoteDataSource.approveBankLinkRequest(requestId);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestIbanCertificate(
      String requestId) async {
    try {
      await remoteDataSource.requestIbanCertificate(requestId);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> freezeBankLinkRequest(
    String requestId,
    String reason,
  ) async {
    try {
      await remoteDataSource.freezeBankLinkRequest(requestId, reason);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectBankLinkRequest(
    String requestId,
    String reason,
  ) async {
    try {
      await remoteDataSource.rejectBankLinkRequest(requestId, reason);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> restoreFrozenBankLinkRequest(
      String requestId) async {
    try {
      await remoteDataSource.restoreFrozenBankLinkRequest(requestId);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectFrozenBankLinkRequest(
    String requestId,
    String reason,
  ) async {
    try {
      await remoteDataSource.rejectFrozenBankLinkRequest(requestId, reason);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
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
  Future<Either<Failure, DepartmentWalletEntity>> getDepartmentWallet(
      DepartmentType type) async {
    try {
      final result = await remoteDataSource.getDepartmentWallet(type);
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