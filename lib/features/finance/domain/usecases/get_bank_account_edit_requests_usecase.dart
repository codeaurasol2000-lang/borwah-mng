import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/bank_account_edit_request_entity.dart';
import '../repositories/finance_repository.dart';

class GetBankAccountEditRequestsUseCase {
  final FinanceRepository repository;

  GetBankAccountEditRequestsUseCase(this.repository);

  Future<Either<Failure, List<BankAccountEditRequestEntity>>> call() {
    return repository.getBankAccountEditRequests();
  }
}
