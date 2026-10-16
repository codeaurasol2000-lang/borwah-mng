import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/finance_dialogs.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../wasalny_supervisor/data/wasalny_local_event_store.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../widgets/finance_navigation.dart';
import '../widgets/withdrawal_request_details_sheet.dart';

enum _QueueStatus { pending, archive }

class FinanceRequestsCenterScreen extends StatefulWidget {
  const FinanceRequestsCenterScreen({super.key});

  @override
  State<FinanceRequestsCenterScreen> createState() =>
      _FinanceRequestsCenterScreenState();
}

class _FinanceRequestsCenterScreenState
    extends State<FinanceRequestsCenterScreen> {
  List<WithdrawalRequestEntity> _requests = const [];
  bool _isLoading = true;
  String? _loadError;
  String? _processingId;
  _QueueStatus _queueStatus = _QueueStatus.pending;
  String _origin = 'all';
  String _operation = 'all';
  String _searchQuery = '';
  bool _oldestFirst = true;

  bool get _isArabic =>
      AppLocalizations.of(context)!.localeName.startsWith('ar');

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      final repository = sl<FinanceRepository>();
      final merchantResult = await repository.getMerchantWithdrawals();
      final merchantRequests = merchantResult.fold(
        (failure) => throw StateError(failure.message),
        (items) => items,
      );
      final supervisorResult = await repository.getSupervisorWithdrawals();
      final supervisorRequests = supervisorResult.fold(
        (failure) => throw StateError(failure.message),
        (items) => items,
      );
      if (!mounted) return;
      setState(() {
        _requests = [...merchantRequests, ...supervisorRequests];
        _isLoading = false;
        _loadError = null;
      });
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance requests center',
        context: ErrorDescription('while loading all financial requests'),
      ));
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = AppLocalizations.of(context)!.merchantAuditLoadError;
      });
    }
  }

  List<WithdrawalRequestEntity> get _visibleRequests {
    final expectedStatus =
        _queueStatus == _QueueStatus.pending ? RequestStatus.pending : null;
    final visible = _requests.where((request) {
      final matchesStatus = expectedStatus == null
          ? request.status != RequestStatus.pending
          : request.status == expectedStatus;
      return matchesStatus &&
          _matchesOrigin(request) &&
          _matchesOperation(request) &&
          _matchesSearch(request);
    }).toList();
    visible.sort((a, b) {
      if (_queueStatus == _QueueStatus.pending) {
        return _oldestFirst
            ? _submittedAt(a).compareTo(_submittedAt(b))
            : _submittedAt(b).compareTo(_submittedAt(a));
      }
      return _decisionAt(b).compareTo(_decisionAt(a));
    });
    return visible;
  }

  bool _matchesSearch(WithdrawalRequestEntity request) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return true;
    return [
      request.requestNumber,
      request.id,
      request.beneficiaryName,
      request.iban,
      request.bankName
    ].any((value) => value.toLowerCase().contains(query));
  }

  bool _matchesOrigin(WithdrawalRequestEntity request) {
    if (_origin == 'all') return true;
    if (request.operationType == FinancialOperationType.promotion) {
      final isWasalny = request.sourceOfFunds?.contains('وصلني') == true ||
          request.sourceAccount?.startsWith('wasalny-') == true;
      return _origin == (isWasalny ? 'wasalny' : 'products');
    }
    final source = switch (request.sourceAccount) {
      'product' => 'products',
      final String value => value,
      _ => '',
    };
    if (_origin == 'merchant') {
      return request.beneficiaryType == BeneficiaryType.merchant ||
          source == 'merchant';
    }
    return source == _origin;
  }

  bool _matchesOperation(WithdrawalRequestEntity request) {
    return switch (_operation) {
      'withdrawal' =>
        request.operationType == FinancialOperationType.withdrawal,
      'deposit' => request.operationType == FinancialOperationType.deposit,
      'promotion' => request.operationType == FinancialOperationType.promotion,
      _ => true,
    };
  }

  DateTime _submittedAt(WithdrawalRequestEntity request) {
    final parsed = DateTime.tryParse(request.dateText);
    if (parsed != null) return parsed;
    final identifier = RegExp(r'(\d{12,})').firstMatch(request.id)?.group(1);
    final micros = int.tryParse(identifier ?? '');
    if (micros != null) {
      return DateTime.fromMicrosecondsSinceEpoch(micros);
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  DateTime _decisionAt(WithdrawalRequestEntity request) =>
      request.decisionAt ?? _submittedAt(request);

  String _formatDate(DateTime value) => DateFormat.yMMMd(
        _isArabic ? 'ar' : 'en',
      ).add_jm().format(value.toLocal());

  String _formatSubmittedDate(WithdrawalRequestEntity request) {
    final parsed = DateTime.tryParse(request.dateText);
    return parsed == null ? request.dateText : _formatDate(parsed);
  }

  bool _isOverdue(WithdrawalRequestEntity request) =>
      DateTime.now().difference(_submittedAt(request)) >
      const Duration(hours: 24);

  Future<void> _decide(
    WithdrawalRequestEntity request,
    RequestStatus status, {
    String? reason,
  }) async {
    if (_processingId != null) return;
    setState(() => _processingId = request.id);
    try {
      final repository = sl<FinanceRepository>();
      final result = switch ((request.beneficiaryType, status)) {
        (
          BeneficiaryType.merchant || BeneficiaryType.user,
          RequestStatus.approved
        ) =>
          await repository.approveMerchantFinancialRequest(request.id),
        (
          BeneficiaryType.merchant || BeneficiaryType.user,
          RequestStatus.rejected
        ) =>
          await repository.rejectMerchantFinancialRequest(
            request.id,
            reason ?? '',
          ),
        (BeneficiaryType.merchant || BeneficiaryType.user, _) =>
          await repository.freezeMerchantFinancialRequest(
            request.id,
            reason ?? '',
          ),
        (_, RequestStatus.approved) =>
          await repository.approveWithdrawal(request.id),
        (_, RequestStatus.rejected) =>
          await repository.rejectWithdrawal(request.id, reason ?? ''),
        _ => await repository.freezeWithdrawal(request.id, reason ?? ''),
      };
      final failure = result.fold((failure) => failure, (_) => null);
      if (failure != null) throw StateError(failure.message);

      await _publishDecision(request, status, reason: reason);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        switch (status) {
          RequestStatus.approved =>
            AppLocalizations.of(context)!.financeRequestApproved,
          RequestStatus.rejected =>
            AppLocalizations.of(context)!.financeRequestRejected,
          _ => AppLocalizations.of(context)!.financeRequestFrozen,
        },
      );
      await _loadRequests();
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance requests center',
        context: ErrorDescription('while saving a financial request decision'),
      ));
      if (mounted) {
        AppSnackBar.showError(
          context,
          AppLocalizations.of(context)!.financeRequestDecisionFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _processingId = null);
    }
  }

  Future<void> _restoreRequest(WithdrawalRequestEntity request) async {
    if (_processingId != null) return;
    final confirmed = await FinanceDialogs.showUnfreezeDialog(
      context,
      title: request.beneficiaryName,
      amount: request.netAmount,
    );
    if (!confirmed || !mounted) return;

    setState(() => _processingId = request.id);
    try {
      final result = await sl<FinanceRepository>().restoreFrozenWithdrawal(
        request.id,
        request.beneficiaryType,
      );
      final failure = result.fold((failure) => failure, (_) => null);
      if (failure != null) throw StateError(failure.message);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        AppLocalizations.of(context)!.frozenThawSuccess,
      );
      await _loadRequests();
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance requests center',
        context: ErrorDescription('while restoring a frozen financial request'),
      ));
      if (mounted) {
        AppSnackBar.showError(
          context,
          AppLocalizations.of(context)!.frozenActionFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _processingId = null);
    }
  }

  Future<void> _publishDecision(
    WithdrawalRequestEntity request,
    RequestStatus status, {
    String? reason,
  }) async {
    final recipient = _notificationRecipient(request);
    if (recipient == null) return;
    final titleAr = switch (status) {
      RequestStatus.approved => 'تمت الموافقة على طلبك المالي',
      RequestStatus.rejected => 'تم رفض طلبك المالي',
      _ => 'تم تعليق طلبك المالي للمراجعة',
    };
    final titleEn = switch (status) {
      RequestStatus.approved => 'Your financial request was approved',
      RequestStatus.rejected => 'Your financial request was rejected',
      _ => 'Your financial request is under review',
    };
    final decision = status.name;
    try {
      await WasalnyLocalEventStore().publish(WasalnyLocalEvent(
        id: 'finance-center-$decision-${request.id}',
        recipient: recipient,
        source: 'finance',
        titleAr: titleAr,
        titleEn: titleEn,
        messageAr: status == RequestStatus.rejected
            ? 'تم تحديث حالة الطلب ${request.requestNumber} إلى مرفوض. السبب: ${reason ?? ''}'
            : 'تم تحديث حالة الطلب ${request.requestNumber}: ${_statusText(status, true)}.',
        messageEn: status == RequestStatus.rejected
            ? 'Request ${request.requestNumber} was rejected. Reason: ${reason ?? ''}'
            : 'Request ${request.requestNumber} is now ${_statusText(status, false)}.',
        createdAt: DateTime.now(),
        requestId: request.id,
      ));
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance requests center',
        context: ErrorDescription('while notifying the request owner'),
      ));
    }
  }

  String? _notificationRecipient(WithdrawalRequestEntity request) {
    if (request.operationType == FinancialOperationType.promotion) {
      final isWasalny = request.sourceOfFunds?.contains('وصلني') == true ||
          request.sourceAccount?.startsWith('wasalny-') == true;
      return isWasalny ? 'wasalny' : 'products';
    }
    return switch (request.sourceAccount) {
      'product' => 'products',
      'products' ||
      'services' ||
      'wasalny' ||
      'merchant' =>
        request.sourceAccount,
      _ => null,
    };
  }

  String _statusText(RequestStatus status, bool arabic) => switch (status) {
        RequestStatus.approved => arabic ? 'معتمد' : 'approved',
        RequestStatus.rejected => arabic ? 'مرفوض' : 'rejected',
        RequestStatus.underInvestigation ||
        RequestStatus.frozen =>
          arabic ? 'معلق للمراجعة' : 'on hold',
        RequestStatus.pending => arabic ? 'قيد المراجعة' : 'pending',
      };

  Future<void> _confirmDecision(
    WithdrawalRequestEntity request,
    RequestStatus status,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    String? reason;
    if (status == RequestStatus.rejected) {
      reason = await FinanceDialogs.showRejectionDialog(
        context,
        title: _isArabic ? 'رفض الطلب' : 'Reject request',
      );
      if (reason == null || !mounted) return;
    } else if (status == RequestStatus.underInvestigation) {
      final confirmed = await FinanceDialogs.showFreezeDialog(
        context,
        requestTitle: request.requestNumber,
      );
      if (!confirmed || !mounted) return;
      reason = l10n.temporarilySuspendedForAudit;
    } else {
      final confirmed = await FinanceDialogs.showApprovalDialog(
        context,
        title: _isArabic ? 'اعتماد الطلب' : 'Approve request',
        description: _isArabic
            ? 'اعتماد طلب ${request.beneficiaryName} بقيمة ${CurrencyFormatter.format(request.netAmount)}؟'
            : 'Approve ${request.beneficiaryName}’s request for ${CurrencyFormatter.format(request.netAmount)}?',
      );
      if (!confirmed || !mounted) return;
    }
    await _decide(request, status, reason: reason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final visible = _visibleRequests;
    final visibleAmount =
        visible.fold(0.0, (sum, request) => sum + request.netAmount);

    return Directionality(
      textDirection: _isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: FinancePageAppBar(
          title:
              _isArabic ? 'مركز الطلبات المالية' : 'Financial requests center',
          subtitle: _isArabic
              ? 'طلبات المشرفين والترويج في شاشة واحدة'
              : 'Supervisor and promotion requests in one place',
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: colors.primary),
              )
            : RefreshIndicator(
                onRefresh: _loadRequests,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    _summaryCard(visible.length, visibleAmount),
                    const SizedBox(height: 16),
                    _statusSelector(l10n),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: _isArabic
                            ? 'ابحث برقم الطلب أو المستفيد أو الحساب'
                            : 'Search request, beneficiary, or account',
                        filled: true,
                        fillColor: colors.surface,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () =>
                            setState(() => _oldestFirst = !_oldestFirst),
                        icon: const Icon(Icons.swap_vert),
                        label: Text(_oldestFirst
                            ? (_isArabic ? 'الأقدم أولًا' : 'Oldest first')
                            : (_isArabic ? 'الأحدث أولًا' : 'Newest first')),
                      ),
                    ),
                    _filterSelectors(),
                    const SizedBox(height: 16),
                    if (_loadError != null)
                      _messageCard(context, _loadError!, Icons.error_outline),
                    if (visible.isEmpty)
                      _messageCard(
                        context,
                        _queueStatus == _QueueStatus.pending
                            ? l10n.financeRequestsInProgressEmpty
                            : l10n.financeRequestsArchiveEmpty,
                        Icons.inbox_outlined,
                      )
                    else
                      ...visible.map(_requestCard),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _summaryCard(int count, double amount) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryDark, AppColors.hexFF1E4D73],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.white24,
              child: Icon(Icons.inbox_outlined, color: AppColors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _queueStatus == _QueueStatus.pending
                        ? (_isArabic
                            ? 'طلبات بانتظار قرارك'
                            : 'Awaiting your review')
                        : (_isArabic
                            ? 'طلبات في السجل'
                            : 'Requests in archive'),
                    style: const TextStyle(color: AppColors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count ${AppLocalizations.of(context)!.ordersUnit}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                CurrencyFormatter.format(amount),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _statusSelector(AppLocalizations l10n) =>
      SegmentedButton<_QueueStatus>(
        segments: [
          ButtonSegment(
            value: _QueueStatus.pending,
            label: Text(l10n.financeRequestsInProgressTab),
            icon: const Icon(Icons.pending_actions_outlined),
          ),
          ButtonSegment(
            value: _QueueStatus.archive,
            label: Text(l10n.financeRequestsArchiveTab),
            icon: const Icon(Icons.archive_outlined),
          ),
        ],
        selected: {_queueStatus},
        onSelectionChanged: (value) =>
            setState(() => _queueStatus = value.first),
      );

  Widget _filterSelectors() => Row(
        children: [
          Expanded(
            child: _dropdown(
              value: _origin,
              label: _isArabic ? 'الجهة' : 'Source',
              values: {
                'all': _isArabic ? 'كل الجهات' : 'All sources',
                'merchant': _isArabic ? 'التجار' : 'Merchants',
                'products': _isArabic ? 'مشرف المنتجات' : 'Products supervisor',
                'services': _isArabic ? 'مشرف الخدمات' : 'Services supervisor',
                'wasalny': _isArabic ? 'مشرف وصلني' : 'Wasalny supervisor',
              },
              onChanged: (value) => setState(() => _origin = value),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _dropdown(
              value: _operation,
              label: _isArabic ? 'نوع الطلب' : 'Request type',
              values: {
                'all': _isArabic ? 'كل الأنواع' : 'All types',
                'withdrawal': _isArabic ? 'سحب' : 'Withdrawal',
                'deposit': _isArabic ? 'إيداع' : 'Deposit',
                'promotion': _isArabic ? 'ترويج' : 'Promotion',
              },
              onChanged: (value) => setState(() => _operation = value),
            ),
          ),
        ],
      );

  Widget _dropdown({
    required String value,
    required String label,
    required Map<String, String> values,
    required ValueChanged<String> onChanged,
  }) =>
      DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: values.entries
            .map((entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ))
            .toList(),
        onChanged: (selected) {
          if (selected != null) onChanged(selected);
        },
      );

  Widget _requestCard(WithdrawalRequestEntity request) {
    final colors = Theme.of(context).colorScheme;
    final overdue = _queueStatus == _QueueStatus.pending && _isOverdue(request);
    final isPending = request.status == RequestStatus.pending;
    final statusColor = switch (request.status) {
      RequestStatus.approved => AppColors.successDark,
      RequestStatus.rejected => AppColors.danger,
      RequestStatus.frozen ||
      RequestStatus.underInvestigation =>
        AppColors.orange800,
      RequestStatus.pending => AppColors.info,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: overdue ? AppColors.orange300 : colors.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.beneficiaryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ),
                _pill(_originLabel(request), colors.primary),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(_operationLabel(request))),
                Text(
                  CurrencyFormatter.format(request.netAmount),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _pill(_statusText(request.status, _isArabic), statusColor),
                _pill(request.requestNumber, colors.onSurfaceVariant),
                if (overdue)
                  _pill(
                    _isArabic ? 'متأخر أكثر من 24 ساعة' : 'Over 24 hours old',
                    AppColors.deepOrange,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${_isArabic ? 'تاريخ الطلب' : 'Submitted'}: ${_formatSubmittedDate(request)}',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11),
            ),
            if (!isPending) ...[
              const SizedBox(height: 6),
              Text(
                '${_isArabic ? 'تاريخ القرار' : 'Decision date'}: ${_formatDate(_decisionAt(request))}',
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11),
              ),
            ],
            if (request.alertNotice?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                '${_isArabic ? 'ملاحظة القرار' : 'Decision note'}: ${request.alertNotice}',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () =>
                  showWithdrawalRequestDetailsSheet(context, request),
              icon: const Icon(Icons.receipt_long_outlined, size: 17),
              label:
                  Text(AppLocalizations.of(context)!.withdrawalRequestDetails),
            ),
            if (!isPending &&
                (request.status == RequestStatus.frozen ||
                    request.status == RequestStatus.underInvestigation)) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _processingId == request.id
                    ? null
                    : () => _restoreRequest(request),
                icon: const Icon(Icons.lock_open_outlined, size: 18),
                label: Text(_isArabic
                    ? 'فك التجميد وإعادة الطلب'
                    : 'Unfreeze and restore request'),
              ),
            ],
            if (isPending) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _processingId == request.id
                          ? null
                          : () => _confirmDecision(
                                request,
                                RequestStatus.approved,
                              ),
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: Text(_isArabic ? 'اعتماد' : 'Approve'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _processingId == request.id
                          ? null
                          : () => _confirmDecision(
                                request,
                                RequestStatus.rejected,
                              ),
                      icon: const Icon(Icons.close, size: 18),
                      label: Text(_isArabic ? 'رفض' : 'Reject'),
                    ),
                  ),
                  IconButton(
                    tooltip: _isArabic ? 'تعليق للمراجعة' : 'Place on hold',
                    onPressed: _processingId == request.id
                        ? null
                        : () => _confirmDecision(
                              request,
                              RequestStatus.underInvestigation,
                            ),
                    icon: const Icon(Icons.pause_circle_outline),
                    color: AppColors.orange800,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, Color color) => Container(
        constraints: const BoxConstraints(maxWidth: 180),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w700),
        ),
      );

  String _originLabel(WithdrawalRequestEntity request) {
    if (request.operationType == FinancialOperationType.promotion) {
      final isWasalny = request.sourceOfFunds?.contains('وصلني') == true ||
          request.sourceAccount?.startsWith('wasalny-') == true;
      return isWasalny
          ? (_isArabic ? 'وصلني' : 'Wasalny')
          : (_isArabic ? 'المنتجات' : 'Products');
    }
    final source =
        request.sourceAccount == 'product' ? 'products' : request.sourceAccount;
    return switch (source) {
      'products' => _isArabic ? 'مشرف المنتجات' : 'Products supervisor',
      'services' => _isArabic ? 'مشرف الخدمات' : 'Services supervisor',
      'wasalny' => _isArabic ? 'مشرف وصلني' : 'Wasalny supervisor',
      'merchant' => _isArabic ? 'مشرف التجار' : 'Merchant supervisor',
      _ when request.beneficiaryType == BeneficiaryType.merchant =>
        _isArabic ? 'تاجر' : 'Merchant',
      _ => _isArabic ? 'مشرف' : 'Supervisor',
    };
  }

  String _operationLabel(WithdrawalRequestEntity request) =>
      switch (request.operationType) {
        FinancialOperationType.withdrawal =>
          _isArabic ? 'طلب سحب' : 'Withdrawal request',
        FinancialOperationType.deposit =>
          _isArabic ? 'طلب إيداع' : 'Deposit request',
        FinancialOperationType.promotion =>
          _isArabic ? 'طلب ترويج منتج' : 'Product promotion request',
      };

  Widget _messageCard(BuildContext context, String message, IconData icon) =>
      Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center),
            if (_loadError != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _loadRequests,
                icon: const Icon(Icons.refresh),
                label: Text(_isArabic ? 'إعادة المحاولة' : 'Retry'),
              ),
            ],
          ],
        ),
      );
}
