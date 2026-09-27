import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/withdrawal_request_entity.dart';
import '../repositories/finance_repository.dart';

class GetMerchantWithdrawalsUseCase {
  final FinanceRepository repository;
  GetMerchantWithdrawalsUseCase(this.repository);

  Future<Either<Failure, List<WithdrawalRequestEntity>>> call() async {
    return await repository.getMerchantWithdrawals();
  }
}