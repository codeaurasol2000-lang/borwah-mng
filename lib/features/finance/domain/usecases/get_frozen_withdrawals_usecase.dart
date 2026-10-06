import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/withdrawal_request_entity.dart';
import '../repositories/finance_repository.dart';

class GetFrozenWithdrawalsUseCase {
  final FinanceRepository repository;

  GetFrozenWithdrawalsUseCase(this.repository);

  Future<Either<Failure, List<WithdrawalRequestEntity>>> call() {
    return repository.getFrozenWithdrawals();
  }
}
