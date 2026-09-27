import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/bank_account_entity.dart';
import '../repositories/finance_repository.dart';

class GetBankAccountsUseCase {
  final FinanceRepository repository;
  GetBankAccountsUseCase(this.repository);

  Future<Either<Failure, List<BankAccountEntity>>> call() async {
    return await repository.getBankAccounts();
  }
}