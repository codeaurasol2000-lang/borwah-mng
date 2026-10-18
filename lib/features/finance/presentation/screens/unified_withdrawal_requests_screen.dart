import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/finance_dialogs.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../merchants/data/merchant_advertisement_local_store.dart';
import '../../../merchants/domain/entities/merchant_entity.dart';
import '../../../wasalny_supervisor/data/wasalny_local_event_store.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../utils/finance_localizer.dart';
import '../widgets/finance_navigation.dart';
import '../widgets/withdrawal_request_details_sheet.dart';

class UnifiedWithdrawalRequestsScreen extends StatefulWidget {
  const UnifiedWithdrawalRequestsScreen({super.key});

  @override
  State<UnifiedWithdrawalRequestsScreen> createState() =>
      _UnifiedWithdrawalRequestsScreenState();
}

enum _RequestSource { merchant, supervisor }

enum _BeneficiaryFilter { all, merchant, user, supervisor, serviceProvider }

class _WithdrawalEntry {
  final WithdrawalRequestEntity request;
  final _RequestSource source;

  const _WithdrawalEntry({required this.request, required this.source});

  String get key => '${source.name}:${request.id}';
}

class _UnifiedWithdrawalRequestsScreenState
    extends State<UnifiedWithdrawalRequestsScreen> {
  List<_WithdrawalEntry> _requests = [];
  final Set<String> _processingRequests = {};
  bool _isLoading = true;
  bool _showArchive = false;
  String? _loadError;
  _BeneficiaryFilter _beneficiaryFilter = _BeneficiaryFilter.all;
  FinancialOperationType? _operationFilter;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final results = await Future.wait([
        sl<FinanceRepository>().getMerchantWithdrawals(),
        sl<FinanceRepository>().getSupervisorWithdrawals(),
      ]);
      String? failureMessage;
      final merchantRequests = results[0].fold<List<WithdrawalRequestEntity>?>(
        (failure) {
          failureMessage ??= failure.message;
          return null;
        },
        (requests) => requests,
      );
      final supervisorRequests =
          results[1].fold<List<WithdrawalRequestEntity>?>(
        (failure) {
          failureMessage ??= failure.message;
          return null;
        },
        (requests) => requests,
      );

      if (!mounted) return;
      if (merchantRequests == null || supervisorRequests == null) {
        setState(() {
          _loadError = failureMessage ??
              AppLocalizations.of(context)!.merchantAuditLoadError;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _requests = [
          ...merchantRequests.map(
            (request) => _WithdrawalEntry(
              request: request,
              source: _RequestSource.merchant,
            ),
          ),
          ...supervisorRequests.map(
            (request) => _WithdrawalEntry(
              request: request,
              source: _RequestSource.supervisor,
            ),
          ),
        ];
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'unified finance withdrawal requests',
        ),
      );
      if (!mounted) return;
      setState(() {
        _loadError = AppLocalizations.of(context)!.merchantAuditLoadError;
        _isLoading = false;
      });
    }
  }

  bool _isArchivedStatus(RequestStatus status) =>
      status == RequestStatus.approved || status == RequestStatus.rejected;

  bool _matchesQueue(_WithdrawalEntry entry, {bool? archive}) =>
      _isArchivedStatus(entry.request.status) == (archive ?? _showArchive);

  bool _matchesBeneficiary(_WithdrawalEntry entry,
      [_BeneficiaryFilter? filter]) {
    final selected = filter ?? _beneficiaryFilter;
    return switch (selected) {
      _BeneficiaryFilter.all => true,
      _BeneficiaryFilter.merchant =>
        entry.request.beneficiaryType == BeneficiaryType.merchant,
      _BeneficiaryFilter.user =>
        entry.request.beneficiaryType == BeneficiaryType.user,
      _BeneficiaryFilter.supervisor =>
        entry.request.beneficiaryType == BeneficiaryType.supervisor,
      _BeneficiaryFilter.serviceProvider =>
        entry.request.beneficiaryType == BeneficiaryType.serviceProvider,
    };
  }

  bool _matchesOperation(_WithdrawalEntry entry,
      [FinancialOperationType? filter]) {
    final selected = filter ?? _operationFilter;
    return selected == null || entry.request.operationType == selected;
  }

  List<_WithdrawalEntry> get _visibleRequests => _requests
      .where(_matchesQueue)
      .where(_matchesBeneficiary)
      .where(_matchesOperation)
      .toList(growable: false);

  int _queueCount(bool archive) => _requests
      .where((entry) =>
          _matchesQueue(entry, archive: archive) &&
          _matchesBeneficiary(entry) &&
          _matchesOperation(entry))
      .length;

  int _beneficiaryCount(_BeneficiaryFilter filter) => _requests
      .where((entry) =>
          _matchesQueue(entry) &&
          _matchesBeneficiary(entry, filter) &&
          _matchesOperation(entry))
      .length;

  int _operationCount(FinancialOperationType? filter) => _requests
      .where((entry) =>
          _matchesQueue(entry) &&
          _matchesBeneficiary(entry) &&
          (filter == null || entry.request.operationType == filter))
      .length;

  String _beneficiaryLabel(
    AppLocalizations l10n,
    _BeneficiaryFilter filter,
  ) =>
      switch (filter) {
        _BeneficiaryFilter.all => l10n.allTab,
        _BeneficiaryFilter.merchant => l10n.navMerchants,
        _BeneficiaryFilter.user => l10n.usersTab,
        _BeneficiaryFilter.supervisor => l10n.platformSupervisorsTab,
        _BeneficiaryFilter.serviceProvider => l10n.serviceProviders,
      };

  String _operationLabel(
    AppLocalizations l10n,
    FinancialOperationType? type,
  ) =>
      switch (type) {
        null => l10n.allTab,
        FinancialOperationType.withdrawal => l10n.financeWalletWithdrawal,
        FinancialOperationType.deposit => l10n.financeWalletDeposit,
        FinancialOperationType.promotion =>
          l10n.wasalnyPromotionFinanceRequestType,
      };

  String _statusLabel(AppLocalizations l10n, RequestStatus status) =>
      switch (status) {
        RequestStatus.pending => l10n.withdrawalDetailsStatusPending,
        RequestStatus.underInvestigation =>
          l10n.withdrawalDetailsStatusInvestigation,
        RequestStatus.approved => l10n.withdrawalDetailsStatusApproved,
        RequestStatus.frozen => l10n.withdrawalDetailsStatusFrozen,
        RequestStatus.rejected => l10n.withdrawalDetailsStatusRejected,
      };

  Color _statusColor(RequestStatus status) => switch (status) {
        RequestStatus.pending => AppColors.info,
        RequestStatus.underInvestigation ||
        RequestStatus.frozen =>
          AppColors.warningDark,
        RequestStatus.approved => AppColors.successDark,
        RequestStatus.rejected => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: l10n.localeName.startsWith('ar')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: FinancePageAppBar(
          title: l10n.navWithdrawalOrders,
          subtitle: l10n.financialManagementSubtitle,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryDark),
              )
            : _loadError != null
                ? _buildLoadError(l10n)
                : RefreshIndicator(
                    onRefresh: _loadRequests,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildChoiceChip(
                              label: l10n.financeRequestsInProgressTab,
                              count: _queueCount(false),
                              selected: !_showArchive,
                              onSelected: () =>
                                  setState(() => _showArchive = false),
                            ),
                            _buildChoiceChip(
                              label: l10n.financeRequestsArchiveTab,
                              count: _queueCount(true),
                              selected: _showArchive,
                              onSelected: () =>
                                  setState(() => _showArchive = true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.withdrawalDetailsBeneficiary,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _BeneficiaryFilter.values
                              .map(
                                (filter) => _buildChoiceChip(
                                  label: _beneficiaryLabel(l10n, filter),
                                  count: _beneficiaryCount(filter),
                                  selected: _beneficiaryFilter == filter,
                                  onSelected: () => setState(
                                    () => _beneficiaryFilter = filter,
                                  ),
                                ),
                              )
                              .toList(growable: false),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.financeOperationType,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            null,
                            ...FinancialOperationType.values,
                          ].map((type) {
                            return _buildChoiceChip(
                              label: _operationLabel(l10n, type),
                              count: _operationCount(type),
                              selected: _operationFilter == type,
                              onSelected: () => setState(
                                () => _operationFilter = type,
                              ),
                            );
                          }).toList(growable: false),
                        ),
                        const SizedBox(height: 16),
                        if (_visibleRequests.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Text(
                              _showArchive
                                  ? l10n.financeRequestsArchiveEmpty
                                  : l10n.financeRequestsInProgressEmpty,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        else
                          ..._visibleRequests.map(
                            (entry) => _buildRequestCard(entry, l10n),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildLoadError(AppLocalizations l10n) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined,
                  size: 36, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text(
                _loadError ?? l10n.merchantAuditLoadError,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _loadRequests,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.merchantProfileRetry),
              ),
            ],
          ),
        ),
      );

  Widget _buildChoiceChip({
    required String label,
    required int count,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      showCheckmark: false,
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primaryDark,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.textSecondary,
        fontSize: 12,
        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            constraints: const BoxConstraints(minWidth: 20),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white.withValues(alpha: 0.16)
                  : AppColors.surfaceHighlight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    _WithdrawalEntry entry,
    AppLocalizations l10n,
  ) {
    final request = entry.request;
    final statusColor = _statusColor(request.status);
    final canDecide = request.status == RequestStatus.pending;
    final isProcessing = _processingRequests.contains(entry.key);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FinanceLocalizer.localizeWithdrawalText(
                        context,
                        request.beneficiaryName,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${_beneficiaryLabel(l10n, _filterFor(request.beneficiaryType))} · ${FinanceLocalizer.localizeWithdrawalText(context, request.beneficiaryRole)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(maxWidth: 118),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _statusLabel(l10n, request.status),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  request.requestNumber,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                CurrencyFormatter.format(request.netAmount),
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_operationLabel(l10n, request.operationType)}${request.dateText.isEmpty ? '' : ' · ${request.dateText}'}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () =>
                showWithdrawalRequestDetailsSheet(context, request),
            icon: const Icon(Icons.receipt_long_outlined, size: 17),
            label: Text(l10n.withdrawalRequestDetails),
          ),
          if (canDecide) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isProcessing
                    ? null
                    : () => _saveDecision(
                          entry,
                          RequestStatus.approved,
                          l10n,
                        ),
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: Text(l10n.financeRequestApprovalTitle),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isProcessing
                        ? null
                        : () => _saveDecision(
                              entry,
                              RequestStatus.rejected,
                              l10n,
                            ),
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: Text(l10n.financeRequestRejectedBadge),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isProcessing
                        ? null
                        : () => _saveDecision(
                              entry,
                              RequestStatus.frozen,
                              l10n,
                            ),
                    icon: const Icon(Icons.pause_circle_outline, size: 16),
                    label: Text(l10n.freezeRequestTemporarily),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.warningDark,
                      side: const BorderSide(color: AppColors.warning),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  _BeneficiaryFilter _filterFor(BeneficiaryType type) => switch (type) {
        BeneficiaryType.merchant => _BeneficiaryFilter.merchant,
        BeneficiaryType.user => _BeneficiaryFilter.user,
        BeneficiaryType.supervisor => _BeneficiaryFilter.supervisor,
        BeneficiaryType.serviceProvider => _BeneficiaryFilter.serviceProvider,
      };

  Future<void> _saveDecision(
    _WithdrawalEntry entry,
    RequestStatus decision,
    AppLocalizations l10n,
  ) async {
    final request = entry.request;
    String? reason;
    if (decision == RequestStatus.approved) {
      final operation = _operationLabel(l10n, request.operationType);
      final confirmed = await FinanceDialogs.showApprovalDialog(
        context,
        title: l10n.financeRequestApprovalTitle,
        description: l10n.financeRequestApprovalConfirmation(
          operation,
          FinanceLocalizer.localizeWithdrawalText(
            context,
            request.beneficiaryName,
          ),
          CurrencyFormatter.format(request.netAmount),
        ),
      );
      if (!confirmed || !mounted) return;
    } else if (decision == RequestStatus.rejected) {
      reason = await FinanceDialogs.showRejectionDialog(
        context,
        title: l10n.financeWalletWithdrawal,
      );
      if (reason == null || !mounted) return;
    } else {
      final confirmed = await FinanceDialogs.showFreezeDialog(
        context,
        requestTitle: FinanceLocalizer.localizeWithdrawalText(
          context,
          request.beneficiaryName,
        ),
      );
      if (!confirmed || !mounted) return;
      reason = l10n.temporarilySuspendedForAudit;
    }

    setState(() => _processingRequests.add(entry.key));
    try {
      final result = await _persistDecision(entry, decision, reason);
      if (!mounted) return;
      final failure = result.fold<Failure?>((value) => value, (_) => null);
      if (failure != null) {
        AppSnackBar.showError(context, failure.message);
        return;
      }

      if (entry.source == _RequestSource.supervisor) {
        await _publishDecision(entry, decision, reason);
      } else if (request.operationType == FinancialOperationType.promotion &&
          (decision == RequestStatus.approved ||
              decision == RequestStatus.rejected)) {
        await _syncPromotionDecision(entry, decision, reason);
      }
      if (!mounted) return;

      setState(() {
        _requests = _requests
            .map((value) => value.key == entry.key
                ? _WithdrawalEntry(
                    request: value.request.copyWith(
                      status: decision,
                      alertNotice: reason,
                    ),
                    source: value.source,
                  )
                : value)
            .toList(growable: false);
        _processingRequests.remove(entry.key);
      });
      final message = switch (decision) {
        RequestStatus.approved => l10n.financeRequestApproved,
        RequestStatus.rejected => l10n.financeRequestRejected,
        RequestStatus.frozen => l10n.financeRequestFrozen,
        _ => l10n.financeRequestDecisionFailed,
      };
      AppSnackBar.showSuccess(context, message);
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'unified finance withdrawal decision',
        ),
      );
      if (mounted) {
        AppSnackBar.showError(context, l10n.financeRequestDecisionFailed);
      }
    } finally {
      if (mounted && _processingRequests.contains(entry.key)) {
        setState(() => _processingRequests.remove(entry.key));
      }
    }
  }

  Future<dartz.Either<Failure, void>> _persistDecision(
    _WithdrawalEntry entry,
    RequestStatus decision,
    String? reason,
  ) {
    final repository = sl<FinanceRepository>();
    if (entry.source == _RequestSource.merchant) {
      return switch (decision) {
        RequestStatus.approved =>
          repository.approveMerchantFinancialRequest(entry.request.id),
        RequestStatus.rejected => repository.rejectMerchantFinancialRequest(
            entry.request.id,
            reason ?? '',
          ),
        RequestStatus.frozen => repository.freezeMerchantFinancialRequest(
            entry.request.id,
            reason ?? '',
          ),
        _ => Future.error(StateError('Unsupported withdrawal decision.')),
      };
    }
    return switch (decision) {
      RequestStatus.approved => repository.approveWithdrawal(entry.request.id),
      RequestStatus.rejected => repository.rejectWithdrawal(
          entry.request.id,
          reason ?? '',
        ),
      RequestStatus.frozen => repository.freezeWithdrawal(
          entry.request.id,
          reason ?? '',
        ),
      _ => Future.error(StateError('Unsupported withdrawal decision.')),
    };
  }

  Future<void> _publishDecision(
    _WithdrawalEntry entry,
    RequestStatus decision,
    String? reason,
  ) async {
    final request = entry.request;
    final source = switch (request.sourceAccount) {
      'product' => 'products',
      'merchant' ||
      'products' ||
      'services' ||
      'wasalny' =>
        request.sourceAccount!,
      _ => null,
    };
    if (source == null) return;

    final approved = decision == RequestStatus.approved;
    final rejected = decision == RequestStatus.rejected;
    final titleAr = approved
        ? 'تمت الموافقة على طلبك المالي'
        : rejected
            ? 'تم رفض طلبك المالي'
            : 'تم تعليق طلبك المالي للمراجعة';
    final titleEn = approved
        ? 'Your financial request was approved'
        : rejected
            ? 'Your financial request was rejected'
            : 'Your financial request was placed under review';
    final messageAr = approved
        ? 'تم اعتماد الطلب ${request.requestNumber}. يتطلب تنفيذ التحويل أو إضافة الرصيد تكامل خدمة الدفع.'
        : rejected
            ? 'تم رفض الطلب ${request.requestNumber}. السبب: ${reason ?? ''}'
            : 'تم تعليق الطلب ${request.requestNumber} للمراجعة الإضافية.';
    final messageEn = approved
        ? 'Request ${request.requestNumber} was approved. Transfer execution or balance posting still requires payment-service integration.'
        : rejected
            ? 'Request ${request.requestNumber} was rejected. Reason: ${reason ?? ''}'
            : 'Request ${request.requestNumber} was placed under additional review.';

    try {
      await WasalnyLocalEventStore().publish(
        WasalnyLocalEvent(
          id: 'finance-${decision.name}-${request.id}',
          recipient: source,
          source: 'finance',
          titleAr: titleAr,
          titleEn: titleEn,
          messageAr: messageAr,
          messageEn: messageEn,
          createdAt: DateTime.now(),
        ),
      );
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'unified finance withdrawal notification',
        ),
      );
    }
  }

  Future<void> _syncPromotionDecision(
    _WithdrawalEntry entry,
    RequestStatus decision,
    String? reason,
  ) async {
    final request = entry.request;
    final approved = decision == RequestStatus.approved;
    const prefix = 'AD-FEE-';
    final sourceAccount = request.sourceAccount;
    final reference = sourceAccount != null && sourceAccount.startsWith(prefix)
        ? sourceAccount.substring(prefix.length)
        : RegExp(r'(?:AD-FEE-)?(AD-\d+)')
            .firstMatch(request.sourceOfFunds ?? '')
            ?.group(1);

    if (reference != null) {
      try {
        await MerchantAdvertisementLocalStore.saveStatus(
          reference: reference,
          status: approved
              ? MerchantAdvertisementStatus.awaitingManagement
              : MerchantAdvertisementStatus.rejected,
        );
      } catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'unified promotion finance decision',
          ),
        );
      }
    }

    final recipient = request.sourceOfFunds?.contains('وصلني') == true ||
            sourceAccount?.startsWith('wasalny-') == true
        ? 'wasalny'
        : 'products';
    try {
      await WasalnyLocalEventStore().publish(
        WasalnyLocalEvent(
          id: 'finance-${approved ? 'approved' : 'rejected'}-${request.id}',
          recipient: recipient,
          source: 'finance',
          titleAr: approved ? 'تم اعتماد طلب الترويج' : 'تم رفض طلب الترويج',
          titleEn: approved
              ? 'Promotion request approved'
              : 'Promotion request rejected',
          messageAr: approved
              ? 'اعتمد المشرف المالي طلب الترويج ${request.beneficiaryName} وأحاله للإدارة للخصم.'
              : 'رفض المشرف المالي طلب الترويج ${request.beneficiaryName}: ${reason ?? ''}',
          messageEn: approved
              ? 'Finance approved ${request.beneficiaryName}\'s promotion and forwarded it to management for deduction.'
              : 'Finance rejected ${request.beneficiaryName}\'s promotion: ${reason ?? ''}',
          createdAt: DateTime.now(),
        ),
      );
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'unified promotion finance notification',
        ),
      );
    }
  }
}
