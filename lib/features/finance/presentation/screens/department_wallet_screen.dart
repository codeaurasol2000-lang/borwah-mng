import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
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
          l10n.departmentShipmentFee: '${wallet.feeValue} ${l10n.currencyEgy}',
          'icon1': 'local_shipping',
        };
    }
  }

  List<Map<String, dynamic>> _listItemsFor(
    DepartmentWalletEntity wallet,
    AppLocalizations l10n,
  ) {
    final isArabic = l10n.localeName.startsWith('ar');
    return wallet.items.map((item) {
      final (channel, icon) = switch (item.channel) {
        DepartmentWalletChannel.instantSettlement => (
            l10n.departmentInstantSettlement,
            Icons.flash_on
          ),
        DepartmentWalletChannel.alRajhiMainOperating => (
            l10n.alRajhiMainOperating,
            Icons.account_balance
          ),
        DepartmentWalletChannel.scheduledPayment => (
            l10n.departmentScheduledPayment,
            Icons.sync
          ),
        DepartmentWalletChannel.snbEscrow => (
            l10n.snbEscrowAccount,
            Icons.account_balance
          ),
        DepartmentWalletChannel.underInspection => (
            l10n.departmentUnderInspection,
            Icons.visibility
          ),
        DepartmentWalletChannel.inShipping => (
            l10n.departmentInShipping,
            Icons.local_shipping
          ),
        DepartmentWalletChannel.weeklySettlement => (
            l10n.departmentWeeklySettlement,
            Icons.calendar_today
          ),
        DepartmentWalletChannel.stcPay => (
            'STC Pay',
            Icons.account_balance_wallet
          ),
      };
      final status = switch (item.status) {
        DepartmentWalletStatus.activeMatched => l10n.departmentActiveMatched,
        DepartmentWalletStatus.protectedEscrow =>
          l10n.departmentProtectedEscrow,
        DepartmentWalletStatus.approvedProvider =>
          l10n.departmentApprovedProvider,
        DepartmentWalletStatus.strategicPartner =>
          l10n.departmentStrategicPartner,
        DepartmentWalletStatus.activeCourier => l10n.departmentActiveCourier,
      };
      return <String, dynamic>{
        'title': isArabic ? item.title : (item.titleEn ?? item.title),
        'id': item.reference,
        'available': item.availableBalance,
        'pending': item.pendingBalance,
        'operations': item.operationsCount.toString(),
        'bankText': channel,
        'bankIcon': icon,
        'status': status,
        'walletItem': item,
      };
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final colors = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                              color: AppColors.white,
                                              size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                                _screenTitleFor(context),
                                                style: const TextStyle(
                                                    color: AppColors.white,
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
                                                color: AppColors.white
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
                                                            color:
                                                                AppColors.white,
                                                            fontSize: 9),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Icon(Icons.verified,
                                                      color:
                                                          AppColors.blueAccent,
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
                                              color: AppColors.white60,
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
                                                  color: AppColors.white,
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(l10n.currencyEgy,
                                              style: const TextStyle(
                                                  color: AppColors.white70,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                          height: 1,
                                          color: AppColors.white
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
                                                        color:
                                                            AppColors.white60,
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
                                                        color:
                                                            AppColors.white60,
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
                                                        color:
                                                            AppColors.white60,
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
                                                        color:
                                                            AppColors.white60,
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
                                                          color:
                                                              AppColors.white54,
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
                                                        color:
                                                            AppColors.white60,
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
                                                        color:
                                                            AppColors.white60,
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
                                          Icon(Icons.tune,
                                              color: colors.primary, size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                                l10n
                                                    .departmentWalletSectionTitle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: colors.onSurface)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: colors.surfaceContainerHighest,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Text(l10n.departmentSyncStatus,
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: colors.onSurfaceVariant)),
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
                                          context,
                                          '${l10n.departmentAllFilter} 142',
                                          true),
                                      const SizedBox(width: 8),
                                      _buildFilterChip(
                                          context,
                                          l10n.departmentHighestBalanceFilter,
                                          false,
                                          icon: Icons.trending_up),
                                      const SizedBox(width: 8),
                                      _buildFilterChip(
                                          context,
                                          l10n.departmentWithdrawalFilter,
                                          false,
                                          icon: Icons.hourglass_empty),
                                      const SizedBox(width: 8),
                                      _buildFilterChip(context, '', false,
                                          icon: Icons.lock_outline,
                                          isIconOnly: true),
                                      const SizedBox(width: 8),
                                      _buildFilterChip(context, '', false,
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
                                    color: colors.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                                l10n.departmentGovernanceTitle,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: colors.primary)),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.verified_user_outlined,
                                              color: AppColors.blue700,
                                              size: 18),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        l10n.departmentGovernanceNotice,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: colors.onSurfaceVariant,
                                            height: 1.5),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        runSpacing: 4,
                                        children: [
                                          Text('ISO-20022 COMPLIANT',
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      colors.onSurfaceVariant),
                                              textDirection:
                                                  ui.TextDirection.ltr),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    l10n
                                                        .departmentLastReconciliation,
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        color: colors
                                                            .onSurfaceVariant)),
                                                const SizedBox(width: 4),
                                                Icon(Icons.circle,
                                                    size: 6,
                                                    color: AppColors.blue400),
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

  Widget _buildFilterChip(BuildContext context, String title, bool isSelected,
      {IconData? icon, bool isIconOnly = false, Color? iconColor}) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: isIconOnly ? 10 : 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isSelected ? colors.primary : colors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 14,
                color: iconColor ??
                    (isSelected ? colors.onPrimary : colors.primary)),
            if (!isIconOnly) const SizedBox(width: 6),
          ],
          if (!isIconOnly)
            Text(
              title,
              style: TextStyle(
                color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
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
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
              color: colors.shadow.withValues(alpha: 0.08),
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
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(Icons.storefront,
                        color: colors.onPrimary, size: 20), // Generic icon
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
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.security, size: 12, color: colors.primary),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Text(item['id'],
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: colors.onSurfaceVariant),
                                  textDirection: isArabic
                                      ? ui.TextDirection.rtl
                                      : ui.TextDirection.ltr,
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
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(item['status'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 9,
                            color: colors.onPrimaryContainer,
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
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.outlineVariant),
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
                            style: TextStyle(
                                fontSize: 10, color: colors.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                                child: Text(
                                    CurrencyFormatter.format(item['available'],
                                        includeCurrency: false),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 2),
                            Text(AppLocalizations.of(context)!.currencyEgy,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 1, height: 40, color: colors.outlineVariant),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.departmentUnderReview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10, color: colors.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                                child: Text(
                                    CurrencyFormatter.format(item['pending'],
                                        includeCurrency: false),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                  '${AppLocalizations.of(context)!.currencyEgy} ${isArabic ? l10n.departmentPendingSuffix : 'pending'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: colors.onSurfaceVariant)),
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
                      Icon(Icons.shopping_bag_outlined,
                          size: 14, color: colors.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${l10n.departmentMonthlySales}: ${item['operations']} ${l10n.departmentOperationsUnit}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 10, color: colors.onSurface),
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
                          size: 14, color: AppColors.blue700),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(item['bankText'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10, color: AppColors.blue700)),
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
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.receipt_long, size: 16),
                onPressed: () => _showTransactionHistory(
                  context,
                  item['walletItem'] as DepartmentWalletItemEntity,
                ),
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

  Future<void> _showTransactionHistory(
    BuildContext context,
    DepartmentWalletItemEntity item,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final transactions = [...item.transactions]
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => Directionality(
        textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.72,
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isArabic ? 'سجل الحركات المالية' : 'Financial activity',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isArabic ? item.title : (item.titleEn ?? item.title),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _balanceSummary(
                    context: context,
                    label: l10n.departmentAvailableBalance,
                    amount: item.availableBalance,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  _balanceSummary(
                    context: context,
                    label: l10n.departmentUnderReview,
                    amount: item.pendingBalance,
                    color: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                isArabic ? 'آخر الحركات' : 'Recent transactions',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Text(isArabic
                            ? 'لا توجد حركات مسجلة لهذه المحفظة.'
                            : 'No transactions are recorded for this wallet.'),
                      )
                    : ListView.separated(
                        itemCount: transactions.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 48),
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          final isCredit = transaction.amount >= 0;
                          final date = DateFormat.yMd(l10n.localeName)
                              .add_jm()
                              .format(transaction.occurredAt.toLocal());
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundColor: isCredit
                                  ? AppColors.green50
                                  : AppColors.red50,
                              child: Icon(
                                isCredit
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color:
                                    isCredit ? AppColors.green : AppColors.red,
                                size: 17,
                              ),
                            ),
                            title: Text(
                              isArabic
                                  ? transaction.descriptionAr
                                  : transaction.descriptionEn,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              transaction.isPending
                                  ? '$date • ${isArabic ? 'قيد المراجعة' : 'Pending review'}'
                                  : date,
                              style: const TextStyle(fontSize: 10),
                            ),
                            trailing: Text(
                              CurrencyFormatter.format(
                                transaction.amount.abs(),
                              ),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isCredit
                                    ? AppColors.green700
                                    : AppColors.red700,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _balanceSummary({
    required BuildContext context,
    required String label,
    required double amount,
    required Color color,
  }) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(amount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      );

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
