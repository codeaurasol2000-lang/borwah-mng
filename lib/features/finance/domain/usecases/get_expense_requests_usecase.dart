import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/expense_request_entity.dart';
import '../repositories/finance_repository.dart';

class GetExpenseRequestsUseCase {
  final FinanceRepository repository;

  GetExpenseRequestsUseCase(this.repository);

  Future<Either<Failure, List<ExpenseRequestEntity>>> call() {
    return repository.getExpenseRequests();
  }
}
