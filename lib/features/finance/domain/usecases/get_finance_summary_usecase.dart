import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/finance_summary_entity.dart';
import '../repositories/finance_repository.dart';

class GetFinanceSummaryUseCase {
  final FinanceRepository repository;
  GetFinanceSummaryUseCase(this.repository);

  Future<Either<Failure, FinanceSummaryEntity>> call() async {
    return await repository.getFinanceSummary();
  }
}