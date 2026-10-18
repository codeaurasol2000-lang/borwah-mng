import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../finance/domain/entities/withdrawal_request_entity.dart';
import '../../../finance/domain/repositories/finance_repository.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/merchant_advertisement_local_store.dart';
import '../../data/merchant_supervisor_local_store.dart';
import '../../domain/entities/merchant_entity.dart';
import 'merchant_financial_request_events.dart';
import 'advertisement_review_details_screen.dart';

enum _AdCategory { vehicles, electronics, realEstate }

enum _AdStatus {
  pending,
  awaitingFinance,
  awaitingManagement,
  approved,
  rejected,
  suspended,
}

enum _AdRejectionReason { price, misleading, photos, policy }
enum _SummaryFilter { hidden, approved, underReview, urgent }

class _AdRecord {
  final int id;
  final _AdCategory category;
  final IconData imageIcon;
  final Color imageColor;
  final int imageCount;
  final int receivedMinutesAgo;
  final bool hasMarketPriceBadge;
  final bool isPremium;
  final double premiumFee;

  const _AdRecord({
    required this.id,
    required this.category,
    required this.imageIcon,
    required this.imageColor,
    required this.imageCount,
    required this.receivedMinutesAgo,
    this.hasMarketPriceBadge = false,
    this.isPremium = false,
    this.premiumFee = 0,
  });
}

class AdsManagementScreen extends StatefulWidget {
  final int refreshToken;

  const AdsManagementScreen({super.key, this.refreshToken = 0});

  @override
  State<AdsManagementScreen> createState() => _AdsManagementScreenState();
}

class _AdsManagementScreenState extends State<AdsManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<_AdRecord> _ads = const [
    _AdRecord(
      id: 1,
      category: _AdCategory.vehicles,
      imageIcon: Icons.directions_car_filled_outlined,
      imageColor: AppColors.hexFF476176,
      imageCount: 8,
      receivedMinutesAgo: 25,
      hasMarketPriceBadge: true,
      isPremium: true,
      premiumFee: 500,
    ),
    _AdRecord(
      id: 2,
      category: _AdCategory.electronics,
      imageIcon: Icons.smartphone,
      imageColor: AppColors.hexFF8DA5B7,
      imageCount: 5,
      receivedMinutesAgo: 40,
    ),
    _AdRecord(
      id: 3,
      category: _AdCategory.realEstate,
      imageIcon: Icons.villa_outlined,
      imageColor: AppColors.hexFF6E765D,
      imageCount: 14,
      receivedMinutesAgo: 120,
    ),
  ];
  final Map<int, _AdStatus> _statuses = {};
  final Map<int, double> _deliveryFees = {};
  final Map<int, String> _editRequests = {};
  final Map<int, ({_AdRejectionReason reason, String guidance})> _rejections =
      {};
  final Set<int> _hiddenAds = {};
  bool _showArchive = false;
  bool _isLoadingActions = true;
  Object? _loadError;
  String _searchQuery = '';
  _AdCategory? _categoryFilter;
  bool _newestFirst = true;
  _SummaryFilter? _summaryFilter;
  DateTime _lastUpdatedAt = DateTime.now();

  static const _savedActionsKey = 'merchant_supervisor_ad_actions_v1';
  static const _financialRequestsKey =
      'merchant_supervisor_financial_requests_v1';

  @override
  void initState() {
    super.initState();
    MerchantAdvertisementLocalStore.version.addListener(
      _refreshSharedStatuses,
    );
    _loadSavedActions().then((_) => _refreshSharedStatuses());
  }

  @override
  void didUpdateWidget(covariant AdsManagementScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      _syncFinanceDecisions();
    }
  }

  @override
  void dispose() {
    MerchantAdvertisementLocalStore.version.removeListener(
      _refreshSharedStatuses,
    );
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshSharedStatuses() async {
    try {
      final statuses = await MerchantAdvertisementLocalStore.loadStatuses();
      if (!mounted) return;
      setState(() {
        for (final ad in _ads) {
          final status = statuses[_adReference(ad)];
          if (status != null) _statuses[ad.id] = _localStatusFor(status);
          if (status == MerchantAdvertisementStatus.hidden) {
            _hiddenAds.add(ad.id);
          } else {
            _hiddenAds.remove(ad.id);
          }
        }
        _lastUpdatedAt = DateTime.now();
      });
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant advertisement status refresh',
        ),
      );
      if (mounted) {
        _showMessage(
          AppLocalizations.of(context)!,
          AppLocalizations.of(context)!.adsLoadFailed,
        );
      }
    }
  }

  Future<void> _syncFinanceDecisions() async {
    try {
      final result = await sl<FinanceRepository>().getMerchantWithdrawals();
      final financeRequests = result.fold(
        (failure) => throw StateError(failure.message),
        (requests) => requests,
      );
      final updates = <_AdRecord, _AdStatus>{};
      for (final ad in _ads) {
        if (_statuses[ad.id] != _AdStatus.awaitingFinance) continue;
        final requestId = 'AD-FEE-${_adReference(ad)}';
        final request = financeRequests.where(
          (item) => item.sourceAccount == requestId,
        );
        if (request.isEmpty) continue;
        final nextStatus = switch (request.first.status) {
          RequestStatus.approved => _AdStatus.approved,
          RequestStatus.rejected => _AdStatus.rejected,
          RequestStatus.frozen ||
          RequestStatus.underInvestigation =>
            _AdStatus.suspended,
          _ => _AdStatus.awaitingFinance,
        };
        if (nextStatus != _AdStatus.awaitingFinance) {
          updates[ad] = nextStatus;
        }
      }
      if (updates.isEmpty || !mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        for (final entry in updates.entries) {
          _statuses[entry.key.id] = entry.value;
        }
        _lastUpdatedAt = DateTime.now();
      });
      await _persistActions();
      for (final entry in updates.entries) {
        final status = switch (entry.value) {
          _AdStatus.approved => MerchantAdvertisementStatus.approved,
          _AdStatus.rejected => MerchantAdvertisementStatus.rejected,
          _AdStatus.suspended => MerchantAdvertisementStatus.frozen,
          _ => MerchantAdvertisementStatus.awaitingFinance,
        };
        await MerchantAdvertisementLocalStore.saveStatus(
          reference: _adReference(entry.key),
          status: status,
        );
        await MerchantSupervisorLocalStore.recordAction(
          action: switch (entry.value) {
            _AdStatus.approved => l10n.adsApprovedStatus,
            _AdStatus.rejected => l10n.adsRejectedStatus,
            _AdStatus.suspended => l10n.adsFrozenStatus,
            _ => l10n.adsPremiumWaitingFinance,
          },
          subject: _adTitle(l10n, entry.key),
          details: _adReference(entry.key),
        );
      }
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant advertisement finance status',
        ),
      );
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        _showMessage(l10n, l10n.adsLoadFailed);
      }
    }
  }

  _AdStatus _localStatusFor(MerchantAdvertisementStatus status) =>
      switch (status) {
        MerchantAdvertisementStatus.approved => _AdStatus.approved,
        MerchantAdvertisementStatus.awaitingFinance =>
          _AdStatus.awaitingFinance,
        MerchantAdvertisementStatus.awaitingManagement =>
          _AdStatus.awaitingManagement,
        MerchantAdvertisementStatus.underReview => _AdStatus.pending,
        MerchantAdvertisementStatus.rejected => _AdStatus.rejected,
        MerchantAdvertisementStatus.frozen => _AdStatus.suspended,
        MerchantAdvertisementStatus.hidden => _AdStatus.pending,
      };

  MerchantAdvertisementStatus _sharedStatusFor(
    _AdStatus status, {
    required bool hidden,
  }) {
    if (hidden) return MerchantAdvertisementStatus.hidden;
    return switch (status) {
      _AdStatus.pending => MerchantAdvertisementStatus.underReview,
      _AdStatus.awaitingFinance => MerchantAdvertisementStatus.awaitingFinance,
      _AdStatus.awaitingManagement =>
        MerchantAdvertisementStatus.awaitingManagement,
      _AdStatus.approved => MerchantAdvertisementStatus.approved,
      _AdStatus.rejected => MerchantAdvertisementStatus.rejected,
      _AdStatus.suspended => MerchantAdvertisementStatus.frozen,
    };
  }

  Future<void> _loadSavedActions() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = preferences.getString(_savedActionsKey);
      if (saved == null) {
        if (mounted) setState(() => _isLoadingActions = false);
        return;
      }

      final decoded = jsonDecode(saved);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'Saved advertisement actions are invalid.',
        );
      }
      final statusEntries = decoded['statuses'];
      final hiddenEntries = decoded['hidden'];
      final rejectionEntries = decoded['rejections'] ?? <String, dynamic>{};
      final feeEntries = decoded['deliveryFees'] ?? <String, dynamic>{};
      final editRequestEntries = decoded['editRequests'] ?? <String, dynamic>{};
      if (statusEntries is! Map<String, dynamic> ||
          hiddenEntries is! List ||
          rejectionEntries is! Map<String, dynamic> ||
          feeEntries is! Map<String, dynamic> ||
          editRequestEntries is! Map<String, dynamic>) {
        throw const FormatException(
          'Saved advertisement action fields are invalid.',
        );
      }

      final statuses = <int, _AdStatus>{};
      for (final entry in statusEntries.entries) {
        final id = int.tryParse(entry.key);
        final statusName = entry.value;
        if (id == null || statusName is! String) {
          throw const FormatException(
            'Saved advertisement status is invalid.',
          );
        }
        statuses[id] = _AdStatus.values.byName(statusName);
      }
      final hidden = hiddenEntries.map((value) {
        if (value is! int) {
          throw const FormatException('Saved hidden advertisement is invalid.');
        }
        return value;
      }).toSet();
      final rejections =
          <int, ({_AdRejectionReason reason, String guidance})>{};
      for (final entry in rejectionEntries.entries) {
        final id = int.tryParse(entry.key);
        final value = entry.value;
        if (id == null ||
            value is! Map<String, dynamic> ||
            value['reason'] is! String ||
            value['guidance'] is! String) {
          throw const FormatException(
            'Saved advertisement rejection is invalid.',
          );
        }
        rejections[id] = (
          reason: _AdRejectionReason.values.byName(value['reason'] as String),
          guidance: value['guidance'] as String,
        );
      }
      final fees = <int, double>{};
      for (final entry in feeEntries.entries) {
        final id = int.tryParse(entry.key);
        final value = entry.value;
        if (id == null || value is! num || !value.isFinite || value < 0) {
          throw const FormatException(
              'Saved advertisement delivery fee is invalid.');
        }
        fees[id] = value.toDouble();
      }
      final editRequests = <int, String>{};
      for (final entry in editRequestEntries.entries) {
        final id = int.tryParse(entry.key);
        if (id == null || entry.value is! String) {
          throw const FormatException('Saved advertisement edit request is invalid.');
        }
        editRequests[id] = entry.value as String;
      }
      if (!mounted) return;
      setState(() {
        _statuses.addAll(statuses);
        _hiddenAds.addAll(hidden);
        _rejections.addAll(rejections);
        _deliveryFees.addAll(fees);
        _editRequests.addAll(editRequests);
        _isLoadingActions = false;
      });
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant advertisement review',
        ),
      );
      if (mounted) {
        setState(() {
          _loadError = error;
          _isLoadingActions = false;
        });
      }
    }
  }

  Future<void> _persistActions() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _savedActionsKey,
      jsonEncode({
        'statuses': _statuses.map(
          (id, status) => MapEntry(id.toString(), status.name),
        ),
        'hidden': _hiddenAds.toList(),
        'rejections': _rejections.map(
          (id, rejection) => MapEntry(id.toString(), {
            'reason': rejection.reason.name,
            'guidance': rejection.guidance,
          }),
        ),
        'deliveryFees': _deliveryFees.map(
          (id, fee) => MapEntry(id.toString(), fee),
        ),
        'editRequests': _editRequests.map(
          (id, note) => MapEntry(id.toString(), note),
        ),
      }),
    );
    if (!saved) throw StateError('Could not save advertisement actions.');
  }

  Future<void> _saveDeliveryFee(
    AppLocalizations l10n,
    _AdRecord ad,
    double fee,
  ) async {
    if (!fee.isFinite || fee < 0) {
      _showMessage(l10n, l10n.adsFeeInvalid);
      return;
    }
    final previous = _deliveryFees[ad.id];
    setState(() {
      _deliveryFees[ad.id] = fee;
      _lastUpdatedAt = DateTime.now();
    });
    try {
      await _persistActions();
      await MerchantSupervisorLocalStore.recordAction(
        action: l10n.adsDeliveryFee,
        subject: _adTitle(l10n, ad),
        details: '$fee ${l10n.finRequestCurrency}',
      );
      if (mounted) _showMessage(l10n, l10n.adsFeeUpdated);
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant advertisement delivery fee',
        ),
      );
      if (!mounted) return;
      setState(() {
        if (previous == null) {
          _deliveryFees.remove(ad.id);
        } else {
          _deliveryFees[ad.id] = previous;
        }
      });
      _showMessage(l10n, l10n.adsSaveFailed);
    }
  }

  Future<void> _requestAdEdit(
    AppLocalizations l10n,
    _AdRecord ad,
    String note,
  ) async {
    final previous = _editRequests[ad.id];
    setState(() {
      _editRequests[ad.id] = note;
      _lastUpdatedAt = DateTime.now();
    });
    try {
      await _persistActions();
      await MerchantSupervisorLocalStore.recordAction(
        action: l10n.adsRequestEdit,
        subject: _adTitle(l10n, ad),
        details: note,
      );
      if (mounted) _showMessage(l10n, l10n.adsRequestEdit);
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'merchant advertisement edit request',
      ));
      if (!mounted) return;
      setState(() {
        if (previous == null) {
          _editRequests.remove(ad.id);
        } else {
          _editRequests[ad.id] = previous;
        }
      });
      _showMessage(l10n, l10n.adsSaveFailed);
    }
  }

  Future<void> _setAdState(
    AppLocalizations l10n,
    _AdRecord ad, {
    _AdStatus? status,
    bool? hidden,
    ({_AdRejectionReason reason, String guidance})? rejection,
  }) async {
    final previousStatus = _statuses[ad.id];
    final wasHidden = _hiddenAds.contains(ad.id);
    final previousRejection = _rejections[ad.id];
    setState(() {
      if (status != null) _statuses[ad.id] = status;
      if (hidden == true) _hiddenAds.add(ad.id);
      if (hidden == false) _hiddenAds.remove(ad.id);
      if (rejection != null) _rejections[ad.id] = rejection;
      _lastUpdatedAt = DateTime.now();
    });
    try {
      await _persistActions();
      await MerchantAdvertisementLocalStore.saveStatus(
        reference: _adReference(ad),
        status: _sharedStatusFor(
          status ?? _statuses[ad.id] ?? _AdStatus.pending,
          hidden: hidden ?? _hiddenAds.contains(ad.id),
        ),
      );
      try {
        final resultLabel = switch (status) {
          _AdStatus.approved => l10n.adsApprovedStatus,
          _AdStatus.awaitingFinance => l10n.adsPremiumWaitingFinance,
          _AdStatus.awaitingManagement => l10n.adsPremiumWaitingManagement,
          _AdStatus.rejected => l10n.adsRejectedStatus,
          _AdStatus.suspended => l10n.adsFrozenStatus,
          _AdStatus.pending ||
          null =>
            hidden == true ? l10n.adsHiddenStatus : l10n.adsReviewHidden,
        };
        await MerchantSupervisorLocalStore.recordAction(
          action: l10n.merchantAuditAdModerated,
          subject: _adTitle(l10n, ad),
          details: [
            resultLabel,
            if (rejection?.guidance.isNotEmpty ?? false) rejection!.guidance,
          ].join(' · '),
        );
      } on Object catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'merchant advertisement audit',
          ),
        );
        if (mounted) _showMessage(l10n, l10n.merchantAuditLoadError);
      }
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant advertisement review',
        ),
      );
      if (mounted) {
        setState(() {
          if (previousStatus == null) {
            _statuses.remove(ad.id);
          } else {
            _statuses[ad.id] = previousStatus;
          }
          if (wasHidden) {
            _hiddenAds.add(ad.id);
          } else {
            _hiddenAds.remove(ad.id);
          }
          if (previousRejection == null) {
            _rejections.remove(ad.id);
          } else {
            _rejections[ad.id] = previousRejection;
          }
        });
        _showMessage(l10n, l10n.adsSaveFailed);
      }
    }
  }

  Future<void> _approveAd(AppLocalizations l10n, _AdRecord ad) async {
    if (_statuses[ad.id] == _AdStatus.awaitingFinance ||
        _statuses[ad.id] == _AdStatus.awaitingManagement) {
      _showMessage(
        l10n,
        _statuses[ad.id] == _AdStatus.awaitingFinance
            ? l10n.adsPremiumWaitingFinance
            : l10n.adsPremiumWaitingManagement,
      );
      return;
    }
    if (ad.isPremium) {
      final preferences = await SharedPreferences.getInstance();
      final stored = preferences.getString(_financialRequestsKey);
      final requests =
          stored == null ? <dynamic>[] : jsonDecode(stored) as List<dynamic>;
      final requestId = 'AD-FEE-${_adReference(ad)}';
      if (!requests.any(
        (request) => request is Map && request['id'] == requestId,
      )) {
        requests.add({
          'id': requestId,
          'type': 'packageFees',
          'merchantName': _merchantName(l10n, ad),
          'merchantNameEn': _merchantNameEn(ad),
          'title': l10n.localeName.startsWith('ar')
              ? 'رسوم الإعلان المميز ${_adReference(ad)}'
              : 'Premium advertisement fee - ${_adReference(ad)}',
          'titleAr': 'رسوم الإعلان المميز ${_adReference(ad)}',
          'titleEn': 'Premium advertisement fee - ${_adReference(ad)}',
          'amount': ad.premiumFee,
          'createdAt': DateTime.now().toIso8601String(),
        });
        final saved = await preferences.setString(
          _financialRequestsKey,
          jsonEncode(requests),
        );
        if (!saved) {
          throw StateError('Could not queue premium advertisement fee.');
        }
        merchantFinancialRequestsVersion.value++;
      }
      await _setAdState(l10n, ad, status: _AdStatus.awaitingFinance);
      if (!mounted) return;
      _showMessage(l10n, l10n.adsPremiumWaitingFinance);
      return;
    }
    await _setAdState(l10n, ad, status: _AdStatus.approved);
    if (!mounted) return;
    _showMessage(l10n, l10n.adsApprovedStatus);
  }

  String _merchantNameEn(_AdRecord ad) => switch (ad.id) {
        1 => 'Al-Ufuq Car Trading Est.',
        2 => 'Al-Safwa Electronics Store',
        _ => 'Al-Yamama Contracting & Real Estate Co.',
      };

  bool _isArchived(_AdRecord ad) =>
      _hiddenAds.contains(ad.id) ||
      (_statuses[ad.id] ?? _AdStatus.pending) != _AdStatus.pending;

  String _merchantName(AppLocalizations l10n, _AdRecord ad) => switch (ad.id) {
        1 => l10n.adsCarMerchant,
        2 => l10n.adsPhoneMerchant,
        _ => l10n.adsVillaMerchant,
      };

  String _merchantCategory(AppLocalizations l10n, _AdRecord ad) =>
      switch (ad.id) {
        1 => l10n.adsCarCategory,
        2 => l10n.adsPhoneCategory,
        _ => l10n.adsVillaCategory,
      };

  String _adTitle(AppLocalizations l10n, _AdRecord ad) => switch (ad.id) {
        1 => l10n.adsCarTitle,
        2 => l10n.adsPhoneTitle,
        _ => l10n.adsVillaTitle,
      };

  String _adDetails(AppLocalizations l10n, _AdRecord ad) => switch (ad.id) {
        1 => l10n.adsCarDetails,
        2 => l10n.adsPhoneDetails,
        _ => l10n.adsVillaDetails,
      };

  String _adPrice(AppLocalizations l10n, _AdRecord ad) => switch (ad.id) {
        1 => l10n.adsCarPrice,
        2 => l10n.adsPhonePrice,
        _ => l10n.adsVillaPrice,
      };

  String _adReference(_AdRecord ad) =>
      MerchantAdvertisementLocalStore.referencesByLocalId[ad.id] ??
      'AD-${ad.id}';

  List<_AdRecord> _filteredAds(AppLocalizations l10n) {
    final query = _searchQuery.trim().toLowerCase();
    final ads = _ads.where((ad) {
      if (_isArchived(ad) != _showArchive) return false;
      final status = _statuses[ad.id] ?? _AdStatus.pending;
      final matchesSummary = switch (_summaryFilter) {
        null => true,
        _SummaryFilter.hidden => _hiddenAds.contains(ad.id),
        _SummaryFilter.approved => status == _AdStatus.approved,
        _SummaryFilter.underReview =>
          !_hiddenAds.contains(ad.id) && status == _AdStatus.pending,
        _SummaryFilter.urgent => !_hiddenAds.contains(ad.id) &&
            status == _AdStatus.pending &&
            ad.receivedMinutesAgo >= 60,
      };
      if (!matchesSummary) return false;
      final matchesCategory =
          _categoryFilter == null || ad.category == _categoryFilter;
      final matchesQuery = query.isEmpty ||
          _adTitle(l10n, ad).toLowerCase().contains(query) ||
          _merchantName(l10n, ad).toLowerCase().contains(query) ||
          _adReference(ad).toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
    ads.sort((a, b) => _newestFirst
        ? a.receivedMinutesAgo.compareTo(b.receivedMinutesAgo)
        : b.receivedMinutesAgo.compareTo(a.receivedMinutesAgo));
    return ads;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ads = _filteredAds(l10n);

    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (_isLoadingActions)
            const LinearProgressIndicator()
          else if (_loadError != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.adsLoadFailed),
            ),
          _buildSummary(l10n),
          const SizedBox(height: 14),
          _buildSearch(l10n),
          const SizedBox(height: 12),
          _buildCategoryFilters(l10n),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                label: Text(l10n.adsReviewQueueTab),
              ),
              ButtonSegment(value: true, label: Text(l10n.adsArchiveTitle)),
            ],
            selected: {_showArchive},
            onSelectionChanged: (selection) =>
                setState(() {
                  _showArchive = selection.first;
                  _summaryFilter = null;
                }),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  _showArchive ? l10n.adsArchiveTitle : l10n.adsPendingHeading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _smallBadge(
                '${ads.length}',
                AppColors.hexFFD9E7FF,
                AppColors.primaryDark,
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => setState(() => _newestFirst = !_newestFirst),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          _newestFirst
                              ? l10n.adsRecentSort
                              : l10n.adsOldestSort,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        _newestFirst ? Icons.sort : Icons.swap_vert,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (ads.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                l10n.adsNoResults,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ...ads.map((ad) => _buildAdCard(l10n, ad)),
        ],
      ),
    );
  }

  Widget _buildSummary(AppLocalizations l10n) {
    final hiddenCount = _ads.where((ad) => _hiddenAds.contains(ad.id)).length;
    final approvedCount = _ads
        .where((ad) => _statuses[ad.id] == _AdStatus.approved)
        .length;
    final underReviewCount = _ads
        .where((ad) => !_hiddenAds.contains(ad.id) &&
            (_statuses[ad.id] ?? _AdStatus.pending) == _AdStatus.pending)
        .length;
    final urgentCount = _ads.where((ad) =>
        !_hiddenAds.contains(ad.id) &&
        (_statuses[ad.id] ?? _AdStatus.pending) == _AdStatus.pending &&
        ad.receivedMinutesAgo >= 60).length;
    final updatedTime = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(_lastUpdatedAt),
    );
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.circle,
                  color: urgentCount > 0
                      ? AppColors.hexFFD92D35
                      : AppColors.success,
                  size: 9),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.adsReviewGateway,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.white, fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
              if (urgentCount > 0)
                Flexible(
                  child: InkWell(
                    onTap: () => setState(() {
                      _showArchive = false;
                      _summaryFilter = _SummaryFilter.urgent;
                    }),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.hexFF3D1B2B,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '${l10n.adsUrgentDecision} · $urgentCount',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _summaryMetric(
                value: '$hiddenCount',
                label: l10n.adsHiddenToday,
                icon: Icons.visibility_off_outlined,
                onTap: () => setState(() {
                  _showArchive = true;
                  _summaryFilter = _SummaryFilter.hidden;
                }),
              ),
              const SizedBox(width: 8),
              _summaryMetric(
                value: '$approvedCount',
                label: l10n.adsApprovedStatus,
                icon: Icons.check_circle_outline,
                onTap: () => setState(() {
                  _showArchive = true;
                  _summaryFilter = _SummaryFilter.approved;
                }),
              ),
              const SizedBox(width: 8),
              _summaryMetric(
                value: '$underReviewCount',
                label: l10n.adsUnderReviewCount,
                icon: Icons.fact_check_outlined,
                onTap: () => setState(() {
                  _showArchive = false;
                  _summaryFilter = _SummaryFilter.underReview;
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              '${l10n.updatedNow} · $updatedTime',
              style: const TextStyle(color: AppColors.hexFFCBD5E1, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryMetric({
    required String value,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.hexFF1A304B,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.hexFFCBD5E1, fontSize: 9),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 13, color: AppColors.hexFF93B9F5),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildSearch(AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: IconButton(
            tooltip: l10n.adsSearchHint,
            onPressed: () => _showCategoryFilters(l10n),
            icon: const Icon(Icons.tune, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: l10n.adsSearchHint,
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textMuted,
                  size: 19,
                ),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.adsClearSearch,
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        icon: const Icon(Icons.close, size: 17),
                      ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters(AppLocalizations l10n) {
    final filters = <({String label, _AdCategory? category, int count})>[
      (label: l10n.adsAllFilter, category: null, count: 12),
      (label: l10n.adsVehiclesFilter, category: _AdCategory.vehicles, count: 5),
      (
        label: l10n.adsElectronicsFilter,
        category: _AdCategory.electronics,
        count: 4
      ),
      (
        label: l10n.adsRealEstateFilter,
        category: _AdCategory.realEstate,
        count: 3
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < filters.length; index++) ...[
            if (index > 0) const SizedBox(width: 8),
            ChoiceChip(
              label: Text('${filters[index].label} (${filters[index].count})'),
              selected: _categoryFilter == filters[index].category,
              onSelected: (_) =>
                  setState(() => _categoryFilter = filters[index].category),
              showCheckmark: false,
              selectedColor: AppColors.primaryDark,
              backgroundColor: AppColors.white,
              labelStyle: TextStyle(
                color: _categoryFilter == filters[index].category
                    ? AppColors.white
                    : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: _categoryFilter == filters[index].category
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              side: BorderSide(
                color: _categoryFilter == filters[index].category
                    ? AppColors.primaryDark
                    : AppColors.cardBorder,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdCard(AppLocalizations l10n, _AdRecord ad) {
    final status = _statuses[ad.id] ?? _AdStatus.pending;
    final isHidden = _hiddenAds.contains(ad.id);

    return InkWell(
      onTap: () => _openAdDetails(l10n, ad),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.025),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.surface,
                  child: Icon(
                    ad.category == _AdCategory.vehicles
                        ? Icons.directions_car_outlined
                        : ad.category == _AdCategory.electronics
                            ? Icons.phone_iphone
                            : Icons.apartment,
                    size: 17,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _merchantName(l10n, ad),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _merchantCategory(l10n, ad),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        _adReference(ad),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _smallBadge(
                        ad.isPremium ? l10n.adsPremium : l10n.adsRegular,
                        ad.isPremium
                            ? AppColors.textPrimary
                            : AppColors.hexFFE8EAED,
                        ad.isPremium
                            ? AppColors.hexFF8A4B08
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _statusPill(l10n, ad, isHidden, status),
              ],
            ),
            const SizedBox(height: 12),
            if (ad.category == _AdCategory.electronics)
              _buildProductRow(l10n, ad)
            else
              _buildImagePreview(l10n, ad),
            const SizedBox(height: 10),
            if (ad.category != _AdCategory.electronics)
              Text(
                _adTitle(l10n, ad),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 6,
              runSpacing: 6,
              children: [
                _smallBadge(
                  '${l10n.adsLicenseVerified} ✓',
                  AppColors.hexFFEAF1FB,
                  AppColors.primaryDark,
                ),
                if (ad.hasMarketPriceBadge)
                  _smallBadge(
                    l10n.adsMarketPriceMatched,
                    AppColors.hexFFEAF1FB,
                    AppColors.primaryDark,
                  ),
                if (ad.category != _AdCategory.electronics)
                  _smallBadge(
                    _adDetails(l10n, ad),
                    AppColors.textPrimary,
                    AppColors.textSecondary,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    _merchantCategory(l10n, ad).split('•').last.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ),
                if (ad.category != _AdCategory.electronics)
                  Text(
                    _adPrice(l10n, ad),
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            _buildActionButtons(l10n, ad, isHidden, status),
          ],
        ),
      ),
    );
  }

  void _openAdDetails(AppLocalizations l10n, _AdRecord ad) {
    final details = _reviewDetails(l10n, ad);
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => AdvertisementReviewDetailsScreen(
          merchant: _merchantName(l10n, ad),
          merchantCategory: _merchantCategory(l10n, ad),
          merchantRegistrationNumber: switch (ad.id) {
            1 => '1010482910',
            2 => '1010764203',
            _ => '1010332789',
          },
          adNumber: _adReference(ad),
          submittedAt: ad.receivedMinutesAgo >= 120
              ? l10n.adsHoursAgo
              : l10n.adsMinutesAgo('${ad.receivedMinutesAgo}'),
          title: _adTitle(l10n, ad),
          description: details.description,
          price: _adPrice(l10n, ad),
          photoCount: ad.imageCount,
          imageIcon: ad.imageIcon,
          imageColor: ad.imageColor,
          facts: details.facts,
          checklist: details.checklist,
          initialDeliveryFee: _deliveryFees[ad.id] ?? 150,
          onApprove: () async {
            Navigator.of(context).pop();
            await _approveAd(l10n, ad);
          },
          onHide: () async {
            Navigator.of(context).pop();
            await _setAdState(l10n, ad, hidden: true);
            _showMessage(l10n, l10n.adsHiddenStatus);
          },
          onReject: () {
            Navigator.of(context).pop();
            _rejectAd(l10n, ad);
          },
          onRequestEdit: (note) => _requestAdEdit(l10n, ad, note),
          onFeeUpdated: (fee) => _saveDeliveryFee(l10n, ad, fee),
        ),
      ),
    );
  }

  ({
    String description,
    List<AdReviewFact> facts,
    List<AdReviewChecklistItem> checklist,
  }) _reviewDetails(AppLocalizations l10n, _AdRecord ad) {
    final facts = switch (ad.category) {
      _AdCategory.vehicles => [
          AdReviewFact(
            icon: Icons.speed,
            label: l10n.adsMileage,
            value: l10n.adsMileageValue,
          ),
          AdReviewFact(
            icon: Icons.palette_outlined,
            label: l10n.adsExteriorColor,
            value: l10n.adsWhiteColorValue,
          ),
          AdReviewFact(
            icon: Icons.verified_user_outlined,
            label: l10n.adsAccidentRecord,
            value: l10n.adsNoAccidentsValue,
          ),
          AdReviewFact(
            icon: Icons.fact_check_outlined,
            label: l10n.adsTransmission,
            value: l10n.adsAutomaticValue,
          ),
        ],
      _AdCategory.electronics => [
          AdReviewFact(
            icon: Icons.verified_user_outlined,
            label: l10n.adsPhoneWarranty,
            value: l10n.adsWarrantyValue,
          ),
          AdReviewFact(
            icon: Icons.check_circle_outline,
            label: l10n.adsPhoneCondition,
            value: l10n.adsNewConditionValue,
          ),
          AdReviewFact(
            icon: Icons.palette_outlined,
            label: l10n.adsPhoneColor,
            value: l10n.adsNaturalTitaniumValue,
          ),
          AdReviewFact(
            icon: Icons.sd_storage_outlined,
            label: l10n.adsPhoneStorage,
            value: l10n.adsStorageValue,
          ),
        ],
      _AdCategory.realEstate => [
          AdReviewFact(
            icon: Icons.square_foot,
            label: l10n.adsVillaArea,
            value: l10n.adsVillaAreaValue,
          ),
          AdReviewFact(
            icon: Icons.bed_outlined,
            label: l10n.adsVillaRooms,
            value: l10n.adsVillaRoomsValue,
          ),
          AdReviewFact(
            icon: Icons.verified_user_outlined,
            label: l10n.adsVillaLicense,
            value: l10n.adsVillaLicensedValue,
          ),
          AdReviewFact(
            icon: Icons.location_on_outlined,
            label: l10n.adsVillaLocation,
            value: l10n.adsVillaLocationValue,
          ),
        ],
    };
    final description = switch (ad.category) {
      _AdCategory.vehicles => l10n.adsVehicleDescription,
      _AdCategory.electronics => l10n.adsPhoneDescription,
      _AdCategory.realEstate => l10n.adsVillaDescription,
    };
    final checklist = [
      AdReviewChecklistItem(
        title: l10n.adsCheckPrice,
        status: l10n.adsCheckPassed,
      ),
      AdReviewChecklistItem(
        title: l10n.adsCheckPhotos,
        status: l10n.adsCheckPassed,
      ),
      AdReviewChecklistItem(
        title: l10n.adsCheckSpecifications,
        status: l10n.adsCheckPassed,
      ),
      AdReviewChecklistItem(
        title: l10n.adsCheckMerchantLicense,
        status: l10n.adsCheckReminder,
        subtitle: l10n.adsCheckExpiryReminder,
      ),
    ];
    return (description: description, facts: facts, checklist: checklist);
  }

  Widget _statusPill(
    AppLocalizations l10n,
    _AdRecord ad,
    bool isHidden,
    _AdStatus status,
  ) {
    final label = status == _AdStatus.suspended
        ? l10n.adsFrozenStatus
        : status == _AdStatus.approved
            ? l10n.adsApprovedStatus
            : status == _AdStatus.awaitingFinance
                ? l10n.adsPremiumWaitingFinance
                : status == _AdStatus.awaitingManagement
                    ? l10n.adsPremiumWaitingManagement
                    : status == _AdStatus.rejected
                        ? l10n.adsRejectedStatus
                        : isHidden
                            ? l10n.adsHiddenStatus
                            : l10n.adsReviewHidden;
    final color = status == _AdStatus.suspended
        ? AppColors.hexFFAC6900
        : status == _AdStatus.approved
            ? AppColors.successDark
            : status == _AdStatus.awaitingFinance ||
                    status == _AdStatus.awaitingManagement
                ? AppColors.info
                : status == _AdStatus.rejected
                    ? AppColors.danger
                    : AppColors.textSecondary;
    final age = ad.receivedMinutesAgo >= 120
        ? l10n.adsHoursAgo
        : l10n.adsMinutesAgo('${ad.receivedMinutesAgo}');

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 148),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.visibility_off_outlined,
                    size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: color, fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.schedule,
                    size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    age,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(AppLocalizations l10n, _AdRecord ad) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 170,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ad.imageColor.withValues(alpha: 0.65),
                    AppColors.hexFFDFE5E9,
                    ad.imageColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Icon(
                ad.imageIcon,
                size: 104,
                color: AppColors.white.withValues(alpha: 0.82),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: _photoBadge(l10n, ad.imageCount),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  _adPrice(l10n, ad),
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductRow(AppLocalizations l10n, _AdRecord ad) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 116,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.hexFFE9EFF3, AppColors.hexFFCAD6DE],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.phone_iphone,
                    size: 62,
                    color: AppColors.hexFF5B7182,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: _photoBadge(l10n, ad.imageCount),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _adTitle(l10n, ad),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _adDetails(l10n, ad),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _adPrice(l10n, ad),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _photoBadge(AppLocalizations l10n, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.photo_camera_outlined,
              size: 12, color: AppColors.white),
          const SizedBox(width: 4),
          Text(
            l10n.adsImageCount('$count'),
            style: const TextStyle(color: AppColors.white, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    AppLocalizations l10n,
    _AdRecord ad,
    bool isHidden,
    _AdStatus status,
  ) {
    if (status == _AdStatus.rejected) return const SizedBox.shrink();
    if (status == _AdStatus.suspended) {
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: _actionButton(
          label: l10n.adsUnfreezeAction,
          icon: Icons.play_circle_outline,
          background: AppColors.hexFFE8F6EF,
          foreground: AppColors.success,
          onPressed: () => _setAdState(
            l10n,
            ad,
            status: _AdStatus.pending,
          ),
        ),
      );
    }
    if (status == _AdStatus.awaitingFinance ||
        status == _AdStatus.awaitingManagement) {
      return _actionButton(
        label: status == _AdStatus.awaitingFinance
            ? l10n.adsPremiumWaitingFinance
            : l10n.adsPremiumWaitingManagement,
        icon: Icons.hourglass_top,
        background: AppColors.hexFFEAF0FF,
        foreground: AppColors.info,
        onPressed: null,
      );
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _actionButton(
                label: isHidden ? l10n.adsHiddenStatus : l10n.adsHideAction,
                icon: isHidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                background: AppColors.surface,
                foreground: AppColors.textSecondary,
                onPressed: () async {
                  await _setAdState(l10n, ad, hidden: !isHidden);
                  _showMessage(
                    l10n,
                    isHidden ? l10n.adsReviewHidden : l10n.adsHiddenStatus,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: _actionButton(
                label: l10n.adsFreezeAction,
                icon: Icons.pause_circle_outline,
                background: AppColors.surface,
                foreground: AppColors.primaryDark,
                onPressed: () => _setAdState(
                  l10n,
                  ad,
                  status: _AdStatus.suspended,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                label: l10n.adsRejectAction,
                icon: Icons.close,
                background: AppColors.surface,
                foreground: AppColors.hexFFB42318,
                onPressed: () => _rejectAd(l10n, ad),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                label: status == _AdStatus.approved
                    ? l10n.adsApprovedStatus
                    : l10n.adsApproveAction,
                icon: Icons.check,
                background: AppColors.primaryDark,
                foreground: AppColors.white,
                onPressed: () => _approveAd(l10n, ad),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color background,
    required Color foreground,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 15),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: background,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }

  Widget _smallBadge(String label, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: foreground,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _showCategoryFilters(AppLocalizations l10n) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.adsAllFilter),
              trailing:
                  _categoryFilter == null ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() => _categoryFilter = null);
                Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              title: Text(l10n.adsVehiclesFilter),
              trailing: _categoryFilter == _AdCategory.vehicles
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() => _categoryFilter = _AdCategory.vehicles);
                Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              title: Text(l10n.adsElectronicsFilter),
              trailing: _categoryFilter == _AdCategory.electronics
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() => _categoryFilter = _AdCategory.electronics);
                Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              title: Text(l10n.adsRealEstateFilter),
              trailing: _categoryFilter == _AdCategory.realEstate
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() => _categoryFilter = _AdCategory.realEstate);
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _rejectAd(AppLocalizations l10n, _AdRecord ad) async {
    _AdRejectionReason? selectedReason;
    var guidance = '';
    final rejection = await showModalBottomSheet<
        ({_AdRejectionReason reason, String guidance})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SafeArea(
              top: false,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.84,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Container(
                                width: 42,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: AppColors.hexFFC5C8CE,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton.filledTonal(
                                  onPressed: () => Navigator.pop(sheetContext),
                                  tooltip: l10n.adsCancelAction,
                                  icon: const Icon(Icons.close, size: 18),
                                  style: IconButton.styleFrom(
                                    backgroundColor: AppColors.surface,
                                    foregroundColor: AppColors.textSecondary,
                                  ),
                                ),
                                const Spacer(),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        l10n.adsRejectReasonTitle,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          color: AppColors.primaryDark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _adTitle(l10n, ad),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppColors.textPrimary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.gavel,
                                    color: AppColors.hexFFB42318,
                                    size: 19,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.adsRejectReasonInstructions,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            RadioGroup<_AdRejectionReason>(
                              groupValue: selectedReason,
                              onChanged: (value) => setSheetState(
                                () => selectedReason = value,
                              ),
                              child: Column(
                                children: _rejectionReasons(l10n).map((option) {
                                  final selected =
                                      selectedReason == option.reason;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Material(
                                      color: selected
                                          ? AppColors.textPrimary
                                          : AppColors.textPrimary,
                                      borderRadius: BorderRadius.circular(12),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () => setSheetState(
                                          () => selectedReason = option.reason,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Radio<_AdRejectionReason>(
                                                value: option.reason,
                                                activeColor:
                                                    AppColors.hexFFB42318,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  option.label,
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                option.icon,
                                                size: 17,
                                                color: AppColors.textSecondary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.adsRejectGuidanceOptional,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      color: AppColors.primaryDark,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.adsRejectGuidanceDirectLabel,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              key: const ValueKey('ad-rejection-guidance'),
                              onChanged: (value) => guidance = value,
                              maxLines: 3,
                              maxLength: 300,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: l10n.adsRejectGuidanceHint,
                                filled: true,
                                fillColor: AppColors.surfaceLight,
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: selectedReason == null
                              ? null
                              : () => Navigator.pop(
                                    sheetContext,
                                    (
                                      reason: selectedReason!,
                                      guidance: guidance.trim(),
                                    ),
                                  ),
                          icon: const Icon(Icons.outgoing_mail, size: 17),
                          label: Text(l10n.adsConfirmRejectAndNotify),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.hexFFB91C1C,
                            disabledBackgroundColor: AppColors.hexFFD9A6A3,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    if (rejection == null || !mounted) return;

    await _setAdState(
      l10n,
      ad,
      status: _AdStatus.rejected,
      rejection: rejection,
    );
    if (!mounted) return;
    _showMessage(l10n, l10n.adsRejectedStatus);
  }

  List<({String label, IconData icon, _AdRejectionReason reason})>
      _rejectionReasons(AppLocalizations l10n) => [
            (
              label: l10n.adsRejectReasonPrice,
              icon: Icons.price_change_outlined,
              reason: _AdRejectionReason.price,
            ),
            (
              label: l10n.adsRejectReasonMisleading,
              icon: Icons.description_outlined,
              reason: _AdRejectionReason.misleading,
            ),
            (
              label: l10n.adsRejectReasonPhotos,
              icon: Icons.image_not_supported_outlined,
              reason: _AdRejectionReason.photos,
            ),
            (
              label: l10n.adsRejectReasonPolicy,
              icon: Icons.warning_amber_outlined,
              reason: _AdRejectionReason.policy,
            ),
          ];

  void _showMessage(AppLocalizations l10n, String message) {
    AppSnackBar.showInfo(context, message);
  }
}
