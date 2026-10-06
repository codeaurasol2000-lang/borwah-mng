import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/bank_link_request_entity.dart';
import '../repositories/finance_repository.dart';

class GetBankLinkRequestsUseCase {
  final FinanceRepository repository;

  GetBankLinkRequestsUseCase(this.repository);

  Future<Either<Failure, List<BankLinkRequestEntity>>> call() {
    return repository.getBankLinkRequests();
  }
}
