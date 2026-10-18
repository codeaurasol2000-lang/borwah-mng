import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_locale_controller.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/department_wallet_entity.dart';
import '../controllers/dashboard/finance_dashboard_cubit.dart';
import '../controllers/dashboard/finance_dashboard_state.dart';
import 'bank_accounts_screen.dart';
import 'unified_withdrawal_requests_screen.dart';
import 'subscriptions_screen.dart';
import 'expenses_management_screen.dart';
import 'frozen_requests_screen.dart';
import 'profile_screen.dart';
import 'department_wallet_screen.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/finance_navigation.dart';

class FinanceDashboardScreen extends StatefulWidget {
  final bool showBottomNavigation;
  final VoidCallback onLogout;

  const FinanceDashboardScreen({
    super.key,
    this.showBottomNavigation = true,
    required this.onLogout,
  });

  @override
  State<FinanceDashboardScreen> createState() => _FinanceDashboardScreenState();
}

class _FinanceDashboardScreenState extends State<FinanceDashboardScreen>
    with AutomaticKeepAliveClientMixin<FinanceDashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavVisible = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isNavVisible) {
          setState(() {
            _isNavVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isNavVisible) {
          setState(() {
            _isNavVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final palette = context.appThemePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => FinanceDashboardCubit(getFinanceSummaryUseCase: sl())
        ..loadDashboardData(),
      child: Directionality(
        textDirection: l10n.localeName.startsWith('ar')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: FinanceSwipeNavigation(
          currentIndex: 4,
          enabled: widget.showBottomNavigation,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,

            // =========================
            // App Bar
            // =========================
            appBar: widget.showBottomNavigation
                ? AppBar(
                    titleSpacing: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ProfileScreen(onLogout: widget.onLogout)),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: isDark
                              ? palette.surfaceElevated
                              : AppColors.surfaceLight,
                          child: Icon(
                            Icons.person_outline,
                            color: palette.accent,
                          ),
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.appName,
                          style: TextStyle(
                            color: palette.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_outlined,
                              size: 13,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.cfoRole,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        tooltip: l10n.switchLanguage,
                        onPressed: AppLocaleController.instance.toggle,
                        icon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.translate,
                                color: palette.accent, size: 19),
                            const SizedBox(width: 3),
                            Text(
                              l10n.localeName.startsWith('ar')
                                  ? l10n.languageEnglish
                                  : l10n.languageArabic,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: palette.accent),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.shield_outlined,
                          color: palette.accent,
                        ),
                      ),
                    ],
                  )
                : null,

            // =========================
            // Body
            // =========================
            body: Stack(
              children: [
                Positioned.fill(
                  child:
                      BlocBuilder<FinanceDashboardCubit, FinanceDashboardState>(
                    builder: (context, state) {
                      if (state is FinanceDashboardLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryDark,
                          ),
                        );
                      }

                      if (state is FinanceDashboardLoaded) {
                        final data = state.summary;

                        return SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ).copyWith(bottom: 90),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // =========================
                              // 1. الجلسة المالية المباشرة والتاريخ
                              // =========================
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircleAvatar(
                                          radius: 4,
                                          backgroundColor: AppColors.info,
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            l10n.liveFinancialSession,
                                            style: const TextStyle(
                                              color: AppColors.info,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      l10n.cfoSessionTimestamp,
                                      style: TextStyle(
                                        color: Colors.blueGrey[400],
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                l10n.financialControlTitle,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                l10n.cfoControlPanelSubtitle,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blueGrey[500],
                                ),
                              ),

                              const SizedBox(height: 14),
                              // =========================
                              // 2. بطاقة المسؤول التنفيذي
                              // =========================
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? palette.surfaceElevated
                                      : AppColors.surfaceHighlight,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: palette.accent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            l10n.cfoName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            l10n.cfoRole,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: palette.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      l10n.cfoBadgeCode,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.qr_code,
                                      size: 18,
                                      color: AppColors.primaryDark,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // =========================
                              // 3. كارت السيولة الإجمالية
                              // =========================
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BankAccountsScreen(),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? palette.accent
                                        : AppColors.primaryDark,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: palette.accent.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.surface.withValues(
                                                alpha: 0.12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              Icons.account_balance,
                                              color: colorScheme.onPrimary,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              l10n.totalAggregatedLiquidity,
                                              style: TextStyle(
                                                color: colorScheme.onPrimary
                                                    .withValues(alpha: 0.7),
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                            color: colorScheme.onPrimary
                                                .withValues(alpha: 0.7),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          CurrencyFormatter.format(
                                            data.totalLiquidity,
                                          ),
                                          style: TextStyle(
                                            color: colorScheme.onPrimary,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: colorScheme.onPrimary
                                            .withValues(alpha: 0.2),
                                        height: 20,
                                      ),
                                      _buildBankSubRow(
                                        l10n.alRajhiMainOperating,
                                        CurrencyFormatter.format(
                                          data.rajhiAccountBalance,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildBankSubRow(
                                        l10n.snbEscrowAccount,
                                        CurrencyFormatter.format(
                                          data.snbEscrowBalance,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // =========================
                              // 4. طلبات السحب
                              // =========================
                              _buildNavigationCard(
                                context,
                                title: l10n.navWithdrawalOrders,
                                countText:
                                    '${data.pendingMerchantWithdrawalsCount + data.pendingSupervisorWithdrawalsCount} ${l10n.ordersUnit}',
                                amountText: CurrencyFormatter.format(
                                  data.pendingMerchantWithdrawalsAmount +
                                      data.pendingSupervisorWithdrawalsAmount,
                                ),
                                subtitle: l10n.auditInvoiceNote,
                                icon: Icons.account_balance_wallet_outlined,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const UnifiedWithdrawalRequestsScreen(),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // =========================
                              // 5. الاشتراكات والترقيات
                              // =========================
                              _buildNavigationCard(
                                context,
                                title: l10n.pendingSubscriptionsTitle,
                                countText:
                                    '${data.pendingSubscriptionsCount} ${l10n.ordersUnit}',
                                amountText: CurrencyFormatter.format(
                                  data.pendingSubscriptionsAmount,
                                ),
                                subtitle: l10n.pendingSubscriptionsSubtitle,
                                icon: Icons.subscriptions_outlined,
                                actionButtonText:
                                    '${l10n.reviewSubscriptionsAction} (${data.pendingSubscriptionsCount})',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SubscriptionsScreen(),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // =========================
                              // 7. المصاريف والمدفوعات
                              // =========================
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      isDark ? palette.surface : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark
                                        ? palette.border
                                        : AppColors.cardBorder,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? palette.accentContainer
                                                : const Color(0xFFF1F5F9),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.receipt_long,
                                            color: palette.accent,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n.operationalExpenses,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark
                                                      ? palette.textPrimary
                                                      : Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      '58,400',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isDark
                                                            ? palette
                                                                .textPrimary
                                                            : Colors.black87,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      l10n.currencyEgy,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isDark
                                                            ? palette
                                                                .textPrimary
                                                            : Colors.black87,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      l10n.monthlyTotalExpenses,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: isDark
                                                            ? palette
                                                                .textSecondary
                                                            : Colors.grey,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? palette.accentContainer
                                                  : Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 6,
                                                  color: isDark
                                                      ? palette.accent
                                                      : Colors.blue.shade700,
                                                ),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    l10n.expenseManagement,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDark
                                                          ? palette.accent
                                                          : Colors
                                                              .blue.shade700,
                                                      height: 1.2,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Divider(
                                        color: isDark
                                            ? palette.border
                                            : AppColors.cardBorder,
                                        height: 1,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.ongoingOperatingInvoices,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark
                                                  ? palette.textPrimary
                                                  : Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: isDark
                                                    ? palette.border
                                                    : Colors.blue.shade100,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              l10n.scheduledDisbursementItems,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isDark
                                                    ? palette.accent
                                                    : Colors.blue,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDark
                                              ? palette.accent
                                              : const Color(0xFF0F172A),
                                          foregroundColor:
                                              colorScheme.onPrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const ExpensesManagementScreen()),
                                          );
                                        },
                                        label: Text(
                                          l10n.recordNewPayment,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // =========================
                              // 8. مؤشرات العمولات والأرصدة
                              // =========================
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMetricTileNew(
                                      title: l10n.monthlyEarnedCommissions,
                                      currencyText: l10n.currencyEgy,
                                      value: '284,900',
                                      icon: Icons.auto_graph,
                                      color: Colors.blue.shade700,
                                      badgeText: '+14.2%',
                                      badgeColor: Colors.blue.shade50,
                                      badgeTextColor: Colors.blue.shade700,
                                      bottomText: l10n.comparedToLastMonth,
                                      bottomLink: l10n.netRegulatoryRevenue,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const FrozenRequestsScreen()),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? palette.surface
                                        : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark
                                          ? palette.border
                                          : AppColors.cardBorder,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? palette.surfaceElevated
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: isDark
                                                    ? palette.border
                                                    : Colors.grey.shade200,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.gavel,
                                              color: palette.textSecondary,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.circle,
                                                      size: 6,
                                                      color: AppColors.danger,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        l10n.balancesUnderRegulatoryAudit,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: isDark
                                                              ? palette
                                                                  .textPrimary
                                                              : Colors.black87,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        '25,400',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isDark
                                                              ? palette
                                                                  .textPrimary
                                                              : Colors.black87,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      l10n.currencyEgy,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: isDark
                                                            ? palette
                                                                .textSecondary
                                                            : Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                            color: palette.textSecondary,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        l10n.frozenWalletsNote,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark
                                              ? palette.textSecondary
                                              : Colors.grey.shade600,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // =========================
                              // 9. محافظ الأقسام التشغيلية
                              // =========================
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.account_balance_wallet,
                                          color: palette.accent,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            l10n.operationalDepartmentsWallets,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: isDark
                                                  ? palette.textPrimary
                                                  : Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      l10n.activeSectorsCount,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? palette.accent
                                            : Colors.blue.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              _buildWalletRowNew(
                                context,
                                l10n.merchantsWalletTitle,
                                l10n.merchantsWalletDesc,
                                '2,150,000',
                                Icons.storefront,
                                DepartmentType.merchants,
                              ),

                              const SizedBox(height: 8),

                              _buildWalletRowNew(
                                context,
                                l10n.usedAndEscrowWalletTitle,
                                l10n.usedAndEscrowWalletDesc,
                                '980,000',
                                Icons.handshake_outlined,
                                DepartmentType.usedEscrow,
                              ),

                              const SizedBox(height: 8),

                              _buildWalletRowNew(
                                context,
                                l10n.servicesMaintenanceWalletTitle,
                                l10n.servicesMaintenanceWalletDesc,
                                '620,000',
                                Icons.build_circle_outlined,
                                DepartmentType.services,
                              ),

                              const SizedBox(height: 8),

                              _buildWalletRowNew(
                                context,
                                l10n.deliveryLogisticsWalletTitle,
                                l10n.deliveryLogisticsWalletDesc,
                                '450,000',
                                Icons.local_shipping_outlined,
                                DepartmentType.couriers,
                              ),

                              const SizedBox(height: 16),

                              // =========================
                              // 10. مؤشر كفاية السيولة
                              // =========================
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      isDark ? palette.surface : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark
                                        ? palette.border
                                        : AppColors.cardBorder,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.shield_outlined,
                                                color: palette.accent,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  l10n.instantLiquidityAdequacyRatio,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: palette.textPrimary,
                                                    height: 1.2,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? palette.accentContainer
                                                  : Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  size: 14,
                                                  color: isDark
                                                      ? palette.accent
                                                      : Colors.blue.shade700,
                                                ),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    l10n.verySafeAndStable,
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: isDark
                                                          ? palette.accent
                                                          : Colors
                                                              .blue.shade700,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.2,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? palette.surfaceElevated
                                            : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: palette.accent,
                                                width: 6,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '99.8%',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: palette.accent,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  l10n.dailyWithdrawalCoverageRatio,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        palette.textSecondary,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        '99.8%',
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isDark
                                                              ? palette
                                                                  .textPrimary
                                                              : Colors.black87,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Flexible(
                                                      child: Text(
                                                        l10n.excessCashCoverage,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: isDark
                                                              ? palette.accent
                                                              : Colors.blue
                                                                  .shade700,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  l10n.statutoryMinimumRequirement,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        palette.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isDark
                                              ? palette.border
                                              : Colors.grey.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.domain_verification,
                                            color: palette.accent,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              l10n.autoBankingSettlement,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isDark
                                                    ? palette.textPrimary
                                                    : Colors.black87,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              l10n.completedAndMatched,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? palette.textPrimary
                                                    : Colors.black87,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // =========================
                              // 11. لائحة الحوكمة
                              // =========================
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? palette.surfaceElevated
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? palette.surface
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.policy_outlined,
                                            color: isDark
                                                ? palette.textPrimary
                                                : Colors.black87,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            l10n.financialGovernanceTitle,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? palette.textPrimary
                                                  : Colors.black87,
                                              height: 1.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            color: isDark
                                                ? palette.surface
                                                : Colors.white,
                                            child: Text(
                                              l10n.governancePolicyClause,
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? palette.textSecondary
                                                    : Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.governancePolicyNotice,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark
                                            ? palette.textSecondary
                                            : Colors.grey.shade700,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // =========================
                              // Bottom Actions
                              // =========================
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark
                                        ? palette.accent
                                        : const Color(0xFF0F172A),
                                    foregroundColor: colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.check_circle_outline,
                                    size: 18,
                                  ),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const UnifiedWithdrawalRequestsScreen(),
                                    ),
                                  ),
                                  label: Text(
                                    l10n.urgentWithdrawalsAction,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: palette.accent,
                                    side: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    backgroundColor:
                                        isDark ? palette.surface : Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.picture_as_pdf_outlined,
                                    size: 18,
                                  ),
                                  onPressed: () {},
                                  label: Text(
                                    l10n.exportDailyReportPdf,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),
                            ],
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),

                // =========================
                // Floating Bottom Navigation
                // =========================
                if (widget.showBottomNavigation)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 300),
                      offset: _isNavVisible ? Offset.zero : const Offset(0, 1),
                      child: FinanceBottomNavigationBar(
                        currentIndex: 4,
                        onTap: (index) => FinanceNavigation.openTab(
                          context,
                          index,
                          currentIndex: 4,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // Bank Row
  // =========================
  Widget _buildBankSubRow(
    String title,
    String amount,
  ) {
    final color = Theme.of(context).colorScheme.onPrimary;
    return Row(
      children: [
        CircleAvatar(
          radius: 3,
          backgroundColor: color.withValues(alpha: 0.54),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // =========================
  // Navigation Card
  // =========================
  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String countText,
    required String amountText,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    String? actionButtonText,
  }) {
    final palette = context.appThemePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? palette.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? palette.border : AppColors.cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.02,
              ),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? palette.accentContainer
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: palette.accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? palette.textSecondary : Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              countText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? palette.textPrimary
                                    : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '($amountText)',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? palette.accent
                                    : Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_back_ios
                      : Icons.arrow_forward_ios,
                  size: 12,
                  color: isDark ? palette.textSecondary : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? palette.textSecondary : Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (actionButtonText != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDark ? palette.accentContainer : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      size: 16,
                      color: palette.accent,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        actionButtonText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: palette.accent,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================
  // Metric Tile
  // =========================
  Widget _buildMetricTileNew({
    required String title,
    required String currencyText,
    required String value,
    required IconData icon,
    required Color color,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String bottomText,
    required String bottomLink,
  }) {
    final palette = context.appThemePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final metricColor = isDark ? palette.accent : color;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? palette.surface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? palette.border : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? palette.textPrimary : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? palette.accentContainer : badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: metricColor,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? palette.textPrimary : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                currencyText,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? palette.textPrimary : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  bottomText,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? palette.textSecondary : Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  bottomLink,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? palette.accent : Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================
  // Wallet Row
  // =========================
  Widget _buildWalletRowNew(
    BuildContext context,
    String title,
    String subtitle,
    String balance,
    IconData icon,
    DepartmentType type,
  ) {
    final currencyText = AppLocalizations.of(context)!.currencyEgy;
    final palette = context.appThemePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DepartmentWalletScreen(type: type)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? palette.surface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? palette.border : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? palette.accentContainer
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: palette.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? palette.textPrimary : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 9,
                            color: isDark ? palette.textSecondary : Colors.grey,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      balance,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? palette.textPrimary : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currencyText,
                      style: TextStyle(
                        fontSize: 9,
                        color: isDark ? palette.textSecondary : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
