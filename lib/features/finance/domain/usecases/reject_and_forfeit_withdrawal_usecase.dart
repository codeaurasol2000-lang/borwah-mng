import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/withdrawal_request_entity.dart';
import '../repositories/finance_repository.dart';

class RejectAndForfeitWithdrawalUseCase {
  final FinanceRepository repository;

  RejectAndForfeitWithdrawalUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String requestId,
    required BeneficiaryType beneficiaryType,
    required String reason,
  }) {
    return repository.rejectAndForfeitWithdrawal(
      requestId,
      beneficiaryType,
      reason,
    );
  }
}
