import '../entities/merchant_entity.dart';
import '../repositories/merchants_repository.dart';

class GetSupervisedMerchantsUseCase {
  final MerchantsRepository repository;

  GetSupervisedMerchantsUseCase({required this.repository});

  Future<List<MerchantEntity>> call() async {
    return await repository.getSupervisedMerchants();
  }
}

