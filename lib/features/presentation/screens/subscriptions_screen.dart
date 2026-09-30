import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../finance/domain/entities/subscription_request_entity.dart';
import '../../finance/domain/usecases/get_subscriptions_usecase.dart';
import '../../../l10n/app_localizations.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<SubscriptionRequestEntity> _subscriptions = [];
  bool _isLoading = true;
  String _selectedFilter = 'الكل';

  List<SubscriptionRequestEntity> get _filteredSubscriptions {
    if (_selectedFilter == 'المتاجر والتجار')
      return _subscriptions
          .where((s) => s.type == SubscriptionType.merchant)
          .toList();
    if (_selectedFilter == 'مزودوا الخدمات')
      return _subscriptions
          .where((s) => s.type == SubscriptionType.serviceProvider)
          .toList();
    if (_selectedFilter == 'مستخدمين')
      return _subscriptions
          .where((s) => s.type == SubscriptionType.user)
          .toList();
    if (_selectedFilter == 'مناديب')
      return _subscriptions
          .where((s) => s.type == SubscriptionType.courier)
          .toList();
    if (_selectedFilter == 'اعلانات')
      return _subscriptions
          .where((s) => s.type == SubscriptionType.ad)
          .toList();
    return _subscriptions;
  }

  int _countFor(String filter) {
    if (filter == 'المتاجر والتجار')
      return _subscriptions
          .where((s) => s.type == SubscriptionType.merchant)
          .length;
    if (filter == 'مزودوا الخدمات')
      return _subscriptions
          .where((s) => s.type == SubscriptionType.serviceProvider)
          .length;
    if (filter == 'مستخدمين')
      return _subscriptions
          .where((s) => s.type == SubscriptionType.user)
          .length;
    if (filter == 'مناديب')
      return _subscriptions
          .where((s) => s.type == SubscriptionType.courier)
          .length;
    if (filter == 'اعلانات')
      return _subscriptions.where((s) => s.type == SubscriptionType.ad).length;
    return _subscriptions.length;
  }

  int get _pendingCount => _subscriptions
      .where((s) => s.status.contains('قيد') || s.status.contains('جاهز'))
      .length;
  double get _pendingAmount => _subscriptions
      .where((s) => s.status.contains('قيد') || s.status.contains('جاهز'))
      .fold(0.0, (sum, s) => sum + s.totalAmount);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await sl<GetSubscriptionsUseCase>()();
    result.fold(
      (failure) => setState(() => _isLoading = false),
      (data) => setState(() {
        _subscriptions = data;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection:
          l10n.localeName == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          scrolledUnderElevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(l10n.subscriptionOrdersTitle,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Text(l10n.financialManagementSubtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryDark))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 1. Header Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified,
                                    color: Colors.blueAccent, size: 14),
                                const SizedBox(width: 4),
                                Text(l10n.financialAuditAndLicenses,
                                    style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(l10n.subscriptionsAndUpgradesReviewTitle,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryDark),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(l10n.subscriptionsAndUpgradesReviewSubtitle,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    height: 1.3)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: const Icon(Icons.search,
                                color: Colors.black87, size: 20),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Summary Dashboard Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A), // Dark blue background
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  l10n.currentSubscriptionsCycleSummary,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  l10n.updatedNow,
                                  style: const TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(l10n.pendingSubscriptionFees,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                      child: Text(
                                          CurrencyFormatter.format(
                                              _pendingAmount,
                                              includeCurrency: false),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              height: 1),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)),
                                  const SizedBox(width: 4),
                                  Text(l10n.currencySar,
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(l10n.activatedThisMonth,
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 9),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Icon(Icons.trending_up,
                                            color: Colors.lightBlueAccent,
                                            size: 12),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                            child: Text(
                                                CurrencyFormatter.format(142500,
                                                    includeCurrency: false),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        const SizedBox(width: 2),
                                        Text(l10n.currencySar,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 9)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(l10n.revenueGrowth,
                                        style: const TextStyle(
                                            color: Colors.greenAccent,
                                            fontSize: 9),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(l10n.pendingRequests,
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 9),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Icon(Icons.pause_circle_outline,
                                            color: Colors.orangeAccent,
                                            size: 12),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                            child: Text('$_pendingCount',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        const SizedBox(width: 4),
                                        Text(l10n.ordersUnit,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 9)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(l10n.ordersUnderAudit,
                                        style: const TextStyle(
                                            color: Colors.orangeAccent,
                                            fontSize: 9),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                                l10n.expiredAwaitingRenewal,
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 9),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Icon(Icons.access_time,
                                            color: Colors.redAccent, size: 12),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                            child: Text('9',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        SizedBox(width: 4),
                                        Text(l10n.ordersUnit,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 9)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(l10n.autoCommercialAlert,
                                        style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 9),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('الكل', isDark: true),
                        const SizedBox(width: 8),
                        _buildFilterChip('المتاجر والتجار',
                            icon: Icons.storefront),
                        const SizedBox(width: 8),
                        _buildFilterChip('مزودوا الخدمات',
                            icon: Icons.handshake),
                        const SizedBox(width: 8),
                        _buildFilterChip('مستخدمين', icon: Icons.person),
                        const SizedBox(width: 8),
                        _buildFilterChip('مناديب', icon: Icons.local_shipping),
                        const SizedBox(width: 8),
                        _buildFilterChip('اعلانات', icon: Icons.campaign),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. Section Title
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.circle,
                                color: AppColors.primaryDark, size: 10),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l10n.awaitingCertificationRequests,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.sort,
                                color: Colors.blueAccent, size: 16),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                l10n.sortByNewest,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.blue.shade700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 5. List
                  ..._filteredSubscriptions
                      .map((sub) => _buildSubscriptionCard(context, sub)),

                  // 6. Bottom Info Banner
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Icon(Icons.shield_outlined,
                                  color: Colors.blue.shade700, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.licensesGovernanceTitle,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87)),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.licensesGovernanceDesc,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                        height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lock_outline,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(l10n.certifiedAndDocumentedRecord,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                            Row(
                              children: [
                                _buildSmallButton(l10n.pdfReport,
                                    Icons.picture_as_pdf, Colors.red),
                                const SizedBox(width: 8),
                                _buildSmallButton(l10n.exportExcel,
                                    Icons.table_chart, Colors.green),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 7. Bottom Record Button
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(l10n.openingSubscriptionsRegister)));
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.history,
                                color: Colors.blue.shade700, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.subscriptionsHistoryTitle,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade900)),
                                const SizedBox(height: 2),
                                Text(l10n.browsePreviousOperations,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildFilterChip(String filterType,
      {IconData? icon, bool isDark = false}) {
    final l10n = AppLocalizations.of(context)!;
    bool isSelected =
        _selectedFilter == filterType || (isDark && _selectedFilter == 'الكل');
    int count = _countFor(filterType);
    final localizedFilter = switch (filterType) {
      'المتاجر والتجار' => l10n.storesAndMerchants,
      'مزودوا الخدمات' => l10n.serviceProviders,
      'مستخدمين' => l10n.usersTab,
      'مناديب' => l10n.couriersTab,
      'اعلانات' => l10n.advertisementsTab,
      _ => l10n.allTab,
    };
    String label = count > 0 ? '$localizedFilter $count' : localizedFilter;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterType),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color:
                  isSelected ? const Color(0xFF0F172A) : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon,
                  size: 14,
                  color: isSelected ? Colors.white : Colors.blue.shade700),
            if (icon != null) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallButton(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(title,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
      BuildContext context, SubscriptionRequestEntity sub) {
    final l10n = AppLocalizations.of(context)!;
    bool isAutoReady = sub.status.contains('جاهز');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  sub.type == SubscriptionType.merchant
                      ? Icons.devices
                      : (sub.type == SubscriptionType.serviceProvider
                          ? Icons.build
                          : (sub.type == SubscriptionType.user
                              ? Icons.person
                              : (sub.type == SubscriptionType.courier
                                  ? Icons.local_shipping
                                  : Icons.campaign))),
                  color: AppColors.primaryDark,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sub.providerName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            switch (sub.type) {
                              SubscriptionType.merchant =>
                                l10n.storesAndMerchants,
                              SubscriptionType.serviceProvider =>
                                l10n.serviceProviders,
                              SubscriptionType.user => l10n.usersTab,
                              SubscriptionType.courier => l10n.couriersTab,
                              SubscriptionType.ad => l10n.advertisementsTab,
                            },
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.circle, size: 4, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${sub.type == SubscriptionType.merchant ? l10n.commercialRegister : l10n.licenseNumber} ${sub.registrationNumber}',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAutoReady
                        ? Colors.blue.shade50
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isAutoReady)
                        const Icon(Icons.flash_on,
                            color: AppColors.primaryDark, size: 12),
                      if (!isAutoReady)
                        const Icon(Icons.circle,
                            color: Colors.blueAccent, size: 8),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          isAutoReady
                              ? l10n.autoApprovalReady
                              : l10n.underMatching,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isAutoReady
                                  ? AppColors.primaryDark
                                  : Colors.blue.shade800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Amount & Package Box
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.targetedPackageType,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (sub.type == SubscriptionType.merchant)
                            const Icon(Icons.stars,
                                color: Colors.blue, size: 14),
                          if (sub.type == SubscriptionType.merchant)
                            const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              sub.targetPackageName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sub.type == SubscriptionType.serviceProvider
                            ? l10n.semiAnnualDuration
                            : l10n.taxInclusive15,
                        style: TextStyle(
                            fontSize: 10, color: Colors.blue.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    border: const Border(
                        top: BorderSide(color: Color(0xFFEEEEEE)),
                        bottom: BorderSide(color: Color(0xFFEEEEEE)),
                        left: BorderSide(color: Color(0xFFEEEEEE))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'إجمالي السعر المطلوب',
                        style: TextStyle(
                            fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: Text(
                              CurrencyFormatter.format(sub.totalAmount,
                                  includeCurrency: false),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryExtraDark),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('ر.س',
                              style: TextStyle(
                                  fontSize: 10, color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAutoReady
                            ? 'رصيد كافي بالمحفظة'
                            : 'شامل الضريبة 15%',
                        style: TextStyle(
                            fontSize: 9, color: isAutoReady ? AppColors.success : Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Payment Method Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                    isAutoReady
                        ? Icons.account_balance_wallet
                        : Icons.account_balance,
                    size: 16,
                    color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sub.paymentMethod,
                    style: const TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ),
                if (isAutoReady && sub.availableBalance != null)
                  Flexible(
                    child: Text(
                      sub.availableBalance!,
                      style:
                          TextStyle(fontSize: 10, color: Colors.blue.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                if (!isAutoReady)
                  Flexible(
                    child: Text(
                      l10n.corporateAccount,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue.shade700,
                          height: 1.2),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.check_circle_outline, size: 16),
                onPressed: () {},
                label: Text(l10n.approveAndSendToAdmin,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (isAutoReady) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          backgroundColor:
                              AppColors.dangerLight.withValues(alpha: 0.3),
                          side: const BorderSide(color: AppColors.dangerLight),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.cancel_outlined, size: 16),
                        onPressed: () {},
                        label: Text(l10n.rejectWithReason,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange.shade800,
                        backgroundColor: Colors.orange.shade50,
                        side: BorderSide(color: Colors.orange.shade200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.pause_circle_outline, size: 16),
                      onPressed: () {},
                      label: Text(l10n.freezeRequestTemporarily,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (!isAutoReady) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                  side: BorderSide(color: Colors.blue.shade100),
                  backgroundColor: Colors.blue.shade50.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.attachment, size: 16),
                onPressed: () {},
                label: Text(l10n.previewReceiptAndTransferData,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
