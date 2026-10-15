import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../features/finance/domain/entities/withdrawal_request_entity.dart';
import '../../../../features/finance/domain/repositories/finance_repository.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/merchant_supervisor_local_store.dart';

class _MerchantUpgradeRequest {
  final String id;
  final String merchant;
  final String currentTier;
  final String requestedTier;
  final double amount;
  final String submittedAt;

  const _MerchantUpgradeRequest({
    required this.id,
    required this.merchant,
    required this.currentTier,
    required this.requestedTier,
    required this.amount,
    required this.submittedAt,
  });
}

class MerchantUpgradeRequestsScreen extends StatefulWidget {
  const MerchantUpgradeRequestsScreen({super.key});

  @override
  State<MerchantUpgradeRequestsScreen> createState() =>
      _MerchantUpgradeRequestsScreenState();
}

class _MerchantUpgradeRequestsScreenState
    extends State<MerchantUpgradeRequestsScreen> {
  static const _actionsKey = 'merchant_upgrade_review_actions_v1';
  final Set<String> _sentToFinance = {};
  final Map<String, String> _rejectionReasons = {};
  final Set<String> _processing = {};
  bool _isLoading = true;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _loadActions();
  }

  Future<void> _loadActions() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final encoded = preferences.getString(_actionsKey);
      if (encoded != null) {
        final decoded = jsonDecode(encoded);
        if (decoded is! Map<String, dynamic> ||
            decoded['sent'] is! List ||
            decoded['rejections'] is! Map<String, dynamic>) {
          throw const FormatException('Merchant upgrade actions are invalid.');
        }
        final sent = (decoded['sent'] as List).map((value) {
          if (value is! String) {
            throw const FormatException('Merchant upgrade ID is invalid.');
          }
          return value;
        });
        final rejections = <String, String>{};
        for (final entry
            in (decoded['rejections'] as Map<String, dynamic>).entries) {
          if (entry.value is! String) {
            throw const FormatException('Merchant upgrade reason is invalid.');
          }
          rejections[entry.key] = entry.value as String;
        }
        _sentToFinance.addAll(sent);
        _rejectionReasons.addAll(rejections);
      }
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant upgrade requests',
        ),
      );
      _loadError = error;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _persistActions() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _actionsKey,
      jsonEncode({
        'sent': _sentToFinance.toList(),
        'rejections': _rejectionReasons,
      }),
    );
    if (!saved) throw StateError('Could not save merchant upgrade actions.');
  }

  List<_MerchantUpgradeRequest> _requests(AppLocalizations l10n) => [
        _MerchantUpgradeRequest(
          id: 'MUP-2042',
          merchant: l10n.finRequestCarMerchant,
          currentTier: l10n.merchantStandardBadge,
          requestedTier: l10n.merchantFeaturedBadge,
          amount: 3500,
          submittedAt: l10n.finRequestTodayTime,
        ),
        _MerchantUpgradeRequest(
          id: 'MUP-2038',
          merchant: l10n.finRequestPackageMerchant,
          currentTier: l10n.merchantStandardBadge,
          requestedTier: l10n.merchantFeaturedBadge,
          amount: 2200,
          submittedAt: l10n.finRequestYesterdayTime,
        ),
        _MerchantUpgradeRequest(
          id: 'MUP-2029',
          merchant: l10n.finRequestJewelryMerchant,
          currentTier: l10n.merchantStandardBadge,
          requestedTier: l10n.merchantFeaturedBadge,
          amount: 1800,
          submittedAt: l10n.finRequestOlderTime,
        ),
      ];

  Future<void> _sendToFinance(
    AppLocalizations l10n,
    _MerchantUpgradeRequest request,
  ) async {
    if (_processing.contains(request.id) ||
        _sentToFinance.contains(request.id) ||
        _rejectionReasons.containsKey(request.id)) {
      return;
    }
    setState(() => _processing.add(request.id));
    try {
      final result =
          await sl<FinanceRepository>().submitMerchantFinancialRequest(
        beneficiaryName: request.merchant,
        requestTitle: '${l10n.navMerchantUpgrades} ${request.requestedTier}',
        sourceAccount: request.id,
        amount: request.amount,
      );
      final failure = result.fold((failure) => failure, (_) => null);
      if (failure != null) throw StateError(failure.message);

      _sentToFinance.add(request.id);
      try {
        await _persistActions();
      } on Object {
        _sentToFinance.remove(request.id);
        rethrow;
      }
      try {
        await MerchantSupervisorLocalStore.recordAction(
          action: l10n.merchantAuditFinancialSubmitted,
          subject: request.merchant,
          details:
              '${request.id} · ${request.requestedTier} · ${request.amount}',
        );
      } on Object catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'merchant upgrade audit',
          ),
        );
      }
      if (mounted) {
        AppSnackBar.showSuccess(context, l10n.finRequestSentConfirmation);
      }
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant upgrade finance submission',
        ),
      );
      if (mounted) AppSnackBar.showError(context, l10n.finRequestActionFailed);
    } finally {
      if (mounted) setState(() => _processing.remove(request.id));
    }
  }

  Future<void> _reject(
    AppLocalizations l10n,
    _MerchantUpgradeRequest request,
  ) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.finRequestRejectTitle),
        content: TextField(
          controller: controller,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: l10n.finRequestRejectReason,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) Navigator.pop(dialogContext, value);
            },
            child: Text(l10n.finRequestRejectAction),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason == null || !mounted) return;

    final previous = _rejectionReasons[request.id];
    setState(() => _rejectionReasons[request.id] = reason);
    try {
      await _persistActions();
      await MerchantSupervisorLocalStore.recordAction(
        action: l10n.merchantAuditFinancialRejected,
        subject: request.merchant,
        details: '${request.id} · ${l10n.finRequestRejectReason}: $reason',
      );
      if (mounted) {
        AppSnackBar.showSuccess(context, l10n.finRequestRejectionSaved);
      }
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'merchant upgrade rejection',
        ),
      );
      if (!mounted) return;
      setState(() {
        if (previous == null) {
          _rejectionReasons.remove(request.id);
        } else {
          _rejectionReasons[request.id] = previous;
        }
      });
      AppSnackBar.showError(context, l10n.finRequestActionFailed);
    }
  }

  Future<void> _showFinanceStatus(
    AppLocalizations l10n,
    _MerchantUpgradeRequest request,
  ) async {
    final result = await sl<FinanceRepository>().getMerchantWithdrawals();
    if (!mounted) return;
    final matchingRequests = result.fold<List<WithdrawalRequestEntity>>(
      (_) => const [],
      (requests) => requests
          .where((item) => item.sourceAccount == request.id)
          .toList(growable: false),
    );
    final value = matchingRequests.isEmpty ? null : matchingRequests.first;
    final message = value == null
        ? l10n.finRequestUnderReview
        : switch (value.status) {
            RequestStatus.approved => l10n.withdrawalDetailsStatusApproved,
            RequestStatus.rejected => l10n.finRequestRejected,
            RequestStatus.underInvestigation => l10n.finRequestAwaitingManager,
            _ => l10n.finRequestUnderReview,
          };
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.merchantFinanceStatusTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.finRequestClose),
          ),
        ],
      ),
    );
  }

  void _showDetails(AppLocalizations l10n, _MerchantUpgradeRequest request) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.navMerchantUpgrades),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.merchant),
            const SizedBox(height: 8),
            Text('${l10n.expenseRequestNumber}: ${request.id}'),
            Text('${request.currentTier} → ${request.requestedTier}'),
            Text('${request.amount} ${l10n.finRequestCurrency}'),
            Text(request.submittedAt),
            if (_rejectionReasons[request.id] case final reason?) ...[
              const SizedBox(height: 8),
              Text('${l10n.finRequestRejectReason}: $reason'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.finRequestClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final requests = _requests(l10n);
    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            l10n.navMerchantUpgrades,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(l10n.merchantUpgradeReviewSubtitle),
          if (_isLoading) const LinearProgressIndicator(),
          if (_loadError != null) Text(l10n.finRequestActionFailed),
          const SizedBox(height: 12),
          ...requests.map((request) {
            final rejection = _rejectionReasons[request.id];
            final sent = _sentToFinance.contains(request.id);
            final state = rejection != null
                ? l10n.finRequestRejected
                : sent
                    ? l10n.finRequestSentConfirmation
                    : l10n.finRequestUnderReview;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: .025),
                    blurRadius: 8,
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
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color:  AppColors.hexFFEAF0FF,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.storefront_outlined,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          request.merchant,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _statusBadge(state, rejection != null),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color:  AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${request.currentTier}  →  ${request.requestedTier}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${request.amount} ${l10n.finRequestCurrency} · ${request.submittedAt}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (rejection != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.finRequestRejectReason}: $rejection',
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontSize: 11,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  if (sent)
                    OutlinedButton.icon(
                      onPressed: () => _showFinanceStatus(l10n, request),
                      icon: const Icon(Icons.track_changes_outlined, size: 16),
                      label: Text(l10n.merchantFinanceViewStatus),
                    )
                  else if (rejection == null) ...[
                    OutlinedButton.icon(
                      onPressed: () => _showDetails(l10n, request),
                      icon: const Icon(Icons.receipt_long_outlined, size: 16),
                      label: Text(l10n.finRequestViewDetails),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _processing.contains(request.id)
                                ? null
                                : () => _reject(l10n, request),
                            icon: const Icon(Icons.close, size: 16),
                            label: Text(l10n.finRequestRejectAction),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: AppColors.cardBorder),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: _processing.contains(request.id)
                                ? null
                                : () => _sendToFinance(l10n, request),
                            icon: const Icon(Icons.send_outlined, size: 16),
                            label: Text(l10n.finRequestSendToFinance),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, bool isRejected) {
    final color = isRejected ? AppColors.danger : AppColors.info;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isRejected ?  AppColors.textPrimary :  AppColors.hexFFEAF0FF,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
