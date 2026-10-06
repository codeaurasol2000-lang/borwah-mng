import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/finance_repository.dart';

class FreezeBankLinkRequestUseCase {
  final FinanceRepository repository;

  FreezeBankLinkRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId, String reason) {
    return repository.freezeBankLinkRequest(requestId, reason);
  }
}
