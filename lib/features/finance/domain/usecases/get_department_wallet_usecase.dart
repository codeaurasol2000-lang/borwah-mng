import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/department_wallet_entity.dart';
import '../repositories/finance_repository.dart';

class GetDepartmentWalletUseCase {
  final FinanceRepository repository;

  const GetDepartmentWalletUseCase(this.repository);

  Future<Either<Failure, DepartmentWalletEntity>> call(DepartmentType type) {
    return repository.getDepartmentWallet(type);
  }
}