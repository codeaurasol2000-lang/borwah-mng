import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import 'advertisement_review_details_screen.dart';

enum _AdCategory { vehicles, electronics, realEstate }

enum _AdStatus { pending, approved, rejected }

enum _AdRejectionReason { price, misleading, photos, policy }

class _AdRecord {
  final int id;
  final _AdCategory category;
  final IconData imageIcon;
  final Color imageColor;
  final int imageCount;
  final int receivedMinutesAgo;
  final bool hasMarketPriceBadge;

  const _AdRecord({
    required this.id,
    required this.category,
    required this.imageIcon,
    required this.imageColor,
    required this.imageCount,
    required this.receivedMinutesAgo,
    this.hasMarketPriceBadge = false,
  });
}

class AdsManagementScreen extends StatefulWidget {
  const AdsManagementScreen({super.key});

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
      imageColor: Color(0xFF476176),
      imageCount: 8,
      receivedMinutesAgo: 25,
      hasMarketPriceBadge: true,
    ),
    _AdRecord(
      id: 2,
      category: _AdCategory.electronics,
      imageIcon: Icons.smartphone,
      imageColor: Color(0xFF8DA5B7),
      imageCount: 5,
      receivedMinutesAgo: 40,
    ),
    _AdRecord(
      id: 3,
      category: _AdCategory.realEstate,
      imageIcon: Icons.villa_outlined,
      imageColor: Color(0xFF6E765D),
      imageCount: 14,
      receivedMinutesAgo: 120,
    ),
  ];
  final Map<int, _AdStatus> _statuses = {};
  final Map<int, ({_AdRejectionReason reason, String guidance})> _rejections =
      {};
  final Set<int> _hiddenAds = {};
  String _searchQuery = '';
  _AdCategory? _categoryFilter;
  bool _newestFirst = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  String _adReference(_AdRecord ad) => switch (ad.id) {
        1 => 'AD-94820',
        2 => 'AD-66214',
        _ => 'AD-78011',
      };

  List<_AdRecord> _filteredAds(AppLocalizations l10n) {
    final query = _searchQuery.trim().toLowerCase();
    final ads = _ads.where((ad) {
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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _buildSummary(l10n),
          const SizedBox(height: 14),
          _buildSearch(l10n),
          const SizedBox(height: 12),
          _buildCategoryFilters(l10n),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.adsPendingHeading,
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
                l10n.adsUnderReviewCount,
                const Color(0xFFD9E7FF),
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
              const Icon(Icons.circle, color: Color(0xFFD92D35), size: 9),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.adsReviewGateway,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D1B2B),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    l10n.adsUrgentDecision,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
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
                value: '4',
                label: l10n.adsHiddenToday,
                icon: Icons.visibility_off_outlined,
              ),
              const SizedBox(width: 8),
              _summaryMetric(
                value: '38',
                label: l10n.adsPendingToday,
                icon: Icons.check_circle_outline,
              ),
              const SizedBox(width: 8),
              _summaryMetric(
                value: '12',
                label: l10n.adsUnderReviewCount,
                icon: Icons.fact_check_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryMetric({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A304B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 9),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 13, color: const Color(0xFF93B9F5)),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
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
            color: Colors.white,
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
              color: Colors.white,
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
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: _categoryFilter == filters[index].category
                    ? Colors.white
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
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
                  backgroundColor: const Color(0xFFF1F5F9),
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
                  const Color(0xFFEAF1FB),
                  AppColors.primaryDark,
                ),
                if (ad.hasMarketPriceBadge)
                  _smallBadge(
                    l10n.adsMarketPriceMatched,
                    const Color(0xFFEAF1FB),
                    AppColors.primaryDark,
                  ),
                if (ad.category != _AdCategory.electronics)
                  _smallBadge(
                    _adDetails(l10n, ad),
                    const Color(0xFFF1F3F5),
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
          onApprove: () {
            Navigator.of(context).pop();
            setState(() => _statuses[ad.id] = _AdStatus.approved);
            _showMessage(l10n, l10n.adsApprovedStatus);
          },
          onHide: () {
            Navigator.of(context).pop();
            setState(() => _hiddenAds.add(ad.id));
            _showMessage(l10n, l10n.adsHiddenStatus);
          },
          onReject: () {
            Navigator.of(context).pop();
            _rejectAd(l10n, ad);
          },
          onRequestEdit: (_) {
            _showMessage(l10n, l10n.adsRequestEditUnavailable);
          },
          onFeeUpdated: (_) => _showMessage(l10n, l10n.adsFeeUpdated),
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
    final label = status == _AdStatus.approved
        ? l10n.adsApprovedStatus
        : status == _AdStatus.rejected
            ? l10n.adsRejectedStatus
            : isHidden
                ? l10n.adsHiddenStatus
                : l10n.adsReviewHidden;
    final color = status == _AdStatus.approved
        ? AppColors.successDark
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
              color: const Color(0xFFF0F2F4),
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
              color: const Color(0xFFF5F6F7),
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
                    const Color(0xFFDFE5E9),
                    ad.imageColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Icon(
                ad.imageIcon,
                size: 104,
                color: Colors.white.withValues(alpha: 0.82),
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
                  color: Colors.white,
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
                colors: [Color(0xFFE9EFF3), Color(0xFFCAD6DE)],
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
                    color: Color(0xFF5B7182),
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
              size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            l10n.adsImageCount('$count'),
            style: const TextStyle(color: Colors.white, fontSize: 9),
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
                background: const Color(0xFFF0F1F3),
                foreground: AppColors.textSecondary,
                onPressed: () {
                  setState(() {
                    if (isHidden) {
                      _hiddenAds.remove(ad.id);
                    } else {
                      _hiddenAds.add(ad.id);
                    }
                  });
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
                label: l10n.adsReviewAndApprove,
                icon: Icons.fact_check_outlined,
                background: const Color(0xFFF0F1F3),
                foreground: AppColors.primaryDark,
                onPressed: () => _openAdDetails(l10n, ad),
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
                background: const Color(0xFFFFE0DD),
                foreground: const Color(0xFFB42318),
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
                foreground: Colors.white,
                onPressed: () {
                  setState(() => _statuses[ad.id] = _AdStatus.approved);
                  _showMessage(l10n, l10n.adsApprovedStatus);
                },
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
    required VoidCallback onPressed,
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
      backgroundColor: Colors.transparent,
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
                  color: Colors.white,
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
                                  color: const Color(0xFFC5C8CE),
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
                                    backgroundColor: const Color(0xFFF0F1F3),
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
                                    color: const Color(0xFFFFE0DD),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.gavel,
                                    color: Color(0xFFB42318),
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
                                          ? const Color(0xFFFFF0EF)
                                          : const Color(0xFFF1F3F5),
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
                                                    const Color(0xFFB42318),
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
                                fillColor: const Color(0xFFF1F3F5),
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
                            backgroundColor: const Color(0xFFB91C1C),
                            disabledBackgroundColor: const Color(0xFFD9A6A3),
                            foregroundColor: Colors.white,
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

    setState(() {
      _statuses[ad.id] = _AdStatus.rejected;
      _rejections[ad.id] = rejection;
    });
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
