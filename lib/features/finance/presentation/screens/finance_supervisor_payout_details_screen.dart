import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/datasources/finance_supervisor_payout_details_store.dart';
import '../widgets/finance_navigation.dart';

class FinanceSupervisorPayoutDetailsScreen extends StatefulWidget {
  const FinanceSupervisorPayoutDetailsScreen({super.key});

  @override
  State<FinanceSupervisorPayoutDetailsScreen> createState() =>
      _FinanceSupervisorPayoutDetailsScreenState();
}

class _FinanceSupervisorPayoutDetailsScreenState
    extends State<FinanceSupervisorPayoutDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ibanController = TextEditingController();
  final _store = FinanceSupervisorPayoutDetailsStore();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  @override
  void dispose() {
    _accountHolderController.dispose();
    _bankNameController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  Future<void> _loadDetails() async {
    try {
      final details = await _store.load();
      if (!mounted) return;
      _accountHolderController.text = details.accountHolderName;
      _bankNameController.text = details.bankName;
      _ibanController.text = details.iban;
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance supervisor payout details',
        context: ErrorDescription('while loading personal payout details'),
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await _store.save(
        FinanceSupervisorPayoutDetails(
          accountHolderName: _accountHolderController.text,
          bankName: _bankNameController.text,
          iban: _ibanController.text,
        ),
      );
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        AppLocalizations.of(context)!.localeName.startsWith('ar')
            ? 'تم حفظ بيانات السحب الشخصية على هذا الجهاز.'
            : 'Personal payout details saved on this device.',
      );
      Navigator.pop(context, true);
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance supervisor payout details',
        context: ErrorDescription('while saving personal payout details'),
      ));
      if (mounted) {
        AppSnackBar.showError(
          context,
          AppLocalizations.of(context)!.localeName.startsWith('ar')
              ? 'تعذر حفظ بيانات السحب الشخصية.'
              : 'Could not save personal payout details.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: FinancePageAppBar(
          title: isArabic ? 'بيانات السحب الشخصية' : 'Personal payout details',
          subtitle: isArabic
              ? 'محفظة مستحقات المشرف المالي'
              : 'Finance supervisor dues wallet',
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryDark),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.person_pin_circle_outlined,
                              color: AppColors.primaryDark),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isArabic
                                  ? 'هذه البيانات تخص حساب السحب الشخصي للمشرف المالي فقط، ولا تغيّر الحسابات البنكية أو محافظ التطبيق العامة.'
                                  : 'These details belong only to the finance supervisor’s personal payout account. They do not change the app’s bank accounts or shared wallets.',
                              style: const TextStyle(fontSize: 12, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _accountHolderController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: isArabic
                            ? 'اسم صاحب الحساب'
                            : 'Account holder name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? (isArabic
                                  ? 'اسم صاحب الحساب مطلوب.'
                                  : 'Account holder name is required.')
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _bankNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'اسم البنك' : 'Bank name',
                        prefixIcon: const Icon(Icons.account_balance_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? (isArabic
                                  ? 'اسم البنك مطلوب.'
                                  : 'Bank name is required.')
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _ibanController,
                      textDirection: TextDirection.ltr,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9 ]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'IBAN',
                        prefixIcon: const Icon(Icons.credit_card_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        final iban =
                            (value ?? '').replaceAll(RegExp(r'\s+'), '');
                        if (!RegExp(r'^[A-Z]{2}[A-Z0-9]{13,32}$',
                                caseSensitive: false)
                            .hasMatch(iban)) {
                          return isArabic
                              ? 'أدخل رقم IBAN صحيحًا (من 15 إلى 34 خانة).'
                              : 'Enter a valid IBAN (15 to 34 characters).';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(
                        _isSaving
                            ? (isArabic ? 'جارٍ الحفظ...' : 'Saving...')
                            : (isArabic
                                ? 'حفظ بيانات السحب'
                                : 'Save payout details'),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryExtraDark,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
