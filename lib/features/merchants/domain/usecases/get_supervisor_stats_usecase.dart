import '../entities/supervisor_stats_entity.dart';
import '../repositories/merchants_repository.dart';

class GetSupervisorStatsUseCase {
  final MerchantsRepository repository;

  GetSupervisorStatsUseCase({required this.repository});

  Future<SupervisorStatsEntity> call() async {
    return await repository.getSupervisorStats();
  }
}

