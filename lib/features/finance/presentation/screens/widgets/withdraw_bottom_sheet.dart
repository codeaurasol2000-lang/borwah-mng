import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../data/datasources/finance_supervisor_payout_details_store.dart';
import '../../../domain/entities/withdrawal_request_entity.dart';
import '../../../domain/repositories/finance_repository.dart';
import '../../utils/financial_request_notifications.dart';

void showWithdrawBottomSheet(
  BuildContext context, {
  FinanceSupervisorPayoutDetails? payoutDetails,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    builder: (_) => _WithdrawBottomSheet(payoutDetails: payoutDetails),
  );
}

class _WithdrawBottomSheet extends StatefulWidget {
  final FinanceSupervisorPayoutDetails? payoutDetails;

  const _WithdrawBottomSheet({this.payoutDetails});

  @override
  State<_WithdrawBottomSheet> createState() => _WithdrawBottomSheetState();
}

class _WithdrawBottomSheetState extends State<_WithdrawBottomSheet> {
  final TextEditingController _amountController =
      TextEditingController(text: '52,000.00');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitWithdrawal() async {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final payoutDetails = widget.payoutDetails;
    if (payoutDetails == null || !payoutDetails.isComplete) {
      AppSnackBar.showError(
        context,
        isArabic
            ? 'أضف بيانات السحب الشخصية أولاً من زر تعديل بيانات السحب.'
            : 'Add personal payout details first using Edit payout details.',
      );
      return;
    }
    final amount = double.tryParse(
      _amountController.text.replaceAll(',', '').trim(),
    );
    if (amount == null || !amount.isFinite || amount < 1000 || amount > 52000) {
      AppSnackBar.showError(
        context,
        isArabic
            ? 'أدخل مبلغًا بين 1,000 والرصيد الشخصي المتاح 52,000.'
            : 'Enter an amount between 1,000 and the personal available balance of 52,000.',
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result =
          await sl<FinanceRepository>().submitSupervisorFinancialRequest(
        beneficiaryName: payoutDetails.accountHolderName,
        beneficiaryRole: l10n.cfoRole,
        sourceAccount: 'finance_supervisor_personal_wallet',
        amount: amount,
        operationType: FinancialOperationType.withdrawal,
        bankName: payoutDetails.bankName,
        iban: payoutDetails.iban,
        transferMethod: isArabic ? 'تحويل بنكي' : 'Bank transfer',
        dateText: DateTime.now().toIso8601String(),
        notes: isArabic
            ? 'طلب سحب من محفظة المستحقات الشخصية للمشرف المالي، مرسل للإدارة للاعتماد.'
            : 'Withdrawal from the finance supervisor personal dues wallet; submitted to management for approval.',
      );
      final request = result.fold(
        (failure) => throw StateError(failure.message),
        (request) => request,
      );
      if (!mounted) return;
      await notifyFinanceOfSupervisorRequest(request);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        isArabic
            ? 'تم إرسال طلب السحب للإدارة للاعتماد. رقم الطلب: ${request.requestNumber}'
            : 'Withdrawal request sent to management for approval. Request: ${request.requestNumber}',
      );
      Navigator.pop(context);
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance supervisor personal withdrawal',
        context: ErrorDescription('while submitting personal withdrawal'),
      ));
      if (mounted) {
        AppSnackBar.showError(
          context,
          isArabic
              ? 'تعذر إرسال طلب السحب. لم يتم خصم أي مبلغ.'
              : 'Could not submit the withdrawal request. No amount was deducted.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHeader(context, l10n),
                  const SizedBox(height: 16),
                  _buildAccountSummary(l10n),
                  const SizedBox(height: 16),
                  _buildAvailableBalance(l10n),
                  const SizedBox(height: 18),
                  _buildAmountInput(l10n, isArabic),
                  const SizedBox(height: 10),
                  _buildAmountChips(l10n),
                  const SizedBox(height: 18),
                  _buildBankSection(l10n),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitWithdrawal,
                      icon: const Icon(Icons.send_outlined, size: 18),
                      label: Text(
                        _isSubmitting
                            ? (isArabic
                                ? 'جارٍ إرسال الطلب...'
                                : 'Sending request...')
                            : (isArabic
                                ? 'إرسال طلب السحب للإدارة'
                                : 'Send withdrawal request to management'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryExtraDark,
                        foregroundColor: AppColors.white,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        backgroundColor: AppColors.surfaceLight,
                        side: BorderSide.none,
                        minimumSize: const Size.fromHeight(44),
                      ),
                      child: Text(l10n.withdrawSheetCancel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppColors.primaryExtraDark,
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Icons.person_outline, color: AppColors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.withdrawSheetBrand,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary)),
              Text(
                  l10n.localeName.startsWith('ar')
                      ? 'طلب سحب المستحقات الشخصية'
                      : 'Personal dues withdrawal request',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark)),
            ],
          ),
        ),
        IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildAccountSummary(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                  l10n.localeName.startsWith('ar')
                      ? 'محفظة المستحقات الشخصية للمشرف المالي'
                      : 'Finance supervisor personal dues wallet',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: _statusBadge(
                l10n.localeName.startsWith('ar')
                    ? 'طلب بانتظار اعتماد الإدارة'
                    : 'Request pending management approval',
                Icons.hourglass_top_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
            l10n.localeName.startsWith('ar')
                ? 'لن يُخصم المبلغ قبل اعتماد الطلب.'
                : 'No amount will be deducted before the request is approved.',
            style: const TextStyle(fontSize: 10, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildAvailableBalance(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance_wallet_outlined,
                  size: 14, color: AppColors.primaryDark),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                    l10n.localeName.startsWith('ar')
                        ? 'الرصيد الشخصي المتاح لطلب السحب'
                        : 'Personal balance available for withdrawal request',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('52,000.00',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryExtraDark)),
                ),
              ),
              const SizedBox(width: 4),
              Text(l10n.currencyEgy,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          _statusBadge(
            l10n.localeName.startsWith('ar')
                ? 'الحد الأدنى 1,000 • الصرف بعد موافقة الإدارة'
                : 'Minimum 1,000 • payout after management approval',
            Icons.info_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput(AppLocalizations l10n, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.withdrawSheetEnterAmount,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
            ),
            TextButton(
              onPressed: () =>
                  setState(() => _amountController.text = '52,000.00'),
              child: Text(l10n.withdrawSheetSetMaximum),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.payments_outlined,
                  color: AppColors.primaryDark, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(l10n.currencyEgy,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountChips(AppLocalizations l10n) {
    final amounts = [
      (l10n.withdrawSheetAllAmount, '52,000.00', true),
      (l10n.withdrawSheetAmount25k, '25,000.00', false),
      (l10n.withdrawSheetAmount10k, '10,000.00', false),
      (l10n.withdrawSheetAmount5k, '5,000.00', false),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < amounts.length; index++) ...[
            if (index > 0) const SizedBox(width: 8),
            _buildAmountChip(
                amounts[index].$1, amounts[index].$2, amounts[index].$3),
          ],
        ],
      ),
    );
  }

  Widget _buildBankSection(AppLocalizations l10n) {
    final isArabic = l10n.localeName.startsWith('ar');
    final details = widget.payoutDetails;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isArabic ? 'حساب السحب الشخصي' : 'Personal payout account',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_balance_outlined,
                  color: AppColors.primaryDark),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details?.isComplete == true
                          ? details!.bankName
                          : (isArabic
                              ? 'بيانات السحب غير مكتملة'
                              : 'Payout details are incomplete'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details?.isComplete == true
                          ? details!.maskedIban
                          : (isArabic
                              ? 'احفظ بيانات حسابك الشخصي أولاً'
                              : 'Save your personal account details first'),
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                details?.isComplete == true
                    ? Icons.verified_user_outlined
                    : Icons.warning_amber_rounded,
                color: details?.isComplete == true
                    ? AppColors.success
                    : AppColors.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String label, IconData icon) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.blue700),
          const SizedBox(width: 4),
          Flexible(
            child: Text(label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 9,
                    color: AppColors.blue800,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountChip(String label, String value, bool isSelected) {
    final isArabic = AppLocalizations.of(context)!.localeName == 'ar';
    return GestureDetector(
      onTap: () => setState(() => _amountController.text = value),
      child: Container(
        constraints: const BoxConstraints(minHeight: 36),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryExtraDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            maxLines: 1,
            style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr),
      ),
    );
  }
}
