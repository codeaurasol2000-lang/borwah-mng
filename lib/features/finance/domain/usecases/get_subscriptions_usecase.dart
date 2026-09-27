import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/subscription_request_entity.dart';
import '../repositories/finance_repository.dart';

class GetSubscriptionsUseCase {
  final FinanceRepository repository;
  GetSubscriptionsUseCase(this.repository);

  Future<Either<Failure, List<SubscriptionRequestEntity>>> call() async {
    return await repository.getSubscriptions();
  }
}