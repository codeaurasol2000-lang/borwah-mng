import '../../domain/entities/wasalny_ad.dart';

abstract interface class WasalnyAdsDataSource {
  Future<List<WasalnyAd>> getAds();

  Future<WasalnyAd> updateAdStatus({
    required String id,
    required WasalnyAdStatus status,
    String? decisionNote,
  });
}
