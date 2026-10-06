import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/finance_repository.dart';

class RejectBankLinkRequestUseCase {
  final FinanceRepository repository;

  RejectBankLinkRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId, String reason) {
    return repository.rejectBankLinkRequest(requestId, reason);
  }
}
