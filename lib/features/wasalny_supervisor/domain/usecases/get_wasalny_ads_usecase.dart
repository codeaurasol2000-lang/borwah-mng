import '../entities/wasalny_ad.dart';
import '../repositories/wasalny_ads_repository.dart';

class GetWasalnyAdsUseCase {
  final WasalnyAdsRepository repository;

  const GetWasalnyAdsUseCase({required this.repository});

  Future<List<WasalnyAd>> call() => repository.getAds();
}
