import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/merchant_supervisor_local_store.dart';
import '../../domain/entities/merchant_entity.dart';
import '../../domain/entities/supervisor_stats_entity.dart';
import '../controllers/merchants_cubit.dart';
import '../controllers/merchants_state.dart';
import 'merchant_conversation_screen.dart';
import 'merchant_details_screen.dart';

class SupervisedMerchantsScreen extends StatelessWidget {
  const SupervisedMerchantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MerchantsCubit>()..loadSupervisedMerchants(),
      child: const _SupervisedMerchantsContent(),
    );
  }
}

class _SupervisedMerchantsContent extends StatefulWidget {
  const _SupervisedMerchantsContent();

  @override
  State<_SupervisedMerchantsContent> createState() =>
      _SupervisedMerchantsContentState();
}

class _SupervisedMerchantsContentState
    extends State<_SupervisedMerchantsContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _showAllRemaining = false;
  int _selectedChipIndex = 0;
  Map<String, bool> _suspensionOverrides = const {};

  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _surfaceContainer =>
      Theme.of(context).colorScheme.surfaceContainerLow;
  Color get _onSurface => Theme.of(context).colorScheme.onSurface;
  Color get _onSurfaceVariant =>
      Theme.of(context).colorScheme.onSurfaceVariant;
  Color get _outline => Theme.of(context).colorScheme.outlineVariant;
  Color get _primaryText => Theme.of(context).colorScheme.primary;

  @override
  void initState() {
    super.initState();
    MerchantSupervisorLocalStore.revision.addListener(_onSuspensionChanged);
    _loadSuspensionOverrides();
  }

  @override
  void dispose() {
    MerchantSupervisorLocalStore.revision.removeListener(_onSuspensionChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSuspensionChanged() {
    _loadSuspensionOverrides();
  }

  Future<void> _loadSuspensionOverrides() async {
    try {
      final overrides =
          await MerchantSupervisorLocalStore.getSuspensionOverrides();
      if (mounted) setState(() => _suspensionOverrides = overrides);
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant suspension status',
        ),
      );
    }
  }

  bool _isSuspended(MerchantEntity merchant) =>
      _suspensionOverrides[merchant.id] ??
      (merchant.isSuspended ||
          merchant.status == MerchantStatus.temporarilySuspended);

  void _onChipSelected(int index, MerchantsCubit cubit) {
    setState(() {
      _selectedChipIndex = index;
    });

    MerchantStatus? status;
    if (index == 1) {
      status = MerchantStatus.activeVerified;
    } else if (index == 2) {
      status = MerchantStatus.underAudit;
    }

    cubit.setFilterStatus(status, index);
  }

  Future<void> _liftSuspension(
    BuildContext context,
    MerchantEntity merchant,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.merchantUnsuspendAction),
        content: Text(l10n.merchantUnsuspendConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.merchantUnsuspendAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    try {
      await MerchantSupervisorLocalStore.setMerchantSuspended(
        merchantId: merchant.id,
        merchantName: merchant.getName(isArabic),
        isSuspended: false,
        action: l10n.merchantAuditUnsuspended,
        details: l10n.merchantUnsuspendSuccess,
      );
      if (context.mounted) {
        AppSnackBar.showSuccess(context, l10n.merchantUnsuspendSuccess);
      }
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant suspension status',
        ),
      );
      if (context.mounted) {
        AppSnackBar.showError(context, l10n.merchantSuspensionSaveError);
      }
    }
  }

  void _showAddMerchantSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final crController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(sheetContext).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.storefront_outlined,
                      color: AppColors.primaryDark,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.addNewMerchantToSupervision,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.supervisedAreaLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.merchantNameField,
                  hintText: 'مثال: شركة الرواد للتجارة',
                  prefixIcon: const Icon(Icons.business_outlined, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: crController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.merchantCrField,
                  hintText: '1010XXXXXX',
                  prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: l10n.merchantPhoneField,
                  hintText: '+966 5X XXX XXXX',
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  AppSnackBar.showSuccess(
                    context,
                    'تم إرسال طلب ضم التاجر لنطاق إشرافك بنجاح',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.addNewMerchantToSupervision,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSummonDialog(BuildContext context, MerchantEntity merchant) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.gavel_outlined, color: AppColors.primaryDark),
            const SizedBox(width: 10),
            Text(l10n.summonAction),
          ],
        ),
        content: Text(
          'هل ترغب في توجيه استدعاء رسمي للمفوض (${merchant.getDelegateName(true)}) للحضور ومطابقة الشروط؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.matrixCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              AppSnackBar.showInfo(
                context,
                'تم إرسال إشعار الاستدعاء الرسمي للتاجر ${merchant.getName(true)}',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.white,
            ),
            child: const Text('تأكيد الاستدعاء'),
          ),
        ],
      ),
    );
  }

  void _showReviewViolationDialog(
      BuildContext context, MerchantEntity merchant) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.verified_outlined, color: AppColors.infoDark),
            const SizedBox(width: 10),
            Text(l10n.reviewViolationAndUnfreeze),
          ],
        ),
        content: const Text(
          'سيتم مراجعة تقرير المخالفة VR3-858 والتحقق من تعديل الإعلانات المخالفة لإلغاء التعليق المؤقت.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.matrixCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              AppSnackBar.showInfo(
                context,
                'تم فتح محضر مراجعة المخالفة للمتجر ${merchant.getName(true)}',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.infoDark,
              foregroundColor: AppColors.white,
            ),
            child: const Text('بدء المراجعة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<MerchantsCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: _buildCustomAppBar(context, l10n),
      body: BlocBuilder<MerchantsCubit, MerchantsState>(
        builder: (context, state) {
          if (state is MerchantsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryDark),
            );
          }

          if (state is MerchantsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.dangerDark, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => cubit.loadMerchants(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: AppColors.white,
                    ),
                    child: Text(l10n.retryLoadMerchants),
                  ),
                ],
              ),
            );
          }

          if (state is! MerchantsLoaded) {
            return const SizedBox.shrink();
          }

          final stats = state.stats;
          final isSuspendedFilter = _selectedChipIndex == 3;
          final merchants = state.filteredMerchants
              .where((merchant) => isSuspendedFilter
                  ? _isSuspended(merchant)
                  : _suspensionOverrides[merchant.id] != true)
              .toList(growable: false);

          final isAllFilterActive =
              _selectedChipIndex == 0 && _searchController.text.trim().isEmpty;
          final displayedMerchants =
              (isAllFilterActive && !_showAllRemaining && merchants.length > 5)
                  ? merchants.sublist(0, 5)
                  : merchants;

          return Stack(
            children: [
              // 1. القائمة القابلة للتمرير تأخذ المساحة الكاملة
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom:
                        90, // مسافة سفليّة كافية لتجنب اختفاء المحتوى خلف الزر
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Supervision Scope Strip
                      _buildSupervisionScopeStrip(context, stats, l10n),
                      const SizedBox(height: 14),

                      // Field Accounts Overview Card
                      _buildFieldAccountsOverviewCard(context, stats, l10n),
                      const SizedBox(height: 16),

                      // Search Bar
                      _buildSearchBar(context, cubit, l10n),
                      const SizedBox(height: 12),

                      // Filter Chips Row
                      _buildFilterChipsRow(
                        context,
                        stats,
                        cubit,
                        l10n,
                        suspendedCount:
                            state.allMerchants.where(_isSuspended).length,
                      ),
                      const SizedBox(height: 14),
                      if (isSuspendedFilter) ...[
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            l10n.merchantSuspendedSection,
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Sort & Result Count Header
                      _buildSortHeader(context, merchants.length, l10n),
                      const SizedBox(height: 10),

                      // Merchants List
                      if (merchants.isEmpty)
                        _buildEmptyState(context, l10n)
                      else ...[
                        for (final merchant in displayedMerchants)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildMerchantCard(
                              context,
                              merchant,
                              l10n,
                              isSuspended: _isSuspended(merchant),
                            ),
                          ),
                        if (isAllFilterActive && !_showAllRemaining)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildRemainingStoresCard(
                              context,
                              remainingCount: 13,
                              l10n: l10n,
                              onToggle: () {
                                setState(() {
                                  _showAllRemaining = true;
                                });
                              },
                            ),
                          ),
                      ],

                      // Field Governance Policy Card
                      _buildFieldGovernanceCard(context, l10n),
                    ],
                  ),
                ),
              ),

              // 2. الزر العائم تثبيته في أسفل الشاشة بدون خلفية
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: SafeArea(
                  child: _buildStickyBottomButton(context, l10n),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(
      BuildContext context, AppLocalizations l10n) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back,
            color: AppColors.primaryDark, size: 22),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  l10n.supervisedMerchantsBadge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            l10n.merchantsUnderSupervisionTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon:
              const Icon(Icons.search, color: AppColors.primaryDark, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSupervisionScopeStrip(BuildContext context,
      SupervisorStatsEntity stats, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hexFF1E2D4A),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.hexFF0284C7.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.hexFF38BDF8.withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              stats.supervisorCode,
              style: const TextStyle(
                color: AppColors.hexFF38BDF8,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.supervisedAreaLabel,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.supervisorFullName,
                  style: const TextStyle(
                    color: AppColors.hexFF94A3B8,
                    fontSize: 11.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldAccountsOverviewCard(BuildContext context,
      SupervisorStatsEntity stats, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.hexFF1E2D4A),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.folder_shared_outlined,
                color: AppColors.hexFF38BDF8,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.totalFieldAccountsTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.hexFFCBD5E1,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${stats.totalCount}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.merchantsUnderYourSupervision,
                      style: const TextStyle(
                        color: AppColors.hexFF94A3B8,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: 62,
                    height: 62,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: stats.compliancePercentage / 100,
                          strokeWidth: 6,
                          backgroundColor: AppColors.white.withValues(alpha: 0.12),
                          color: AppColors.hexFF10B981,
                        ),
                        Text(
                          '${stats.compliancePercentage}%',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.complianceRate,
                    style: const TextStyle(
                      color: AppColors.hexFF94A3B8,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(color: AppColors.white.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildOverviewMiniBlock(
                  color: AppColors.hexFF10B981,
                  count: stats.activeVerifiedCount,
                  label: l10n.activeAndVerifiedMetric,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildOverviewMiniBlock(
                  color: AppColors.hexFFF59E0B,
                  count: stats.pendingAlertsCount,
                  label: l10n.pendingAlertsMetric,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildOverviewMiniBlock(
                  color: AppColors.hexFFEF4444,
                  count: stats.suspendedCount,
                  label: l10n.temporarySuspendedMetric,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewMiniBlock({
    required Color color,
    required int count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.hexFF0F1E36,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.hexFF94A3B8,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, MerchantsCubit cubit, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          cubit.searchMerchants(val);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: l10n.searchMerchantPlaceholder,
          hintStyle: TextStyle(
            color: _onSurfaceVariant,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: _onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  color: _onSurfaceVariant,
                  onPressed: () {
                    _searchController.clear();
                    cubit.searchMerchants('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterChipsRow(BuildContext context, SupervisorStatsEntity stats,
      MerchantsCubit cubit, AppLocalizations l10n,
      {required int suspendedCount}) {
    final chips = [
      {'label': l10n.filterAllWithCount(stats.totalCount), 'color': null},
      {
        'label': l10n.filterActiveWithCount(stats.activeVerifiedCount),
        'color': AppColors.hexFF10B981
      },
      {
        'label': l10n.filterPendingWithCount(stats.pendingAlertsCount),
        'color': AppColors.hexFFF59E0B
      },
      {
        'label': l10n.filterSuspendedWithCount(suspendedCount),
        'color': AppColors.hexFFEF4444
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (int i = 0; i < chips.length; i++) ...[
            _buildFilterChip(
              label: chips[i]['label'] as String,
              dotColor: chips[i]['color'] as Color?,
              isSelected: _selectedChipIndex == i,
              onTap: () => _onChipSelected(i, cubit),
            ),
            if (i < chips.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    Color? dotColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark : _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  isSelected ? AppColors.primaryDark : _outline,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.white : _onSurface,
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortHeader(
      BuildContext context, int count, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(
                Icons.swap_vert,
                size: 18,
                color: AppColors.hexFF64748B,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  l10n.sortMostActive,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.hexFF64748B,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($count تاجر)',
          style: const TextStyle(
            color: AppColors.hexFF94A3B8,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outline),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.storefront_outlined,
            size: 48,
            color: AppColors.hexFF94A3B8,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noMerchantsFound,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantCard(
    BuildContext context,
    MerchantEntity merchant,
    AppLocalizations l10n, {
    required bool isSuspended,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final hasFinancialAlert = merchant.financialWithdrawalAlert != null;
    final hasSupervisoryNote = merchant.violationNotice != null && !isSuspended;

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isSuspended ? AppColors.hexFFFCA5A5 : _outline,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _surfaceContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  merchant.getCode(),
                  style: TextStyle(
                    color: _onSurface,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: _buildStatusPill(merchant, isSuspended,
                    hasFinancialAlert, hasSupervisoryNote, l10n),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            merchant.getName(isArabic),
            style: TextStyle(
              color: _primaryText,
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: _merchantTierBadge(l10n, merchant.isFeatured),
          ),
          const SizedBox(height: 4),
          Text(
            '${merchant.getLocation(isArabic)} • ${merchant.getDelegateName(isArabic)}',
            style: TextStyle(
              color: _onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          if (hasFinancialAlert) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.hexFFFFFBEB,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.hexFFFDE68A),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.hexFFD97706,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      merchant.financialWithdrawalAlert!,
                      style: const TextStyle(
                        color: AppColors.hexFFB45309,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (hasSupervisoryNote) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.hexFFEFF6FF,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.hexFFBFDBFE),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.hexFF2563EB,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      merchant.violationNotice!,
                      style: const TextStyle(
                        color: AppColors.hexFF1D4ED8,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isSuspended && merchant.violationNotice != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.hexFFFEF2F2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.hexFFFECACA),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.report_problem_outlined,
                    color: AppColors.hexFFDC2626,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.descriptionStandardsViolation,
                          style: const TextStyle(
                            color: AppColors.hexFFB91C1C,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.zeroAdsDisplayedSuspended,
                          style: const TextStyle(
                            color: AppColors.hexFFEF4444,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  value: '${merchant.activeAdsCount ?? merchant.adsCount}',
                  label: l10n.activeAdsHeader,
                  valueColor: isSuspended
                      ? AppColors.hexFF94A3B8
                      : AppColors.hexFF0F172A,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  value: '${merchant.pendingReviewCount ?? 0}',
                  label: l10n.pendingReviewHeader,
                  valueColor: (merchant.pendingReviewCount ?? 0) > 0
                      ? AppColors.hexFFD97706
                      : AppColors.hexFF0F172A,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  value: isSuspended
                      ? l10n.suspendedBadge
                      : 'عمولة ${merchant.commissionPercent ?? 5.0}%',
                  label: isSuspended
                      ? 'الحالة: موقوف'
                      : (merchant.deliveryStatus != null
                          ? 'التسليم: ${merchant.deliveryStatus}'
                          : l10n.deliveryStatusFieldInspection),
                  valueColor: isSuspended
                      ? AppColors.hexFFDC2626
                      : AppColors.hexFF0F172A,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isSuspended) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _liftSuspension(context, merchant, l10n),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.successDark,
                      side: const BorderSide(color: AppColors.hexFFBBE8D1),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      l10n.merchantUnsuspendAction,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showSummonDialog(context, merchant),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.hexFFB45309,
                      side: const BorderSide(color: AppColors.hexFFFDE68A),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      l10n.summonAction,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showReviewViolationDialog(context, merchant),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.hexFFDC2626,
                  side: const BorderSide(color: AppColors.hexFFFECACA),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  l10n.reviewViolationAndUnfreeze,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              _buildIconButton(
                icon: Icons.phone_outlined,
                onTap: () {
                  AppSnackBar.showInfo(
                    context,
                    'الاتصال بالتاجر: ${merchant.contactPhone ?? "+966 50 123 4567"}',
                  );
                },
              ),
              const SizedBox(width: 8),
              _buildIconButton(
                icon: Icons.chat_bubble_outline,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          MerchantConversationScreen(merchant: merchant),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MerchantDetailsScreen(
                          merchant: merchant,
                          isLocallySuspended: _suspensionOverrides[merchant.id],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.viewProfileAndControl,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _merchantTierBadge(AppLocalizations l10n, bool isFeatured) {
    final color =
        isFeatured ? AppColors.hexFF9A6700 : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFeatured ? AppColors.hexFFFFF4CC : AppColors.hexFFF1F3F5,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFeatured ? Icons.star : Icons.storefront_outlined,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isFeatured
                ? l10n.merchantFeaturedBadge
                : l10n.merchantStandardBadge,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(MerchantEntity merchant, bool isSuspended,
      bool hasFinancialAlert, bool hasSupervisoryNote, AppLocalizations l10n) {
    Color bg;
    Color border;
    Color text;
    String label;

    if (isSuspended) {
      bg = AppColors.hexFFFEF2F2;
      border = AppColors.hexFFFECACA;
      text = AppColors.hexFFDC2626;
      label = l10n.temporarySuspendedMetric;
    } else if (hasFinancialAlert) {
      bg = AppColors.hexFFFFFBEB;
      border = AppColors.hexFFFDE68A;
      text = AppColors.hexFFD97706;
      label = 'تنبيه مالي';
    } else if (hasSupervisoryNote) {
      bg = AppColors.hexFFEFF6FF;
      border = AppColors.hexFFBFDBFE;
      text = AppColors.hexFF2563EB;
      label = 'ملاحظة إشرافية';
    } else {
      bg = AppColors.hexFFECFDF5;
      border = AppColors.hexFFA7F3D0;
      text = AppColors.hexFF059669;
      label = l10n.activeAndVerifiedMetric;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: text,
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: _surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _outline),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.hexFF64748B,
              fontSize: 10.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _outline),
          ),
          child: Icon(
            icon,
            color: _onSurface,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildRemainingStoresCard(
    BuildContext context, {
    required int remainingCount,
    required AppLocalizations l10n,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outline),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 76,
                height: 36,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.hexFF0F172A,
                        child: Text(
                          '+$remainingCount',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 20,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.hexFF0284C7,
                        child: Icon(Icons.store, size: 16, color: AppColors.white),
                      ),
                    ),
                    const Positioned(
                      left: 40,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primaryDark,
                        child:
                            Icon(Icons.verified, size: 16, color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.remainingMerchantsTitle,
                      style: TextStyle(
                        color: _primaryText,
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.remainingMerchantsSubtitle,
                      style: TextStyle(
                        color: _onSurfaceVariant,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onToggle,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.hexFFCBD5E1),
              padding: const EdgeInsets.symmetric(vertical: 10),
              minimumSize: const Size.fromHeight(42),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    l10n.loadAndShowRemainingList,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldGovernanceCard(
      BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shield,
              color: AppColors.hexFF38BDF8,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.fieldGovernanceCardTitle,
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.fieldGovernanceCardBody,
                  style: TextStyle(
                    color: _onSurfaceVariant,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomButton(BuildContext context, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _showAddMerchantSheet(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 20, color: AppColors.white),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.addNewMerchantToSupervision,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
