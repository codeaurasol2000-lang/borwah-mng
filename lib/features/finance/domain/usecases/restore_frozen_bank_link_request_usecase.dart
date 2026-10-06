import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/finance_repository.dart';

class RestoreFrozenBankLinkRequestUseCase {
  final FinanceRepository repository;

  RestoreFrozenBankLinkRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId) {
    return repository.restoreFrozenBankLinkRequest(requestId);
  }
}
