import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wasalny_ad.dart';
import '../../domain/usecases/get_wasalny_ads_usecase.dart';
import '../../domain/usecases/update_wasalny_ad_status_usecase.dart';

sealed class WasalnyAdsState {
  const WasalnyAdsState();
}

class WasalnyAdsLoading extends WasalnyAdsState {
  const WasalnyAdsLoading();
}

class WasalnyAdsLoadFailure extends WasalnyAdsState {
  final Object error;

  const WasalnyAdsLoadFailure(this.error);
}

class WasalnyAdsLoaded extends WasalnyAdsState {
  final List<WasalnyAd> ads;

  const WasalnyAdsLoaded(this.ads);
}

class WasalnyAdsCubit extends Cubit<WasalnyAdsState> {
  final GetWasalnyAdsUseCase getAds;
  final UpdateWasalnyAdStatusUseCase updateAdStatus;

  WasalnyAdsCubit({
    required this.getAds,
    required this.updateAdStatus,
  }) : super(const WasalnyAdsLoading());

  Future<void> loadAds() async {
    emit(const WasalnyAdsLoading());
    try {
      emit(WasalnyAdsLoaded(await getAds()));
    } catch (error) {
      emit(WasalnyAdsLoadFailure(error));
    }
  }

  Future<bool> decide({
    required String id,
    required WasalnyAdStatus status,
    String? decisionNote,
  }) async {
    final current = state;
    if (current is! WasalnyAdsLoaded) return false;
    try {
      final updated = await updateAdStatus(
        id: id,
        status: status,
        decisionNote: decisionNote,
      );
      emit(
        WasalnyAdsLoaded([
          for (final ad in current.ads) ad.id == id ? updated : ad,
        ]),
      );
      return true;
    } catch (error) {
      emit(WasalnyAdsLoadFailure(error));
      return false;
    }
  }
}
