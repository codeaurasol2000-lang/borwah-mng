import '../entities/merchant_entity.dart';
import '../entities/supervisor_stats_entity.dart';

abstract class MerchantsRepository {
  Future<List<MerchantEntity>> getMerchants();
  Future<List<MerchantEntity>> getSupervisedMerchants();
  Future<SupervisorStatsEntity> getSupervisorStats();
  Future<List<MerchantEntity>> searchAndFilterMerchants({
    String? query,
    MerchantStatus? statusFilter,
  });
}
