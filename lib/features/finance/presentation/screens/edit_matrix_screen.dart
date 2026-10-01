import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/finance_navigation.dart';

class EditMatrixScreen extends StatefulWidget {
  const EditMatrixScreen({super.key});

  @override
  State<EditMatrixScreen> createState() => _EditMatrixScreenState();
}

class _EditMatrixScreenState extends State<EditMatrixScreen> {
  final TextEditingController _reasonController = TextEditingController();
  bool _hasLocalizedReason = false;

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

  @override
  void initState() {
    super.initState();
    _salesPercentageController.addListener(() => setState(() {}));
    _settlementFeeController.addListener(() => setState(() {}));
    _deliveryCommissionController.addListener(() => setState(() {}));
    _deliveryFixedController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLocalizedReason) {
      _reasonController.text =
          AppLocalizations.of(context)!.matrixDefaultReason;
      _hasLocalizedReason = true;
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

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: FinancePageAppBar(
          title: l10n.matrixScreenTitle,
          subtitle: l10n.financialDepartment,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                color: Colors.greenAccent, size: 8),
                            const SizedBox(width: 4),
                            Text(l10n.matrixLive,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.verified_user_outlined,
                                  color: Colors.white, size: 12),
                              SizedBox(width: 6),
                              Text(l10n.matrixCfoPermission,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 9)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.matrixCfoDescription,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          height: 1.5,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.matrixLastUpdated,
                      style: TextStyle(color: Colors.white60, fontSize: 9),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(l10n.matrixRateRange,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.bold),
                              textDirection: TextDirection.ltr),
                        ),
                        Text(l10n.matrixAppliedRate,
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textSecondary)),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    const Text('%',
                                        style: TextStyle(
                                            color: AppColors.primaryDark,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: _salesPercentageController,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
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
                              Text(l10n.matrixTargetRate,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(l10n.matrixMinimumValue,
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textSecondary)),
                              Text(l10n.matrixReferenceValue,
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textSecondary)),
                              Text(l10n.matrixMaximumValue,
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textSecondary)),
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
                                color: Colors.grey.shade600,
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
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
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
                        Text(l10n.matrixCurrentSettlementRate,
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textSecondary)),
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
                            activeColor: AppColors.primaryDark,
                            onChanged: (val) {
                              setState(() {
                                _addFixedFee = val;
                              });
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(l10n.matrixInstantFixedFee,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text(l10n.matrixInstantFixedFeeNote,
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey.shade600)),
                            ],
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
                                  size: 14, color: Colors.blue.shade700),
                              const SizedBox(width: 4),
                              Text(l10n.matrixCoverageDetails,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.matrixGatewayCoverage,
                            style: const TextStyle(
                                fontSize: 9, color: AppColors.textPrimary),
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                          const SizedBox(height: 2),
                          Text(l10n.matrixOperatingMargin,
                              style: TextStyle(
                                  fontSize: 9, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.matrixSettlementNote,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
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
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(l10n.matrixDeliveryFleet,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Text(l10n.matrixCurrentCommission,
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          _deliveryCommissionType == 'percentage'
                              ? '${_deliveryCommissionController.text}%'
                              : '${_deliveryFixedController.text} ${l10n.currencySar}',
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
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: _deliveryCommissionType == 'percentage'
                                  ? AppColors.cardBorder
                                  : Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 80,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                      Border.all(color: Colors.grey.shade300)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _deliveryCommissionController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
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
                            Row(
                              children: [
                                Text(l10n.matrixDeliveryPercentage,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary)),
                                const SizedBox(width: 8),
                                Icon(
                                    _deliveryCommissionType == 'percentage'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color:
                                        _deliveryCommissionType == 'percentage'
                                            ? AppColors.primaryDark
                                            : Colors.grey,
                                    size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _deliveryCommissionType = 'fixed'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _deliveryCommissionType == 'fixed'
                              ? AppColors.surfaceMuted
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: _deliveryCommissionType == 'fixed'
                                  ? AppColors.cardBorder
                                  : Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 80,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                      Border.all(color: Colors.grey.shade300)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _deliveryFixedController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
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
                                  Text(l10n.currencySar,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(l10n.matrixFixedPerShipment,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary)),
                                const SizedBox(width: 8),
                                Icon(
                                    _deliveryCommissionType == 'fixed'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: _deliveryCommissionType == 'fixed'
                                        ? AppColors.primaryDark
                                        : Colors.grey,
                                    size: 20),
                              ],
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
                                color: Colors.grey.shade600,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.gavel, color: AppColors.danger, size: 18),
                        SizedBox(width: 8),
                        Text(l10n.matrixAuditReasonTitle,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.matrixAuditReasonPrompt,
                        style: TextStyle(
                            fontSize: 10, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _reasonController,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.5),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() => _notifyAll = !_notifyAll),
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
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  Border.all(color: AppColors.primaryExtraDark),
                            ),
                            child: _notifyAll
                                ? const Icon(Icons.check,
                                    size: 12, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.matrixNotifyUsers,
                              style: TextStyle(
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
                        side: const BorderSide(color: Colors.transparent),
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
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon:
                          const Icon(Icons.drive_file_rename_outline, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.matrixSaveSuccess)));
                        Navigator.pop(context);
                      },
                      label: Text(l10n.matrixSaveAndSend,
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
                  Icon(Icons.lock_outline,
                      size: 12, color: AppColors.textSecondary),
                  SizedBox(width: 6),
                  Text(l10n.matrixAuditTrailNotice,
                      style: TextStyle(
                          fontSize: 9, color: AppColors.textSecondary)),
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
        color: Colors.white,
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
