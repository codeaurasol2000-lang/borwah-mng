import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../widgets/finance_navigation.dart';

class EditMatrixScreen extends StatefulWidget {
  const EditMatrixScreen({super.key});

  @override
  State<EditMatrixScreen> createState() => _EditMatrixScreenState();
}

class _EditMatrixScreenState extends State<EditMatrixScreen> {
  static const _matrixStorageKey = 'finance_fee_matrix_v1';
  static const _matrixAuditStorageKey = 'finance_fee_matrix_audit_v1';
  static const _defaultMatrix = <String, dynamic>{
    'salesPercentage': 4.5,
    'settlementFee': 1.25,
    'addFixedFee': true,
    'deliveryCommission': 7.0,
    'deliveryFixed': 3.0,
    'deliveryCommissionType': 'percentage',
    'notifyAll': true,
  };

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _salesPercentageController =
      TextEditingController(text: '4.50');
  final TextEditingController _settlementFeeController =
      TextEditingController(text: '1.25');
  final TextEditingController _deliveryCommissionController =
      TextEditingController(text: '7.00');
  final TextEditingController _deliveryFixedController =
      TextEditingController(text: '3.00');

  bool _addFixedFee = true;
  bool _notifyAll = true;
  String _deliveryCommissionType = 'percentage'; // 'percentage' or 'fixed'
  DateTime? _lastUpdatedAt;
  bool _isLoadingSettings = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadMatrix();
    _salesPercentageController.addListener(() => setState(() {}));
    _settlementFeeController.addListener(() => setState(() {}));
    _deliveryCommissionController.addListener(() => setState(() {}));
    _deliveryFixedController.addListener(() => setState(() {}));
  }

  Future<void> _loadMatrix() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final rawMatrix = preferences.getString(_matrixStorageKey);
      final matrix = rawMatrix == null
          ? _defaultMatrix
          : Map<String, dynamic>.from(jsonDecode(rawMatrix) as Map);
      if (!mounted) return;
      setState(() {
        _salesPercentageController.text =
            _numberText(matrix['salesPercentage'], 4.5);
        _settlementFeeController.text =
            _numberText(matrix['settlementFee'], 1.25);
        _deliveryCommissionController.text =
            _numberText(matrix['deliveryCommission'], 7.0);
        _deliveryFixedController.text =
            _numberText(matrix['deliveryFixed'], 3.0);
        _addFixedFee = matrix['addFixedFee'] as bool? ?? true;
        _notifyAll = matrix['notifyAll'] as bool? ?? true;
        _deliveryCommissionType =
            matrix['deliveryCommissionType'] as String? ?? 'percentage';
        _lastUpdatedAt =
            DateTime.tryParse(matrix['updatedAt'] as String? ?? '');
        _isLoadingSettings = false;
      });
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance fee matrix',
        context: ErrorDescription('while loading saved matrix settings'),
      ));
      if (mounted) setState(() => _isLoadingSettings = false);
    }
  }

  String _numberText(Object? value, double fallback) {
    final number = value is num ? value.toDouble() : fallback;
    return number.toStringAsFixed(2);
  }

  double? _parseNumber(TextEditingController controller) =>
      double.tryParse(controller.text.trim().replaceAll(',', '.'));

  String? _validateValues(AppLocalizations l10n) {
    final sales = _parseNumber(_salesPercentageController);
    final settlement = _parseNumber(_settlementFeeController);
    final deliveryPercentage = _parseNumber(_deliveryCommissionController);
    final deliveryFixed = _parseNumber(_deliveryFixedController);
    if (sales == null || !sales.isFinite || sales < 2 || sales > 10) {
      return l10n.localeName.startsWith('ar')
          ? 'نسبة المبيعات يجب أن تكون بين 2% و10%.'
          : 'Sales rate must be between 2% and 10%.';
    }
    if (settlement == null ||
        !settlement.isFinite ||
        settlement < 0 ||
        settlement > 100) {
      return l10n.localeName.startsWith('ar')
          ? 'رسوم التسوية يجب أن تكون بين 0% و100%.'
          : 'Settlement fee must be between 0% and 100%.';
    }
    if (deliveryPercentage == null ||
        !deliveryPercentage.isFinite ||
        deliveryPercentage < 0 ||
        deliveryPercentage > 100) {
      return l10n.localeName.startsWith('ar')
          ? 'عمولة التوصيل يجب أن تكون بين 0% و100%.'
          : 'Delivery commission must be between 0% and 100%.';
    }
    if (deliveryFixed == null || !deliveryFixed.isFinite || deliveryFixed < 0) {
      return l10n.localeName.startsWith('ar')
          ? 'الرسم الثابت للتوصيل يجب ألا يكون سالبًا.'
          : 'The fixed delivery fee cannot be negative.';
    }
    if (_reasonController.text.trim().length < 10) {
      return l10n.localeName.startsWith('ar')
          ? 'اكتب سببًا واضحًا للتعديل (10 أحرف على الأقل).'
          : 'Enter a clear reason for the change (at least 10 characters).';
    }
    return null;
  }

  Map<String, dynamic> _currentMatrix({String? updatedAt}) => {
        'salesPercentage': _parseNumber(_salesPercentageController),
        'settlementFee': _parseNumber(_settlementFeeController),
        'addFixedFee': _addFixedFee,
        'deliveryCommission': _parseNumber(_deliveryCommissionController),
        'deliveryFixed': _parseNumber(_deliveryFixedController),
        'deliveryCommissionType': _deliveryCommissionType,
        'notifyAll': _notifyAll,
        if (updatedAt != null) 'updatedAt': updatedAt,
      };

  String _formatRate(Object? value, {bool currency = false}) {
    final amount = value is num ? value.toDouble() : 0;
    return currency
        ? '${amount.toStringAsFixed(2)} ${AppLocalizations.of(context)!.currencyEgy}'
        : '${amount.toStringAsFixed(2)}%';
  }

  Future<void> _saveMatrix() async {
    final l10n = AppLocalizations.of(context)!;
    final validationError = _validateValues(l10n);
    if (validationError != null) {
      AppSnackBar.showError(context, validationError);
      return;
    }

    late final SharedPreferences preferences;
    try {
      preferences = await SharedPreferences.getInstance();
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance fee matrix',
        context: ErrorDescription('while opening local matrix storage'),
      ));
      if (mounted) {
        AppSnackBar.showError(
          context,
          l10n.localeName.startsWith('ar')
              ? 'تعذر الوصول إلى مساحة حفظ المصفوفة.'
              : 'Could not access matrix storage.',
        );
      }
      return;
    }
    final previousRaw = preferences.getString(_matrixStorageKey);
    final previous = previousRaw == null
        ? _defaultMatrix
        : Map<String, dynamic>.from(jsonDecode(previousRaw) as Map);
    final current = _currentMatrix();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final isArabic = l10n.localeName.startsWith('ar');
        Widget changeRow(String label, Object? oldValue, Object? newValue,
            {bool currency = false}) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(child: Text(label)),
                Text(_formatRate(oldValue, currency: currency),
                    style: const TextStyle(color: AppColors.textSecondary)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward, size: 15),
                ),
                Text(_formatRate(newValue, currency: currency),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }

        Widget textChangeRow(String label, String oldValue, String newValue) =>
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(child: Text(label)),
                  Text(oldValue,
                      style: const TextStyle(color: AppColors.textSecondary)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward, size: 15),
                  ),
                  Text(newValue,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );

        return AlertDialog(
          title: Text(
              isArabic ? 'مراجعة تغييرات المصفوفة' : 'Review matrix changes'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                changeRow(isArabic ? 'نسبة المبيعات' : 'Sales rate',
                    previous['salesPercentage'], current['salesPercentage']),
                changeRow(isArabic ? 'رسوم التسوية' : 'Settlement fee',
                    previous['settlementFee'], current['settlementFee']),
                changeRow(
                    isArabic ? 'عمولة التوصيل' : 'Delivery commission',
                    previous['deliveryCommission'],
                    current['deliveryCommission']),
                changeRow(
                    isArabic ? 'الرسم الثابت للتوصيل' : 'Fixed delivery fee',
                    previous['deliveryFixed'],
                    current['deliveryFixed'],
                    currency: true),
                textChangeRow(
                  isArabic ? 'الرسم الثابت للتسوية' : 'Fixed settlement fee',
                  previous['addFixedFee'] == true
                      ? (isArabic ? 'مفعل' : 'On')
                      : (isArabic ? 'متوقف' : 'Off'),
                  _addFixedFee
                      ? (isArabic ? 'مفعل' : 'On')
                      : (isArabic ? 'متوقف' : 'Off'),
                ),
                textChangeRow(
                  isArabic ? 'طريقة عمولة التوصيل' : 'Delivery commission type',
                  previous['deliveryCommissionType'] == 'fixed'
                      ? (isArabic ? 'مبلغ ثابت' : 'Fixed amount')
                      : (isArabic ? 'نسبة مئوية' : 'Percentage'),
                  _deliveryCommissionType == 'fixed'
                      ? (isArabic ? 'مبلغ ثابت' : 'Fixed amount')
                      : (isArabic ? 'نسبة مئوية' : 'Percentage'),
                ),
                const SizedBox(height: 10),
                Text(
                  '${isArabic ? 'السبب' : 'Reason'}: ${_reasonController.text.trim()}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(isArabic ? 'مراجعة' : 'Go back'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(isArabic ? 'تأكيد الحفظ' : 'Confirm save'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isSaving = true);
    try {
      final now = DateTime.now();
      final savedMatrix = _currentMatrix(updatedAt: now.toIso8601String());
      final previousAuditLog =
          preferences.getStringList(_matrixAuditStorageKey);
      final auditLog = List<String>.of(previousAuditLog ?? const []);
      auditLog.insert(
        0,
        jsonEncode({
          'createdAt': now.toIso8601String(),
          'previous': previous,
          'updated': savedMatrix,
          'reason': _reasonController.text.trim(),
          'notifyAll': _notifyAll,
          'deviceLocal': true,
        }),
      );
      if (auditLog.length > 100) auditLog.removeRange(100, auditLog.length);
      final auditSaved = await preferences.setStringList(
        _matrixAuditStorageKey,
        auditLog,
      );
      if (!auditSaved) {
        throw StateError('The matrix audit entry could not be saved.');
      }
      final matrixSaved = await preferences.setString(
        _matrixStorageKey,
        jsonEncode(savedMatrix),
      );
      if (!matrixSaved) {
        if (previousAuditLog == null) {
          await preferences.remove(_matrixAuditStorageKey);
        } else {
          await preferences.setStringList(
            _matrixAuditStorageKey,
            previousAuditLog,
          );
        }
        throw StateError('The matrix or its audit entry could not be saved.');
      }
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        l10n.localeName.startsWith('ar')
            ? 'تم حفظ المصفوفة وسجل التعديل على هذا الجهاز.'
            : 'The matrix and its audit entry were saved on this device.',
      );
      Navigator.pop(context, savedMatrix);
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance fee matrix',
        context: ErrorDescription('while saving matrix settings and audit'),
      ));
      if (mounted) {
        AppSnackBar.showError(
          context,
          l10n.localeName.startsWith('ar')
              ? 'تعذر حفظ المصفوفة. لم يتم تأكيد التعديل.'
              : 'Could not save the matrix. The change was not confirmed.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _salesPercentageController.dispose();
    _settlementFeeController.dispose();
    _deliveryCommissionController.dispose();
    _deliveryFixedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final lastUpdatedText = _lastUpdatedAt == null
        ? (isArabic ? 'لم يتم حفظ تعديلات بعد' : 'No saved changes yet')
        : '${isArabic ? 'آخر حفظ' : 'Last saved'}: ${DateFormat.yMd(l10n.localeName).add_jm().format(_lastUpdatedAt!.toLocal())}';

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: FinancePageAppBar(
          title: l10n.matrixScreenTitle,
          subtitle: l10n.financialDepartment,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: _isLoadingSettings
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryDark),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryExtraDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.circle,
                                      color: AppColors.greenAccent, size: 8),
                                  const SizedBox(width: 4),
                                  Text(l10n.matrixLive,
                                      style: const TextStyle(
                                          color: AppColors.white, fontSize: 10)),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.verified_user_outlined,
                                          color: AppColors.white, size: 12),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(l10n.matrixCfoPermission,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 9)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.matrixCfoDescription,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 11,
                                height: 1.5,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lastUpdatedText,
                            style: const TextStyle(
                                color: AppColors.white60, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 1: General Sales Percentage
                    _buildCard(
                      icon: Icons.storefront_outlined,
                      title: l10n.matrixSalesRateTitle,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: AppColors.surfaceLight,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(l10n.matrixRateRange,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.primaryDark,
                                          fontWeight: FontWeight.bold),
                                      textDirection: ui.TextDirection.ltr),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(l10n.matrixAppliedRate,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('${_salesPercentageController.text}%',
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary)),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 100,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          const Text('%',
                                              style: TextStyle(
                                                  color: AppColors.primaryDark,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: TextField(
                                              controller:
                                                  _salesPercentageController,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(l10n.matrixTargetRate,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textSecondary)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(l10n.matrixMinimumValue,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontSize: 9,
                                              color: AppColors.textSecondary)),
                                    ),
                                    Expanded(
                                      child: Text(l10n.matrixReferenceValue,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 9,
                                              color: AppColors.textSecondary)),
                                    ),
                                    Expanded(
                                      child: Text(l10n.matrixMaximumValue,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              fontSize: 9,
                                              color: AppColors.textSecondary)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline,
                                  size: 14, color: AppColors.info),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l10n.matrixSalesNote,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.grey600,
                                      height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Wallet Settlement
                    _buildCard(
                      icon: Icons.account_balance_wallet_outlined,
                      title: l10n.matrixSettlementFeesTitle,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Row(
                                  children: [
                                    const Text('% ',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.primaryDark,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: TextField(
                                        controller: _settlementFeeController,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.primaryDark,
                                            fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.matrixCurrentSettlementRate,
                                  textAlign: isArabic
                                      ? TextAlign.left
                                      : TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('${_settlementFeeController.text}%',
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary)),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CupertinoSwitch(
                                  value: _addFixedFee,
                                  activeTrackColor: AppColors.primaryDark,
                                  onChanged: (val) {
                                    setState(() {
                                      _addFixedFee = val;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        l10n.matrixInstantFixedFee,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        l10n.matrixInstantFixedFeeNote,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: AppColors.grey600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.pie_chart_outline,
                                        size: 14, color: AppColors.blue700),
                                    const SizedBox(width: 4),
                                    Text(l10n.matrixCoverageDetails,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.blue700)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.matrixGatewayCoverage,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textPrimary),
                                  textDirection: isArabic
                                      ? ui.TextDirection.rtl
                                      : ui.TextDirection.ltr,
                                ),
                                const SizedBox(height: 2),
                                Text(l10n.matrixOperatingMargin,
                                    style: const TextStyle(
                                        fontSize: 9,
                                        color: AppColors.textPrimary)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.matrixSettlementNote,
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColors.grey600,
                                height: 1.4),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 3: Delivery Commission
                    _buildCard(
                      icon: Icons.local_shipping_outlined,
                      title: l10n.matrixDeliveryTitle,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: AppColors.blue50,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(l10n.matrixDeliveryFleet,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.blue800,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.matrixCurrentCommission,
                                  textAlign: isArabic
                                      ? TextAlign.left
                                      : TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                _deliveryCommissionType == 'percentage'
                                    ? '${_deliveryCommissionController.text}%'
                                    : '${_deliveryFixedController.text} ${l10n.currencyEgy}',
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary)),
                          ),
                          const SizedBox(height: 12),

                          // Options
                          GestureDetector(
                            onTap: () => setState(
                                () => _deliveryCommissionType = 'percentage'),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _deliveryCommissionType == 'percentage'
                                    ? AppColors.surfaceMuted
                                    : AppColors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color:
                                        _deliveryCommissionType == 'percentage'
                                            ? AppColors.cardBorder
                                            : AppColors.transparent),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: AppColors.grey300)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                _deliveryCommissionController,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                        const Text('%',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                              l10n.matrixDeliveryPercentage,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.textPrimary)),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                            _deliveryCommissionType ==
                                                    'percentage'
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_unchecked,
                                            color: _deliveryCommissionType ==
                                                    'percentage'
                                                ? AppColors.primaryDark
                                                : AppColors.grey,
                                            size: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(
                                () => _deliveryCommissionType = 'fixed'),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _deliveryCommissionType == 'fixed'
                                    ? AppColors.surfaceMuted
                                    : AppColors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: _deliveryCommissionType == 'fixed'
                                        ? AppColors.cardBorder
                                        : AppColors.transparent),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: AppColors.grey300)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                _deliveryFixedController,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                        Text(l10n.currencyEgy,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color:
                                                    AppColors.textSecondary)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                              l10n.matrixFixedPerShipment,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.textSecondary)),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                            _deliveryCommissionType == 'fixed'
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_unchecked,
                                            color: _deliveryCommissionType ==
                                                    'fixed'
                                                ? AppColors.primaryDark
                                                : AppColors.grey,
                                            size: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  size: 14, color: AppColors.info),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l10n.matrixDeliveryDescription,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.grey600,
                                      height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 4: Audit Reason
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.gavel,
                                  color: AppColors.danger, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(l10n.matrixAuditReasonTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(l10n.matrixAuditReasonPrompt,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _reasonController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: l10n.matrixDefaultReason,
                              filled: true,
                              fillColor: AppColors.surfaceLight,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _notifyAll = !_notifyAll),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: _notifyAll
                                        ? AppColors.primaryExtraDark
                                        : AppColors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: AppColors.primaryExtraDark),
                                  ),
                                  child: _notifyAll
                                      ? const Icon(Icons.check,
                                          size: 12, color: AppColors.white)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.matrixNotifyUsers,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textPrimary,
                                        height: 1.4),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              backgroundColor: AppColors.surfaceLight,
                              side: const BorderSide(color: AppColors.transparent),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.matrixCancel,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryExtraDark,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.drive_file_rename_outline,
                                size: 18),
                            onPressed: _isSaving ? null : _saveMatrix,
                            label: Text(
                                _isSaving
                                    ? (isArabic ? 'جارٍ الحفظ...' : 'Saving...')
                                    : (isArabic
                                        ? 'حفظ المصفوفة وتسجيل التعديل'
                                        : 'Save matrix and record change'),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock_outline,
                            size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                              isArabic
                                  ? 'تُحفظ المصفوفة وسجل التعديلات على هذا الجهاز فقط في النسخة الحالية.'
                                  : 'In this version, the matrix and its change history are stored on this device only.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 9, color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCard(
      {required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
