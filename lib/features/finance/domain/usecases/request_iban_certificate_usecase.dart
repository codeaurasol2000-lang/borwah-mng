import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/finance_repository.dart';

class RequestIbanCertificateUseCase {
  final FinanceRepository repository;

  RequestIbanCertificateUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId) {
    return repository.requestIbanCertificate(requestId);
  }
}
