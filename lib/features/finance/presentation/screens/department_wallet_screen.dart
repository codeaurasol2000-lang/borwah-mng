import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/finance_dialogs.dart';
import '../../domain/entities/department_wallet_entity.dart';
import '../../domain/usecases/get_department_wallet_usecase.dart';
import '../widgets/finance_navigation.dart';

class DepartmentWalletScreen extends StatefulWidget {
  final DepartmentType type;

  const DepartmentWalletScreen({super.key, required this.type});

  @override
  State<DepartmentWalletScreen> createState() => _DepartmentWalletScreenState();
}

class _DepartmentWalletScreenState extends State<DepartmentWalletScreen> {
  DepartmentWalletEntity? _wallet;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    final result = await sl<GetDepartmentWalletUseCase>()(widget.type);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _errorMessage = failure.message;
        _isLoading = false;
      }),
      (wallet) => setState(() {
        _wallet = wallet;
        _isLoading = false;
      }),
    );
  }

  String _screenTitleFor(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (widget.type) {
      case DepartmentType.merchants:
        return l10n.departmentMerchantsTitle;
      case DepartmentType.usedEscrow:
        return l10n.departmentEscrowTitle;
      case DepartmentType.services:
        return l10n.departmentServicesTitle;
      case DepartmentType.couriers:
        return l10n.departmentCouriersTitle;
    }
  }

  Map<String, String> _statsFor(
      DepartmentWalletEntity wallet, AppLocalizations l10n) {
    final pending =
        '${wallet.pendingMetricCount} (${CurrencyFormatter.format(wallet.pendingMetricAmount, includeCurrency: false)})';
    switch (wallet.type) {
      case DepartmentType.merchants:
        return {
          l10n.departmentActiveStores: '${wallet.primaryMetricCount}',
          l10n.departmentPendingRequests: pending,
          l10n.departmentPlatformCommission: wallet.feeValue,
          'icon1': 'storefront',
        };
      case DepartmentType.usedEscrow:
        return {
          l10n.departmentActiveDeals: '${wallet.primaryMetricCount}',
          l10n.departmentDisputes: pending,
          l10n.departmentProtectionFee: wallet.feeValue,
          'icon1': 'handshake',
        };
      case DepartmentType.services:
        return {
          l10n.departmentServiceProviders: '${wallet.primaryMetricCount}',
          l10n.departmentPendingRequests: pending,
          l10n.departmentPlatformCommission: wallet.feeValue,
          'icon1': 'build',
        };
      case DepartmentType.couriers:
        return {
          l10n.departmentActiveCouriers: '${wallet.primaryMetricCount}',
          l10n.departmentPendingEntitlements: pending,
          l10n.departmentShipmentFee: '${wallet.feeValue} ${l10n.currencySar}',
          'icon1': 'local_shipping',
        };
    }
  }

  List<Map<String, dynamic>> _listItemsFor(
      DepartmentWalletEntity wallet, AppLocalizations l10n) {
    switch (wallet.type) {
      case DepartmentType.merchants:
        return [
          {
            'title': l10n.departmentMerchantHorizon,
            'id': '${l10n.departmentRecordPrefix} 1010892341   #TRD-9041',
            'available': 412800.00,
            'pending': 12500.00,
            'operations': '1,842',
            'bankText': l10n.departmentInstantSettlement,
            'bankIcon': Icons.flash_on,
            'status': l10n.departmentActiveMatched,
          },
          {
            'title': l10n.departmentStoreElite,
            'id': '${l10n.departmentRecordPrefix} 1010459810   #TRD-8820',
            'available': 325400.00,
            'pending': 24000.00,
            'operations': '965',
            'bankText': l10n.alRajhiMainOperating,
            'bankIcon': Icons.account_balance,
            'status': l10n.departmentActiveMatched,
          },
          {
            'title': l10n.departmentSparkleJewelry,
            'id': '${l10n.departmentRecordPrefix} 1010334992   #TRD-7104',
            'available': 184200.00,
            'pending': 58000.00,
            'operations': '420',
            'bankText': l10n.departmentScheduledPayment,
            'bankIcon': Icons.sync,
            'status': l10n.departmentActiveMatched,
          },
          {
            'title': l10n.departmentEliteDevices,
            'id': '${l10n.departmentRecordPrefix} 1010198421   #TRD-6519',
            'available': 98600.00,
            'pending': 0.00,
            'operations': '312',
            'bankText': l10n.snbEscrowAccount,
            'bankIcon': Icons.account_balance,
            'status': l10n.departmentActiveMatched,
          },
        ];
      case DepartmentType.usedEscrow:
        return [
          {
            'title': l10n.departmentCamryEscrow,
            'id': '${l10n.departmentEscrowPrefix} #ESC-1092',
            'available': 5000.00,
            'pending': 0.00,
            'operations': '1',
            'bankText': l10n.departmentUnderInspection,
            'bankIcon': Icons.visibility,
            'status': l10n.departmentProtectedEscrow,
          },
          {
            'title': l10n.departmentIphoneEscrow,
            'id': '${l10n.departmentEscrowPrefix} #ESC-3321',
            'available': 500.00,
            'pending': 0.00,
            'operations': '1',
            'bankText': l10n.departmentInShipping,
            'bankIcon': Icons.local_shipping,
            'status': l10n.departmentProtectedEscrow,
          },
        ];
      case DepartmentType.services:
        return [
          {
            'title': l10n.departmentItqanAc,
            'id': '${l10n.departmentLicensePrefix} 88214   #SRV-901',
            'available': 25400.00,
            'pending': 3200.00,
            'operations': '142',
            'bankText': l10n.departmentInstantSettlement,
            'bankIcon': Icons.flash_on,
            'status': l10n.departmentApprovedProvider,
          },
          {
            'title': l10n.departmentComprehensiveMaintenance,
            'id': '${l10n.departmentLicensePrefix} 11029   #SRV-412',
            'available': 18500.00,
            'pending': 0.00,
            'operations': '89',
            'bankText': l10n.snbEscrowAccount,
            'bankIcon': Icons.account_balance,
            'status': l10n.departmentApprovedProvider,
          },
        ];
      case DepartmentType.couriers:
        return [
          {
            'title': l10n.departmentZajelShipping,
            'id': '${l10n.departmentRecordPrefix} 40301122   #DEL-551',
            'available': 145000.00,
            'pending': 12000.00,
            'operations': '14,200',
            'bankText': l10n.departmentWeeklySettlement,
            'bankIcon': Icons.calendar_today,
            'status': l10n.departmentStrategicPartner,
          },
          {
            'title': l10n.departmentWaslniCourier,
            'id': '${l10n.departmentCourierNumberPrefix} #C-1902',
            'available': 450.00,
            'pending': 120.00,
            'operations': '45',
            'bankText': 'STC Pay',
            'bankIcon': Icons.account_balance_wallet,
            'status': l10n.departmentActiveCourier,
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: FinancePageAppBar(
          title: _screenTitleFor(context),
          subtitle: l10n.financialDepartment,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryDark,
                ),
              )
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _wallet == null
                    ? const SizedBox.shrink()
                    : Builder(
                        builder: (context) {
                          final wallet = _wallet!;
                          final stats = _statsFor(wallet, l10n);
                          final listItems = _listItemsFor(wallet, l10n);
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryExtraDark,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.account_balance_wallet,
                                              color: Colors.white,
                                              size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                                _screenTitleFor(context),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                        l10n
                                                            .departmentAuditedBadge,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 9),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Icon(Icons.verified,
                                                      color: Colors.blueAccent,
                                                      size: 12),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Text(l10n.departmentTotalBalance,
                                          style: const TextStyle(
                                              color: Colors.white60,
                                              fontSize: 11)),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              CurrencyFormatter.format(
                                                  wallet.totalBalance,
                                                  includeCurrency: false),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(l10n.currencySar,
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                          height: 1,
                                          color: Colors.white
                                              .withValues(alpha: 0.1)),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(stats.keys.elementAt(0),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 10)),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                            stats.values
                                                                .elementAt(0),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(
                                                        _getIconData(
                                                            stats['icon1']!),
                                                        color: Colors.white60,
                                                        size: 14),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(stats.keys.elementAt(1),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 10)),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                            stats.values
                                                                .elementAt(1)
                                                                .split(' ')[0],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                        Icons
                                                            .assignment_late_outlined,
                                                        color: Colors.white60,
                                                        size: 14),
                                                  ],
                                                ),
                                                if (stats.values
                                                    .elementAt(1)
                                                    .contains('('))
                                                  Text(
                                                      stats.values
                                                          .elementAt(1)
                                                          .substring(stats
                                                              .values
                                                              .elementAt(1)
                                                              .indexOf('(')),
                                                      style: const TextStyle(
                                                          color: Colors.white54,
                                                          fontSize: 9)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(stats.keys.elementAt(2),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 10)),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Text(
                                                            stats.values
                                                                .elementAt(2),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                        Icons.pie_chart_outline,
                                                        color: Colors.white60,
                                                        size: 14),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // 2. Section Title
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(Icons.tune,
                                              color: AppColors.primaryDark,
                                              size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                                l10n.departmentWalletSectionTitle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.textPrimary)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: AppColors.surfaceLight,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Text(l10n.departmentSyncStatus,
                                          style: const TextStyle(
                                              fontSize: 9,
                                              color: AppColors.textSecondary)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // 3. Filters
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildFilterChip(
                                          '${l10n.departmentAllFilter} 142',
                                          true),
                                      const SizedBox(width: 8),
                                      _buildFilterChip(
                                          l10n.departmentHighestBalanceFilter,
                                          false,
                                          icon: Icons.trending_up),
                                      const SizedBox(width: 8),
                                      _buildFilterChip(
                                          l10n.departmentWithdrawalFilter,
                                          false,
                                          icon: Icons.hourglass_empty),
                                      const SizedBox(width: 8),
                                      _buildFilterChip('', false,
                                          icon: Icons.lock_outline,
                                          isIconOnly: true),
                                      const SizedBox(width: 8),
                                      _buildFilterChip('', false,
                                          icon: Icons.warning_amber_rounded,
                                          isIconOnly: true,
                                          iconColor: AppColors.danger),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // 4. List Items
                                ...listItems.map((item) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: _buildListItemCard(context, item),
                                    )),

                                // 5. Bottom Info
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(l10n.departmentGovernanceTitle,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.primaryDark)),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.verified_user_outlined,
                                              color: Colors.blue.shade700,
                                              size: 18),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        l10n.departmentGovernanceNotice,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade700,
                                            height: 1.5),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        runSpacing: 4,
                                        children: [
                                          const Text('ISO-20022 COMPLIANT',
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.textSecondary),
                                              textDirection: TextDirection.ltr),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    l10n
                                                        .departmentLastReconciliation,
                                                    style: const TextStyle(
                                                        fontSize: 9,
                                                        color: AppColors
                                                            .textSecondary)),
                                                const SizedBox(width: 4),
                                                Icon(Icons.circle,
                                                    size: 6,
                                                    color: Colors.blue.shade400),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  Widget _buildFilterChip(String title, bool isSelected,
      {IconData? icon, bool isIconOnly = false, Color? iconColor}) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: isIconOnly ? 10 : 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryExtraDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color:
                isSelected ? AppColors.primaryExtraDark : AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 14,
                color: iconColor ??
                    (isSelected ? Colors.white : Colors.blue.shade700)),
            if (!isIconOnly) const SizedBox(width: 6),
          ],
          if (!isIconOnly)
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListItemCard(BuildContext context, Map<String, dynamic> item) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryExtraDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.storefront,
                        color: Colors.white, size: 20), // Generic icon
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.security,
                              size: 12, color: Colors.blue),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(item['id'],
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary),
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(item['status'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 9,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          // Amounts Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.departmentAvailableBalance,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                                child: Text(
                                    CurrencyFormatter.format(item['available'],
                                        includeCurrency: false),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryExtraDark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 2),
                            Text(AppLocalizations.of(context)!.currencySar,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.departmentUnderReview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                                child: Text(
                                    CurrencyFormatter.format(item['pending'],
                                        includeCurrency: false),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                  '${AppLocalizations.of(context)!.currencySar} ${isArabic ? l10n.departmentPendingSuffix : 'pending'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textSecondary)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Bottom Info Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${l10n.departmentMonthlySales}: ${item['operations']} ${l10n.departmentOperationsUnit}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Row(
                    children: [
                      Icon(item['bankIcon'],
                          size: 14, color: Colors.blue.shade700),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(item['bankText'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10, color: Colors.blue.shade700)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryExtraDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.receipt_long, size: 16),
                onPressed: () {
                  FinanceDialogs.showDepartmentTransactionsDialog(
                    context,
                    title: item['title'],
                    subtitle: item['id'],
                    availableBalance: item['available'] as double,
                    pendingBalance: item['pending'] as double,
                  );
                },
                label: Text(l10n.departmentViewHistory,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'storefront':
        return Icons.storefront;
      case 'handshake':
        return Icons.handshake;
      case 'build':
        return Icons.build;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
