import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/finance_repository.dart';

class ApproveBankLinkRequestUseCase {
  final FinanceRepository repository;

  ApproveBankLinkRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId) {
    return repository.approveBankLinkRequest(requestId);
  }
}
