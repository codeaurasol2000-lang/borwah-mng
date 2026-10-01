import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class NewSettlementBottomSheet extends StatefulWidget {
  const NewSettlementBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NewSettlementBottomSheet(),
    );
  }

  @override
  State<NewSettlementBottomSheet> createState() => _NewSettlementBottomSheetState();
}

class _NewSettlementBottomSheetState extends State<NewSettlementBottomSheet> {
  final _amountController = TextEditingController(text: '1,200.00');
  final _referenceController = TextEditingController(text: 'ORD-78190');
  final _descriptionController = TextEditingController();

  bool _isRefund = false;

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _descriptionController.dispose();
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
            color: Colors.white,
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
                      color: Color(0xFFD9DCE3),
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
                    icon: const Icon(Icons.close, color: AppColors.primaryDark),
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
                trailing: const Icon(Icons.keyboard_arrow_down_rounded),
                onTap: () {},
              ),
              const SizedBox(height: 10),
              _InfoField(
                label: l10n.settlementBeneficiaryLabel,
                value: l10n.settlementBeneficiaryAudit,
                trailing: const Icon(Icons.person_outline_rounded),
                onTap: () {},
              ),
              const SizedBox(height: 10),
              _LabeledInput(
                label: l10n.settlementAmountLabel,
                controller: _amountController,
                prefix: l10n.currencySar,
                keyboardType: TextInputType.number,
                isArabic: isArabic,
              ),
              const SizedBox(height: 10),
              _LabeledInput(
                label: l10n.settlementReferenceLabel,
                controller: _referenceController,
                prefix: '#',
                isArabic: isArabic,
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
                  color: const Color(0xFFF8FAFC),
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
                    _DetailRow(label: l10n.settlementDateLabel, value: '30/09/2026'),
                    const SizedBox(height: 8),
                    _DetailRow(
                      label: l10n.settlementStatusLabel,
                      value: l10n.settlementStatusUnderReview),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.settlementSubmitSuccess),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
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
          color: selected ? AppColors.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
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
  final VoidCallback? onTap;

  const _InfoField({
    required this.label,
    required this.value,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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

  const _LabeledInput({
    required this.label,
    required this.controller,
    this.prefix,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 1,
    this.hintText,
    this.isArabic = true,
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
        TextField(
          controller: controller,
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
              borderSide: const BorderSide(color: AppColors.primaryDark, width: 1),
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
