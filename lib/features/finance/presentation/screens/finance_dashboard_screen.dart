import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_locale_controller.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/department_wallet_entity.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../controllers/dashboard/finance_dashboard_cubit.dart';
import '../controllers/dashboard/finance_dashboard_state.dart';
import 'bank_accounts_screen.dart';
import 'merchant_withdrawals_screen.dart';
import 'finance_requests_center_screen.dart';
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
  int _pendingPromotionCount = 0;
  double _pendingPromotionAmount = 0;
  late final DateTime _sessionOpenedAt;

  @override
  void initState() {
    super.initState();
    _sessionOpenedAt = DateTime.now();
    _loadPendingPromotionSummary();

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

  Future<void> _loadPendingPromotionSummary() async {
    try {
      final result = await sl<FinanceRepository>().getMerchantWithdrawals();
      final requests = result.fold(
        (failure) => throw StateError(failure.message),
        (items) => items,
      );
      final pendingPromotions = requests.where((request) =>
          request.operationType == FinancialOperationType.promotion &&
          request.status == RequestStatus.pending);
      if (!mounted) return;
      setState(() {
        _pendingPromotionCount = pendingPromotions.length;
        _pendingPromotionAmount = pendingPromotions.fold(
            0.0, (sum, request) => sum + request.netAmount);
      });
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance dashboard',
        context: ErrorDescription('while loading pending promotion summary'),
      ));
    }
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
    final colors = Theme.of(context).colorScheme;
    final sessionTimestamp = DateFormat.yMd(l10n.localeName)
        .add_jm()
        .format(_sessionOpenedAt.toLocal());

    return BlocProvider(
      create: (_) => FinanceDashboardCubit(getFinanceSummaryUseCase: sl())
        ..loadDashboardData(),
      child: Directionality(
        textDirection: l10n.localeName.startsWith('ar')
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
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
                    backgroundColor: colors.surface,
                    foregroundColor: colors.onSurface,
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
                          backgroundColor: colors.surfaceContainerHighest,
                          child: Icon(
                            Icons.person_outline,
                            color: colors.primary,
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
                            color: colors.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.verified_outlined,
                              size: 13,
                              color: colors.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.cfoRole,
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.onSurfaceVariant,
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
                                color: colors.primary, size: 19),
                            const SizedBox(width: 3),
                            Text(
                              l10n.localeName.startsWith('ar')
                                  ? l10n.languageEnglish
                                  : l10n.languageArabic,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.shield_outlined,
                          color: colors.primary,
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
                        return Center(
                          child: CircularProgressIndicator(
                            color: colors.primary,
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
                                      sessionTimestamp,
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
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
                                  color: colors.onSurfaceVariant,
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
                                  color: colors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: colors.primary,
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
                                              color: colors.onSurfaceVariant,
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
                                    Icon(
                                      Icons.qr_code,
                                      size: 18,
                                      color: colors.primary,
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
                                    color: AppColors.primaryDark,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryDark.withValues(
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
                                            child: const Icon(
                                              Icons.account_balance,
                                              color: AppColors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              l10n.totalAggregatedLiquidity,
                                              style: TextStyle(
                                                color: colors.onPrimary.withValues(alpha: 0.72),
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                            color: colors.onPrimary.withValues(alpha: 0.72),
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
                                            color: colors.onPrimary,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: colors.onPrimary.withValues(alpha: 0.2),
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
                              // 4. مركز الطلبات المالية الموحّد
                              // =========================
                              _buildNavigationCard(
                                context,
                                title: l10n.localeName.startsWith('ar')
                                    ? 'مركز الطلبات المالية'
                                    : 'Financial requests center',
                                countText:
                                    '${data.pendingMerchantWithdrawalsCount + data.pendingSupervisorWithdrawalsCount} ${l10n.ordersUnit}',
                                amountText: CurrencyFormatter.format(
                                  data.pendingMerchantWithdrawalsAmount +
                                      data.pendingSupervisorWithdrawalsAmount,
                                ),
                                subtitle: l10n.localeName.startsWith('ar')
                                    ? 'طلبات السحب والإيداع والترويج من جميع الجهات'
                                    : 'Withdrawal, deposit and promotion requests from all sources',
                                icon: Icons.inbox_outlined,
                                actionButtonText:
                                    l10n.localeName.startsWith('ar')
                                        ? 'فتح مركز الطلبات'
                                        : 'Open requests center',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const FinanceRequestsCenterScreen(),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              _buildNavigationCard(
                                context,
                                title: l10n.localeName.startsWith('ar')
                                    ? '${l10n.productPromotionRequests} قيد المراجعة'
                                    : 'Product promotions awaiting review',
                                countText:
                                    '$_pendingPromotionCount ${l10n.ordersUnit}',
                                amountText: CurrencyFormatter.format(
                                  _pendingPromotionAmount,
                                ),
                                subtitle: l10n.localeName.startsWith('ar')
                                    ? 'طلبات أرسلها مشرفو المنتجات بعد مراجعتها'
                                    : 'Requests submitted by product supervisors',
                                icon: Icons.campaign_outlined,
                                actionButtonText:
                                    l10n.localeName.startsWith('ar')
                                        ? 'مراجعة الطلبات'
                                        : 'Review requests',
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const MerchantWithdrawalsScreen(
                                      promotionOnly: true,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // =========================
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
                              // 6. المصاريف والمدفوعات
                              // =========================
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: colors.outlineVariant,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: colors.primary,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.receipt_long,
                                            color: colors.onPrimary,
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
                                                  color: colors.onSurface,
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
                                                        color: colors.onSurface,
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
                                                        color: colors.onSurface,
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
                                                        color: colors.onSurfaceVariant,
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
                                              color: colors.secondaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 6,
                                                  color: colors.onSecondaryContainer,
                                                ),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    l10n.expenseManagement,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          colors.onSecondaryContainer,
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      child: Divider(
                                        color: colors.outlineVariant,
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
                                              color: colors.onSurface,
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
                                                color: colors.outlineVariant,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              l10n.scheduledDisbursementItems,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: colors.secondary,
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
                                          backgroundColor: colors.primary,
                                          foregroundColor: AppColors.white,
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
                                      context,
                                      title: l10n.monthlyEarnedCommissions,
                                      currencyText: l10n.currencyEgy,
                                      value: '284,900',
                                      icon: Icons.auto_graph,
                                      color: colors.secondary,
                                      badgeText: '+14.2%',
                                      badgeColor: colors.secondaryContainer,
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
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: colors.outlineVariant,
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
                                              color: colors.surfaceContainerHighest,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: colors.outlineVariant,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.gavel,
                                              color: colors.onSurfaceVariant,
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
                                                          color: colors.onSurface,
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
                                                          color: colors.onSurface,
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
                                                        color: colors.onSurfaceVariant,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(Icons.arrow_forward_ios,
                                              size: 12, color: colors.onSurfaceVariant),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        l10n.frozenWalletsNote,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: colors.onSurfaceVariant,
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
                                          color: colors.primary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            l10n.operationalDepartmentsWallets,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: colors.onSurface,
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
                                      color: colors.secondary,
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
                                  color: colors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: colors.outlineVariant,
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
                                                color: colors.primary,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  l10n.instantLiquidityAdequacyRatio,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: colors.onSurface,
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
                                              color: colors.secondaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  size: 14,
                                                  color: colors.onSecondaryContainer,
                                                ),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    l10n.verySafeAndStable,
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: colors.onSecondaryContainer,
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
                                        color: colors.surfaceContainerHigh,
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
                                                color: colors.primary,
                                                width: 6,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '99.8%',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: colors.primary,
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
                                                    color: colors.onSurfaceVariant,
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
                                                          color: colors.onSurface,
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
                                                          color: colors.secondary,
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
                                                    color: colors.onSurfaceVariant,
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
                                          color: colors.outlineVariant,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.domain_verification,
                                            color: colors.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              l10n.autoBankingSettlement,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: colors.onSurface,
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
                                                color: colors.onSurface,
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
                                  color: colors.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: colors.secondaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.policy_outlined,
                                            color: colors.onSecondaryContainer,
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
                                              color: colors.onSurface,
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
                                            color: colors.secondaryContainer,
                                            child: Text(
                                              l10n.governancePolicyClause,
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: colors.onSecondaryContainer,
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
                                        color: colors.onSurfaceVariant,
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
                                    backgroundColor: colors.primary,
                                    foregroundColor: AppColors.white,
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
                                          const FinanceRequestsCenterScreen(),
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
                                    foregroundColor: colors.primary,
                                    side: const BorderSide(
                                      color: AppColors.transparent,
                                    ),
                                    backgroundColor: colors.surface,
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
    return Row(
      children: [
        const CircleAvatar(
          radius: 3,
          backgroundColor: AppColors.white54,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white70,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          style: const TextStyle(
            color: AppColors.white,
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
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.outlineVariant,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.08),
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
                    color: colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: colors.primary,
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
                          color: colors.onSurfaceVariant,
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
                                color: colors.onSurface,
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
                                color: colors.secondary,
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
                  Directionality.of(context) == ui.TextDirection.rtl
                      ? Icons.arrow_back_ios
                      : Icons.arrow_forward_ios,
                  size: 12,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: colors.onSurfaceVariant,
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
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      size: 16,
                      color: colors.onSecondaryContainer,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        actionButtonText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colors.onSecondaryContainer,
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
  Widget _buildMetricTileNew(
    BuildContext context, {
    required String title,
    required String currencyText,
    required String value,
    required IconData icon,
    required Color color,
    required String badgeText,
    required Color badgeColor,
    required String bottomText,
    required String bottomLink,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.outlineVariant,
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
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
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
                    color: colors.onSurface,
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
                  color: colors.onSurface,
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
                    color: colors.onSurfaceVariant,
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
                    color: colors.secondary,
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
    final colors = Theme.of(context).colorScheme;

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
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colors.outlineVariant,
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
                      color: colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: colors.onSecondaryContainer,
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
                            color: colors.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 9,
                            color: colors.onSurfaceVariant,
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
                        color: colors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currencyText,
                      style: TextStyle(
                        fontSize: 9,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
