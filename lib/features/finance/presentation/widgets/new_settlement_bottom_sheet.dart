import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../utils/finance_localizer.dart';

class NewSettlementBottomSheet extends StatefulWidget {
  const NewSettlementBottomSheet({super.key});

  static Future<WithdrawalRequestEntity?> show(BuildContext context) {
    return showModalBottomSheet<WithdrawalRequestEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => const NewSettlementBottomSheet(),
    );
  }

  @override
  State<NewSettlementBottomSheet> createState() =>
      _NewSettlementBottomSheetState();
}

class _NewSettlementBottomSheetState extends State<NewSettlementBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _beneficiaryController = TextEditingController();
  final _beneficiaryRoleController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ibanController = TextEditingController();

  List<WithdrawalRequestEntity> _savedBeneficiaryAccounts = [];
  WithdrawalRequestEntity? _selectedAccount;
  bool _isLoadingAccounts = true;
  bool _useManualBankDetails = false;
  bool _isSubmitting = false;

  bool _isRefund = false;

  @override
  void initState() {
    super.initState();
    _loadRegisteredAccounts();
  }

  Future<void> _loadRegisteredAccounts() async {
    try {
      // Saved beneficiary payout destinations come from earlier settlements.
      // Finance department bank accounts are not beneficiary accounts.
      final result = await sl<FinanceRepository>().getSupervisorWithdrawals();
      if (!mounted) return;
      result.fold(
        (_) => setState(() {
          _isLoadingAccounts = false;
          _useManualBankDetails = true;
        }),
        (accounts) {
          final seen = <String>{};
          final savedAccounts = accounts.where((request) {
            if (request.settlementMode == null) return false;
            final key = '${request.bankName.trim()}|${request.iban.trim()}';
            return request.bankName.trim().isNotEmpty &&
                request.iban.trim().isNotEmpty &&
                seen.add(key);
          }).toList(growable: false);
          setState(() {
            _savedBeneficiaryAccounts = savedAccounts;
            _selectedAccount =
                savedAccounts.isEmpty ? null : savedAccounts.first;
            _isLoadingAccounts = false;
            _useManualBankDetails = savedAccounts.isEmpty;
          });
        },
      );
    } on Object {
      if (!mounted) return;
      setState(() {
        _isLoadingAccounts = false;
        _useManualBankDetails = true;
      });
    }
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    final bankName = _useManualBankDetails
        ? _bankNameController.text.trim()
        : _selectedAccount?.bankName ?? '';
    final iban = _useManualBankDetails
        ? _ibanController.text.trim()
        : _selectedAccount?.iban ?? '';
    if (!_hasValidIban(iban)) {
      final isArabic = l10n.localeName.startsWith('ar');
      AppSnackBar.showError(
        context,
        isArabic ? 'رقم الآيبان غير صالح' : 'Invalid IBAN',
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final result =
        await sl<FinanceRepository>().submitSupervisorFinancialRequest(
      beneficiaryName: _beneficiaryController.text.trim(),
      beneficiaryRole: _beneficiaryRoleController.text.trim(),
      sourceAccount: l10n.settlementsEscrowWallet,
      amount: double.parse(
        _amountController.text.replaceAll(',', '').trim(),
      ),
      operationType: _isRefund
          ? FinancialOperationType.withdrawal
          : FinancialOperationType.deposit,
      bankName: bankName,
      iban: iban,
      transferMethod: l10n.settlementPaymentBankTransfer,
      dateText: DateTime.now().toIso8601String(),
      reference: _referenceController.text.trim(),
      notes: _descriptionController.text.trim(),
      settlementMode: _isRefund ? 'refund' : 'offset',
    );

    if (!mounted) return;
    result.fold(
      (_) {
        setState(() => _isSubmitting = false);
        AppSnackBar.showError(context, l10n.bankEditRequestFailed);
      },
      (request) => Navigator.pop(context, request),
    );
  }

  String? Function(String?) _requiredFieldValidator(AppLocalizations l10n) {
    return (value) =>
        (value ?? '').trim().isNotEmpty ? null : l10n.bankEditRequired;
  }

  String? Function(String?) _ibanValidator(
    AppLocalizations l10n,
    bool isArabic,
  ) {
    return (value) {
      final iban =
          (value ?? '').replaceAll(RegExp(r'[\s-]+'), '').toUpperCase();
      if (iban.isEmpty) return l10n.bankEditRequired;
      if (!RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]{11,30}$').hasMatch(iban)) {
        return isArabic ? 'صيغة الآيبان غير صحيحة' : 'Invalid IBAN format';
      }
      return _hasValidIban(iban)
          ? null
          : (isArabic ? 'رقم الآيبان غير صالح' : 'Invalid IBAN checksum');
    };
  }

  bool _hasValidIban(String value) {
    final iban = value.replaceAll(RegExp(r'[\s-]+'), '').toUpperCase();
    if (!RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z0-9]{11,30}$').hasMatch(iban)) {
      return false;
    }
    final rearranged = '${iban.substring(4)}${iban.substring(0, 4)}';
    var remainder = 0;
    for (final character in rearranged.split('')) {
      final code = character.codeUnitAt(0);
      final digits =
          code >= 65 && code <= 90 ? (code - 55).toString() : character;
      for (final digit in digits.split('')) {
        remainder = (remainder * 10 + int.parse(digit)) % 97;
      }
    }
    return remainder == 1;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _descriptionController.dispose();
    _beneficiaryController.dispose();
    _beneficiaryRoleController.dispose();
    _bankNameController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    return SafeArea(
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: SizedBox(
                        width: 46,
                        height: 4,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.hexFFD9DCE3,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close,
                              color: AppColors.primaryDark),
                        ),
                        Expanded(
                          child: Text(
                            l10n.settlementSheetTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ModeChip(
                              label: l10n.settlementOffsetMode,
                              selected: !_isRefund,
                              onTap: () => setState(() => _isRefund = false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ModeChip(
                              label: l10n.settlementRefundMode,
                              selected: _isRefund,
                              onTap: () => setState(() => _isRefund = true),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoField(
                      label: l10n.settlementTypeLabel,
                      value: l10n.settlementTypeInstant,
                      trailing: const Icon(Icons.bolt_rounded),
                    ),
                    const SizedBox(height: 10),
                    _LabeledInput(
                      label: l10n.settlementBeneficiaryName,
                      controller: _beneficiaryController,
                      isArabic: isArabic,
                      validator: _requiredFieldValidator(l10n),
                    ),
                    const SizedBox(height: 10),
                    _LabeledInput(
                      label: l10n.settlementBeneficiaryRole,
                      controller: _beneficiaryRoleController,
                      isArabic: isArabic,
                      validator: _requiredFieldValidator(l10n),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoadingAccounts)
                      const LinearProgressIndicator(minHeight: 2)
                    else if (_savedBeneficiaryAccounts.isEmpty)
                      Text(
                        l10n.settlementNoSavedAccounts,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      )
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: _ModeChip(
                              label: l10n.settlementUseSavedAccount,
                              selected: !_useManualBankDetails,
                              onTap: () =>
                                  setState(() => _useManualBankDetails = false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _ModeChip(
                              label: l10n.settlementEnterBankManually,
                              selected: _useManualBankDetails,
                              onTap: () =>
                                  setState(() => _useManualBankDetails = true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (_useManualBankDetails) ...[
                      _LabeledInput(
                        label: l10n.bankNameField,
                        controller: _bankNameController,
                        isArabic: isArabic,
                        validator: _requiredFieldValidator(l10n),
                      ),
                      const SizedBox(height: 10),
                      _LabeledInput(
                        label: l10n.ibanField,
                        controller: _ibanController,
                        isArabic: isArabic,
                        validator: _ibanValidator(l10n, isArabic),
                      ),
                      const SizedBox(height: 10),
                    ] else if (!_isLoadingAccounts &&
                        _savedBeneficiaryAccounts.isNotEmpty)
                      DropdownButtonFormField<WithdrawalRequestEntity>(
                        initialValue: _selectedAccount,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.settlementUseSavedAccount,
                          filled: true,
                          fillColor: AppColors.surfaceLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _savedBeneficiaryAccounts.map((account) {
                          final bankName = FinanceLocalizer.localizeBankName(
                              context, account.bankName);
                          return DropdownMenuItem(
                            value: account,
                            child: Text(
                              '${FinanceLocalizer.localizeWithdrawalText(context, account.beneficiaryName)} · $bankName · ${account.iban}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(growable: false),
                        onChanged: (account) =>
                            setState(() => _selectedAccount = account),
                        validator: (account) =>
                            account == null ? l10n.bankEditRequired : null,
                      ),
                    if (!_useManualBankDetails &&
                        !_isLoadingAccounts &&
                        _savedBeneficiaryAccounts.isNotEmpty)
                      const SizedBox(height: 10),
                    _LabeledInput(
                      label: l10n.settlementAmountLabel,
                      controller: _amountController,
                      prefix: l10n.currencyEgy,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      isArabic: isArabic,
                      validator: (value) {
                        final amount = double.tryParse(
                          (value ?? '').replaceAll(',', '').trim(),
                        );
                        return amount != null && amount > 0
                            ? null
                            : l10n.expenseAmountInvalid;
                      },
                    ),
                    const SizedBox(height: 10),
                    _LabeledInput(
                      label: l10n.settlementReferenceLabel,
                      controller: _referenceController,
                      prefix: '#',
                      isArabic: isArabic,
                      validator: _requiredFieldValidator(l10n),
                    ),
                    const SizedBox(height: 10),
                    _LabeledInput(
                      label: l10n.settlementNotesLabel,
                      controller: _descriptionController,
                      minLines: 3,
                      maxLines: 4,
                      hintText: l10n.settlementNotesHint,
                      isArabic: isArabic,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:  AppColors.textPrimary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.settlementPaymentDetailsTitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _DetailRow(
                              label: l10n.settlementPaymentMethodLabel,
                              value: l10n.settlementPaymentBankTransfer),
                          const SizedBox(height: 8),
                          _DetailRow(
                            label: l10n.settlementDateLabel,
                            value: MaterialLocalizations.of(context)
                                .formatShortDate(
                              DateUtils.dateOnly(DateTime.now()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSubmitting || _isLoadingAccounts
                            ? null
                            : () => _submit(l10n),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                l10n.settlementSubmit,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryDark : AppColors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final Widget trailing;
  const _InfoField({
    required this.label,
    required this.value,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          trailing,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? prefix;
  final TextInputType? keyboardType;
  final int minLines;
  final int maxLines;
  final String? hintText;
  final bool isArabic;
  final String? Function(String?)? validator;

  const _LabeledInput({
    required this.label,
    required this.controller,
    this.prefix,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 1,
    this.hintText,
    this.isArabic = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          decoration: InputDecoration(
            hintText: hintText ?? label,
            filled: true,
            fillColor: AppColors.surfaceLight,
            prefixText: prefix,
            prefixStyle: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryDark, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
