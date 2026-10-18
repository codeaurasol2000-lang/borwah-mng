import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/withdrawal_request_entity.dart';

Future<void> showWithdrawalRequestDetailsSheet(
  BuildContext context,
  WithdrawalRequestEntity request,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.transparent,
    builder: (_) => _WithdrawalRequestDetailsSheet(request: request),
  );
}

class _WithdrawalRequestDetailsSheet extends StatelessWidget {
  final WithdrawalRequestEntity request;

  const _WithdrawalRequestDetailsSheet({required this.request});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = _statusLabel(l10n, request.status);
    final colors = Theme.of(context).colorScheme;

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .88),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.withdrawalDetailsTitle,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        Text(
                          request.requestNumber,
                          style: const TextStyle(
                            color: AppColors.info,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.format(request.netAmount),
                        style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(status),
                          backgroundColor: _statusColor(request.status)
                              .withValues(alpha: .12),
                          labelStyle: TextStyle(
                            color: _statusColor(request.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DetailsCard(
                    children: [
                      _DetailRow(
                        label: l10n.withdrawalDetailsBeneficiary,
                        value: request.beneficiaryName,
                      ),
                      _DetailRow(
                        label: l10n.withdrawalDetailsBeneficiaryRole,
                        value: request.beneficiaryRole,
                      ),
                      _DetailRow(
                        label: l10n.financeOperationType,
                        value: switch (request.operationType) {
                          FinancialOperationType.withdrawal =>
                            l10n.financeWalletWithdrawal,
                          FinancialOperationType.deposit =>
                            l10n.financeWalletDeposit,
                          FinancialOperationType.promotion =>
                            l10n.wasalnyPromotionFinanceRequestType,
                        },
                      ),
                      if (request.sourceAccount?.isNotEmpty ?? false)
                        _DetailRow(
                          label: l10n.financeSourceAccount,
                          value: request.sourceAccount!,
                        ),
                      _DetailRow(
                        label: l10n.withdrawalDetailsGrossAmount,
                        value: CurrencyFormatter.format(request.grossAmount),
                      ),
                      _DetailRow(
                        label: l10n.withdrawalDetailsFeePercentage,
                        value:
                            '${request.platformFeePercentage.toStringAsFixed(1)}%',
                      ),
                      _DetailRow(
                        label: l10n.withdrawalDetailsFeeAmount,
                        value:
                            CurrencyFormatter.format(request.platformFeeAmount),
                      ),
                      _DetailRow(
                        label: l10n.withdrawalDetailsNetAmount,
                        value: CurrencyFormatter.format(request.netAmount),
                      ),
                      if (request.reference?.isNotEmpty ?? false)
                        _DetailRow(
                          label: l10n.settlementReferenceLabel,
                          value: request.reference!,
                        ),
                      if (request.notes?.isNotEmpty ?? false)
                        _DetailRow(
                          label: l10n.settlementNotesLabel,
                          value: request.notes!,
                        ),
                      _DetailRow(
                        label: l10n.withdrawalDetailsDate,
                        value: request.dateText.isEmpty
                            ? l10n.withdrawalDetailsNoValue
                            : request.dateText,
                      ),
                      if (request.decisionAt != null)
                        _DetailRow(
                          label: l10n.localeName.startsWith('ar')
                              ? 'تاريخ القرار'
                              : 'Decision date',
                          value: DateFormat.yMMMd(
                            l10n.localeName,
                          ).add_jm().format(request.decisionAt!.toLocal()),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _DetailsCard(
                    children: [
                      _DetailRow(
                        label: l10n.withdrawalDetailsBankName,
                        value: request.bankName.isEmpty
                            ? l10n.withdrawalDetailsNoValue
                            : request.bankName,
                      ),
                      _DetailRow(
                        label: l10n.withdrawalDetailsIban,
                        value: request.iban.isEmpty
                            ? l10n.withdrawalDetailsNoValue
                            : request.iban,
                        valueDirection: ui.TextDirection.ltr,
                      ),
                      if (request.transferMethod?.isNotEmpty ?? false)
                        _DetailRow(
                          label: l10n.withdrawalDetailsTransferMethod,
                          value: request.transferMethod!,
                        ),
                      if (request.isInstantTransferReady)
                        _DetailRow(
                          label: l10n.withdrawalDetailsInstantReady,
                          value: l10n.withdrawalDetailsInstantReady,
                        ),
                      if (request.sourceOfFunds?.isNotEmpty ?? false)
                        _DetailRow(
                          label: l10n.withdrawalDetailsSource,
                          value: request.sourceOfFunds!,
                        ),
                      if (request.auditCheckResult?.isNotEmpty ?? false)
                        _DetailRow(
                          label: l10n.withdrawalDetailsAuditResult,
                          value: request.auditCheckResult!,
                        ),
                      if (request.alertNotice?.isNotEmpty ?? false)
                        _DetailRow(
                          label: l10n.withdrawalDetailsAlert,
                          value: request.alertNotice!,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, RequestStatus status) {
    return switch (status) {
      RequestStatus.pending => l10n.withdrawalDetailsStatusPending,
      RequestStatus.underInvestigation =>
        l10n.withdrawalDetailsStatusInvestigation,
      RequestStatus.approved => l10n.withdrawalDetailsStatusApproved,
      RequestStatus.frozen => l10n.withdrawalDetailsStatusFrozen,
      RequestStatus.rejected => l10n.withdrawalDetailsStatusRejected,
    };
  }

  Color _statusColor(RequestStatus status) {
    return switch (status) {
      RequestStatus.approved => AppColors.success,
      RequestStatus.rejected => AppColors.danger,
      RequestStatus.frozen ||
      RequestStatus.underInvestigation =>
        AppColors.warning,
      RequestStatus.pending => AppColors.info,
    };
  }
}

class _DetailsCard extends StatelessWidget {
  final List<Widget> children;

  const _DetailsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final ui.TextDirection? valueDirection;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Directionality(
              textDirection: valueDirection ??
                  Directionality.maybeOf(context) ??
                  ui.TextDirection.ltr,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
