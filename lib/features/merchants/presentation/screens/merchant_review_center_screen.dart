import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../features/finance/domain/entities/withdrawal_request_entity.dart';
import '../../../../features/finance/domain/repositories/finance_repository.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/merchant_advertisement_local_store.dart';
import '../../data/merchant_supervisor_local_store.dart';
import '../../domain/entities/merchant_entity.dart';
import 'merchant_details_screen.dart';

class MerchantReviewCenterScreen extends StatefulWidget {
  final ValueChanged<int> onOpenQueue;
  final int merchantAttentionCount;
  final List<MerchantEntity> merchants;

  const MerchantReviewCenterScreen({
    super.key,
    required this.onOpenQueue,
    this.merchantAttentionCount = 0,
    this.merchants = const [],
  });

  @override
  State<MerchantReviewCenterScreen> createState() =>
      _MerchantReviewCenterScreenState();
}

class _MerchantReviewCenterScreenState extends State<MerchantReviewCenterScreen> {
  static const _upgradeActionsKey = 'merchant_upgrade_review_actions_v1';
  static const _upgradeReferences = ['MUP-2042', 'MUP-2038', 'MUP-2029'];
  int _pendingAds = 0;
  int _pendingUpgrades = 0;
  int _pendingFinancial = 0;
  List<MerchantSupervisorAuditEvent> _events = const [];
  bool _loading = true;
  bool _showArchive = false;
  Object? _error;
  String _typeFilter = 'all';
  String _stateFilter = 'pending';
  Map<String, MerchantAdvertisementStatus> _adStatuses = const {};
  Set<String> _completedUpgrades = const {};
  Set<String> _rejectedUpgrades = const {};
  bool _highestPriorityFirst = true;

  @override
  void initState() {
    super.initState();
    MerchantSupervisorLocalStore.revision.addListener(_loadCenterData);
    MerchantAdvertisementLocalStore.version.addListener(_loadCenterData);
    _loadCenterData();
  }

  @override
  void dispose() {
    MerchantSupervisorLocalStore.revision.removeListener(_loadCenterData);
    MerchantAdvertisementLocalStore.version.removeListener(_loadCenterData);
    super.dispose();
  }

  Future<void> _loadCenterData() async {
    try {
      final statuses = await MerchantAdvertisementLocalStore.loadStatuses();
      final events = await MerchantSupervisorLocalStore.getAuditEvents();
      final preferences = await SharedPreferences.getInstance();
      final financeResult = await sl<FinanceRepository>().getMerchantWithdrawals();

      final ads = MerchantAdvertisementLocalStore.trackedReferences;
      final closedAdStatuses = {
        MerchantAdvertisementStatus.approved,
        MerchantAdvertisementStatus.rejected,
        MerchantAdvertisementStatus.frozen,
        MerchantAdvertisementStatus.hidden,
      };
      final pendingAds = ads
          .where((id) => !closedAdStatuses.contains(statuses[id]))
          .length;

      var pendingUpgrades = _upgradeReferences.length;
      var completedUpgrades = <String>{};
      var rejectedUpgrades = <String>{};
      final encoded = preferences.getString(_upgradeActionsKey);
      if (encoded != null) {
        final decoded = jsonDecode(encoded);
        if (decoded is! Map<String, dynamic> ||
            decoded['sent'] is! List ||
            decoded['rejections'] is! Map<String, dynamic>) {
          throw const FormatException('Merchant upgrade actions are invalid.');
        }
        final completed = <String>{
          ...(decoded['sent'] as List).whereType<String>(),
          ...(decoded['rejections'] as Map<String, dynamic>).keys,
        };
        completedUpgrades = (decoded['sent'] as List).whereType<String>().toSet();
        rejectedUpgrades =
            (decoded['rejections'] as Map<String, dynamic>).keys.toSet();
        pendingUpgrades = (_upgradeReferences.length - completed.length)
            .clamp(0, _upgradeReferences.length)
            .toInt();
      }

      final requests = financeResult.fold(
        (failure) => throw StateError(failure.message),
        (values) => values,
      );
      final pendingFinancial = requests
          .where((request) => request.status == RequestStatus.pending)
          .length;
      if (!mounted) return;
      setState(() {
        _pendingAds = pendingAds;
        _pendingUpgrades = pendingUpgrades;
        _pendingFinancial = pendingFinancial;
        _events = events;
        _adStatuses = statuses;
        _completedUpgrades = completedUpgrades;
        _rejectedUpgrades = rejectedUpgrades;
        _loading = false;
        _error = null;
      });
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'merchant review center',
      ));
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error;
      });
    }
  }

  List<_UnifiedRequest> _buildRequests(
    AppLocalizations l10n,
    bool isArabic,
  ) {
    final requests = <_UnifiedRequest>[];
    for (final merchant in widget.merchants) {
      if (merchant.status != MerchantStatus.underAudit &&
          merchant.status != MerchantStatus.updateRequired) {
        continue;
      }
      requests.add(_UnifiedRequest(
        kind: _QueueKind.merchant,
        reference: merchant.code ?? merchant.id,
        title: isArabic ? merchant.name : merchant.nameEn,
        description: isArabic
            ? merchant.status == MerchantStatus.underAudit
                ? 'طلب تاجر قيد التدقيق'
                : 'يلزم تحديث بيانات المتجر'
            : merchant.status == MerchantStatus.underAudit
                ? 'Merchant application under review'
                : 'Store information update required',
        status: merchant.status == MerchantStatus.underAudit
            ? (isArabic ? 'قيد التدقيق' : 'Under review')
            : (isArabic ? 'تحديث مطلوب' : 'Update required'),
        pending: true,
        priority: merchant.status == MerchantStatus.updateRequired ? 3 : 2,
        merchant: merchant,
      ));
    }

    final adData = [
      ('AD-94820', l10n.adsCarMerchant, l10n.adsCarTitle),
      ('AD-66214', l10n.adsPhoneMerchant, l10n.adsPhoneTitle),
      ('AD-78011', l10n.adsVillaMerchant, l10n.adsVillaTitle),
    ];
    for (final (reference, merchant, title) in adData) {
      final status = _adStatuses[reference] ??
          MerchantAdvertisementStatus.underReview;
      final pending = status == MerchantAdvertisementStatus.underReview ||
          status == MerchantAdvertisementStatus.awaitingFinance ||
          status == MerchantAdvertisementStatus.awaitingManagement;
      requests.add(_UnifiedRequest(
        kind: _QueueKind.ad,
        reference: reference,
        title: title,
        description: merchant,
        status: _adStatusLabel(status, isArabic),
        pending: pending,
        priority: status == MerchantAdvertisementStatus.underReview ? 3 : 1,
      ));
    }

    final upgradeData = [
      (_upgradeReferences[0], l10n.finRequestCarMerchant, l10n.finRequestTodayTime),
      (_upgradeReferences[1], l10n.finRequestPackageMerchant, l10n.finRequestYesterdayTime),
      (_upgradeReferences[2], l10n.finRequestJewelryMerchant, l10n.finRequestOlderTime),
    ];
    for (final (reference, merchant, submittedAt) in upgradeData) {
      final rejected = _rejectedUpgrades.contains(reference);
      final sent = _completedUpgrades.contains(reference);
      requests.add(_UnifiedRequest(
        kind: _QueueKind.upgrade,
        reference: reference,
        title: merchant,
        description: '${l10n.merchantStandardBadge} → '
            '${l10n.merchantFeaturedBadge} · $submittedAt',
        status: rejected
            ? l10n.finRequestRejected
            : sent
                ? l10n.finRequestSentConfirmation
                : l10n.finRequestUnderReview,
        pending: !rejected && !sent,
        priority: !rejected && !sent ? 2 : 0,
      ));
    }
    return requests;
  }

  String _adStatusLabel(MerchantAdvertisementStatus status, bool isArabic) =>
      switch (status) {
        MerchantAdvertisementStatus.underReview =>
          isArabic ? 'قيد المراجعة' : 'Under review',
        MerchantAdvertisementStatus.awaitingFinance =>
          isArabic ? 'بانتظار المشرف المالي' : 'Awaiting Finance',
        MerchantAdvertisementStatus.awaitingManagement =>
          isArabic ? 'بانتظار الإدارة' : 'Awaiting management',
        MerchantAdvertisementStatus.approved =>
          isArabic ? 'مقبول' : 'Approved',
        MerchantAdvertisementStatus.rejected =>
          isArabic ? 'مرفوض' : 'Rejected',
        MerchantAdvertisementStatus.frozen =>
          isArabic ? 'مجمد' : 'Frozen',
        MerchantAdvertisementStatus.hidden =>
          isArabic ? 'مخفي' : 'Hidden',
      };

  Widget _filterChip(
    String value,
    String label,
    String selected,
    ValueChanged<String> onSelected,
  ) => FilterChip(
        label: Text(label),
        selected: selected == value,
        onSelected: (_) => onSelected(value),
        selectedColor: AppColors.primaryDark.withValues(alpha: .12),
        checkmarkColor: AppColors.primaryDark,
      );

  Widget _requestCard(
    BuildContext context,
    _UnifiedRequest request,
    bool isArabic,
  ) {
    final kindLabel = switch (request.kind) {
      _QueueKind.merchant => isArabic ? 'تاجر' : 'Merchant',
      _QueueKind.ad => isArabic ? 'إعلان' : 'Advertisement',
      _QueueKind.upgrade => isArabic ? 'ترقية' : 'Upgrade',
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(
            request.kind == _QueueKind.merchant
                ? Icons.storefront_outlined
                : request.kind == _QueueKind.ad
                    ? Icons.campaign_outlined
                    : Icons.upgrade_outlined,
            color: request.pending ? AppColors.primaryDark : AppColors.textMuted,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.title,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 3),
                Text('$kindLabel · ${request.reference} · ${request.description}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    )),
                const SizedBox(height: 5),
                Text(request.status,
                    style: TextStyle(
                      color: request.pending
                          ? AppColors.info
                          : AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          IconButton(
            tooltip: isArabic ? 'فتح الطلب' : 'Open request',
            onPressed: () {
              if (request.merchant != null) {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => MerchantDetailsScreen(
                    merchant: request.merchant!,
                  ),
                ));
              } else {
                widget.onOpenQueue(
                  request.kind == _QueueKind.ad
                      ? 1
                      : request.kind == _QueueKind.upgrade
                          ? 3
                          : 0,
                );
              }
            },
            icon: const Icon(Icons.open_in_new, size: 19),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final queues = [
      _ReviewQueue(
        icon: Icons.storefront_outlined,
        title: isArabic ? 'متابعة التجار' : 'Merchant follow-up',
        subtitle: isArabic
            ? 'المتاجر التي تحتاج إلى متابعة أو تحديث بيانات.'
            : 'Stores that need attention or profile updates.',
        count: widget.merchantAttentionCount,
        index: 0,
        color:  AppColors.hexFF287A68,
      ),
      _ReviewQueue(
        icon: Icons.fact_check_outlined,
        title: isArabic ? 'مراجعة الإعلانات' : 'Ad reviews',
        subtitle: isArabic
            ? 'طلبات الإعلانات التي تنتظر قرار المراجعة.'
            : 'Advertisement requests waiting for review.',
        count: _pendingAds,
        index: 1,
        color:  AppColors.hexFF4469A8,
      ),
      _ReviewQueue(
        icon: Icons.upgrade_outlined,
        title: isArabic ? 'ترقيات المتاجر' : 'Store upgrades',
        subtitle: isArabic
            ? 'طلبات الترقية التي تنتظر قرار مشرف التجار.'
            : 'Upgrade requests awaiting the merchant supervisor.',
        count: _pendingUpgrades,
        index: 3,
        color:  AppColors.hexFF916B2C,
      ),
      _ReviewQueue(
        icon: Icons.account_balance_wallet_outlined,
        title: isArabic ? 'الطلبات المالية' : 'Financial requests',
        subtitle: isArabic
            ? 'طلبات التجار التي تنتظر مراجعة المشرف المالي.'
            : 'Merchant requests waiting for the Finance supervisor.',
        count: _pendingFinancial,
        index: 2,
        color:  AppColors.hexFF7856A5,
      ),
    ];
    final requests = _buildRequests(l10n, isArabic)
        .where((request) =>
            _typeFilter == 'all' || request.kind.name == _typeFilter)
        .where((request) =>
            _stateFilter == 'all' || request.pending)
        .toList()
      ..sort((first, second) => _highestPriorityFirst
          ? second.priority.compareTo(first.priority)
          : first.priority.compareTo(second.priority));

    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isArabic ? 'مركز متابعة التجار' : 'Merchant review center'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadCenterData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [AppColors.hexFF102C49, AppColors.hexFF1E5272],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.rule_folder_outlined,
                      color: AppColors.white, size: 32),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'ملخص المراجعات' : 'Review overview',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          isArabic
                              ? 'الأعداد تتحدث عند تسجيل قرار أو وصول تحديث.'
                              : 'Counts refresh when a decision or update is recorded.',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: .82),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_loading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  isArabic
                      ? 'تعذر تحديث بعض الأعداد. اسحب للتحديث.'
                      : 'Some counts could not be refreshed. Pull to retry.',
                  style: const TextStyle(color: AppColors.danger),
                ),
              ),
            const SizedBox(height: 18),
            ...queues.map((queue) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => widget.onOpenQueue(queue.index),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: queue.color.withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(queue.icon, color: queue.color),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(queue.title,
                                      style: const TextStyle(
                                        color: AppColors.primaryDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                  const SizedBox(height: 4),
                                  Text(queue.subtitle,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                        height: 1.4,
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 30),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 5),
                              decoration: BoxDecoration(
                                color: queue.count > 0
                                    ? queue.color.withValues(alpha: .12)
                                    :  AppColors.textPrimary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${queue.count}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: queue.count > 0
                                      ? queue.color
                                      : AppColors.textMuted,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Icon(
                              isArabic
                                  ? Icons.chevron_left
                                  : Icons.chevron_right,
                              color: AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isArabic ? 'قائمة المراجعة الموحدة' : 'Unified review queue',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: isArabic ? 'ترتيب الأولوية' : 'Priority order',
                  icon: const Icon(Icons.priority_high,
                      color: AppColors.primaryDark),
                  onSelected: (_) => setState(
                    () => _highestPriorityFirst = !_highestPriorityFirst,
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'priority',
                      child: Text(isArabic
                          ? _highestPriorityFirst
                              ? 'الأولوية الأقل أولاً'
                              : 'الأولوية الأعلى أولاً'
                          : _highestPriorityFirst
                              ? 'Lowest priority first'
                              : 'Highest priority first'),
                    ),
                  ],
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: [
                _filterChip('all', isArabic ? 'الكل' : 'All', _typeFilter,
                    (value) => setState(() => _typeFilter = value)),
                _filterChip('merchant', isArabic ? 'التجار' : 'Merchants',
                    _typeFilter, (value) => setState(() => _typeFilter = value)),
                _filterChip('ad', isArabic ? 'الإعلانات' : 'Ads', _typeFilter,
                    (value) => setState(() => _typeFilter = value)),
                _filterChip('upgrade', isArabic ? 'الترقيات' : 'Upgrades',
                    _typeFilter, (value) => setState(() => _typeFilter = value)),
              ],
            ),
            Wrap(
              spacing: 8,
              children: [
                _filterChip('pending', isArabic ? 'قيد المتابعة' : 'Pending',
                    _stateFilter, (value) => setState(() => _stateFilter = value)),
                _filterChip('all', isArabic ? 'كل الحالات' : 'All states',
                    _stateFilter, (value) => setState(() => _stateFilter = value)),
              ],
            ),
            const SizedBox(height: 8),
            if (requests.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(isArabic
                      ? 'لا توجد طلبات مطابقة لهذه الفلاتر.'
                      : 'No requests match these filters.'),
                ),
              )
            else
              ...requests.map((request) => _requestCard(
                    context,
                    request,
                    isArabic,
                  )),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isArabic ? 'سجل القرارات' : 'Decision archive',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _showArchive = !_showArchive),
                  icon: Icon(_showArchive
                      ? Icons.expand_less
                      : Icons.unarchive_outlined),
                  label: Text(_showArchive
                      ? (isArabic ? 'إخفاء' : 'Hide')
                      : (isArabic ? 'عرض الكل' : 'View all')),
                ),
              ],
            ),
            if (_showArchive)
              if (_events.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(isArabic
                        ? 'لا توجد إجراءات مسجلة بعد.'
                        : 'No recorded actions yet.'),
                  ),
                )
              else
                ..._events.map((event) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.history,
                              color: AppColors.primaryDark, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.action,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryDark,
                                    )),
                                const SizedBox(height: 4),
                                Text('${event.subject} · ${event.details}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    )),
                                const SizedBox(height: 4),
                                Text(
                                  MaterialLocalizations.of(context)
                                      .formatMediumDate(event.occurredAt),
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}

enum _QueueKind { merchant, ad, upgrade }

class _UnifiedRequest {
  final _QueueKind kind;
  final String reference;
  final String title;
  final String description;
  final String status;
  final bool pending;
  final int priority;
  final MerchantEntity? merchant;

  const _UnifiedRequest({
    required this.kind,
    required this.reference,
    required this.title,
    required this.description,
    required this.status,
    required this.pending,
    required this.priority,
    this.merchant,
  });
}

class _ReviewQueue {
  final IconData icon;
  final String title;
  final String subtitle;
  final int count;
  final int index;
  final Color color;

  const _ReviewQueue({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.index,
    required this.color,
  });
}
