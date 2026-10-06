import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/withdrawal_request_entity.dart';
import '../repositories/finance_repository.dart';

class RestoreFrozenWithdrawalUseCase {
  final FinanceRepository repository;

  RestoreFrozenWithdrawalUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String requestId,
    required BeneficiaryType beneficiaryType,
  }) {
    return repository.restoreFrozenWithdrawal(requestId, beneficiaryType);
  }
}
