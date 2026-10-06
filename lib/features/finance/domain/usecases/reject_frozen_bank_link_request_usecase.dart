import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/finance_repository.dart';

class RejectFrozenBankLinkRequestUseCase {
  final FinanceRepository repository;

  RejectFrozenBankLinkRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId, String reason) {
    return repository.rejectFrozenBankLinkRequest(requestId, reason);
  }
}
