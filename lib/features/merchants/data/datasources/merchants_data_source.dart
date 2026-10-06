import '../../domain/entities/merchant_entity.dart';
import '../models/merchant_model.dart';
import '../models/supervisor_stats_model.dart';

abstract class MerchantsDataSource {
  Future<List<MerchantModel>> getMerchants();
  Future<List<MerchantModel>> getSupervisedMerchants();
  Future<SupervisorStatsModel> getSupervisorStats();
  Future<List<MerchantModel>> searchAndFilterMerchants({
    String? query,
    MerchantStatus? statusFilter,
  });
}
