import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../finance/domain/entities/withdrawal_request_entity.dart';
import '../../finance/domain/usecases/get_merchant_withdrawals_usecase.dart';
import '../../../l10n/app_localizations.dart';

class MerchantWithdrawalsScreen extends StatefulWidget {
  const MerchantWithdrawalsScreen({super.key});

  @override
  State<MerchantWithdrawalsScreen> createState() =>
      _MerchantWithdrawalsScreenState();
}

class _MerchantWithdrawalsScreenState extends State<MerchantWithdrawalsScreen> {
  List<WithdrawalRequestEntity> _requests = [];
  bool _isLoading = true;
  String _selectedFilter = 'الكل'; // تغيير الفلتر الافتراضي

  // دوال الفلترة والحساب الديناميكي
  List<WithdrawalRequestEntity> get _filteredRequests {
    if (_selectedFilter == 'التجار') {
      return _requests
          .where((r) => r.beneficiaryType == BeneficiaryType.merchant)
          .toList();
    } else if (_selectedFilter == 'المستخدمين') {
      return _requests
          .where((r) => r.beneficiaryType != BeneficiaryType.merchant)
          .toList();
    }
    return _requests; // الكل
  }

  int get _pendingCount => _filteredRequests
      .where((r) => r.status != RequestStatus.underInvestigation)
      .length;
  int get _frozenCount => _filteredRequests
      .where((r) => r.status == RequestStatus.underInvestigation)
      .length;

  double get _totalPendingAmount {
    return _filteredRequests
        .where((r) => r.status != RequestStatus.underInvestigation)
        .fold(0.0, (sum, req) => sum + req.netAmount);
  }

  int _countFor(String type) {
    if (type == 'التجار')
      return _requests
          .where((r) => r.beneficiaryType == BeneficiaryType.merchant)
          .length;
    if (type == 'المستخدمين')
      return _requests
          .where((r) => r.beneficiaryType != BeneficiaryType.merchant)
          .length;
    return _requests.length;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await sl<GetMerchantWithdrawalsUseCase>()();
    result.fold(
      (failure) => setState(() => _isLoading = false),
      (data) => setState(() {
        _requests = data;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          scrolledUnderElevation: 0,
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.navWithdrawalOrders,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Text(l10n.financialManagementSubtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryDark))
            : Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 100),
                    children: [
                      // 1. Tag
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.bankingAndCashSurveillanceGateway,
                                  style: const TextStyle(
                                      color: AppColors.primaryDark,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              Icon(Icons.verified,
                                  color: Colors.blue.shade700, size: 14),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 2. Titles
                      Text(
                        l10n.merchantWithdrawalsHeaderTitle,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryDark,
                            height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.merchantWithdrawalsHeaderSubtitle,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // 3. Metric Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricMiniCard(
                              title: l10n.pendingRequests,
                              count: '$_pendingCount',
                              sub:
                                  '${CurrencyFormatter.format(_totalPendingAmount, includeCurrency: false)} ${l10n.currencySar}',
                              icon: Icons.pending_actions,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricMiniCard(
                              title: l10n.underRegulatoryHold,
                              count: '$_frozenCount',
                              sub: l10n.regulatoryFreeze,
                              icon: Icons.gavel,
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 4. Filters
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterChip('الكل'),
                          _buildFilterChip('التجار'),
                          _buildFilterChip('المستخدمين'),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 5. List of requests
                      ..._filteredRequests
                          .map((req) => _buildWithdrawalCard(context, req)),
                    ],
                  ),

                  // 6. Bottom Sticky Bar
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  AppColors.primaryDark.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.calculate,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(l10n.totalAwaitingApproval,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 10)),
                                Text(
                                    '${CurrencyFormatter.format(_totalPendingAmount, includeCurrency: false)} ${l10n.currencySar}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.remainingForReview,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                      height: 1.2),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 2),
                              Text('$_pendingCount ${l10n.ordersUnit}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFilterChip(String filterType) {
    final l10n = AppLocalizations.of(context)!;
    bool isSelected = _selectedFilter == filterType;
    int count = _countFor(filterType);
    final localizedFilter = switch (filterType) {
      'التجار' => l10n.merchantsTab,
      'المستخدمين' => l10n.usersTab,
      _ => l10n.allTab,
    };
    String label = count > 0 ? '$localizedFilter ($count)' : localizedFilter;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterType),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(Icons.circle, size: 8, color: Colors.blueAccent),
            if (isSelected) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricMiniCard(
      {required String title,
      required String count,
      required String sub,
      required IconData icon,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Text(title,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(count,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color)),
                Text(sub,
                    style: TextStyle(
                        fontSize: 10,
                        color: color == AppColors.danger
                            ? AppColors.danger
                            : Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalCard(
      BuildContext context, WithdrawalRequestEntity req) {
    final l10n = AppLocalizations.of(context)!;

    bool isDanger = req.status == RequestStatus.underInvestigation;
    bool isReady = req.isInstantTransferReady;

    Color mainColor = isDanger ? AppColors.danger : AppColors.primaryDark;
    Color lightBgColor = isDanger
        ? AppColors.dangerLight
        : (isReady ? Colors.blue.shade50 : const Color(0xFFF1F5F9));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDanger
                ? AppColors.danger.withValues(alpha: 0.5)
                : AppColors.cardBorder,
            width: isDanger ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: lightBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDanger
                      ? Icons.warning_amber_rounded
                      : (isReady ? Icons.manage_accounts : Icons.store),
                  color: mainColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            req.beneficiaryName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDanger
                                ? AppColors.dangerLight
                                : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            req.requestNumber,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDanger
                                    ? AppColors.danger
                                    : Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (!isDanger && !isReady)
                          const Icon(Icons.verified,
                              color: AppColors.primaryDark, size: 14),
                        if (!isDanger && !isReady) const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            req.beneficiaryRole,
                            style: TextStyle(
                                fontSize: 11,
                                color: isDanger
                                    ? AppColors.danger
                                    : Colors.grey.shade700,
                                fontWeight: isDanger
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isDanger)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isReady
                        ? Colors.blue.shade100
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isReady
                        ? l10n.readyForInstantDisbursement
                        : l10n.underReviewStatus,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color:
                            isReady ? AppColors.primaryDark : Colors.black87),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Amount Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                            isDanger ? l10n.grossHeldAmount : l10n.grossAmount,
                            style: TextStyle(
                                fontSize: 11,
                                color: isDanger
                                    ? AppColors.danger
                                    : Colors.grey.shade700))),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            '${CurrencyFormatter.format(req.grossAmount, includeCurrency: false)} ${l10n.currencySar}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDanger
                                    ? AppColors.danger
                                    : Colors.black87))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                            isDanger
                                ? l10n.estimatedPlatformFee
                                : l10n.platformFee,
                            style: TextStyle(
                                fontSize: 11,
                                color: isDanger
                                    ? AppColors.danger
                                    : Colors.grey.shade700))),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            '- ${CurrencyFormatter.format(req.platformFeeAmount, includeCurrency: false)} ${l10n.currencySar}',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.danger))),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.cardBorder),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDanger
                                ? l10n.netFrozenAmount
                                : (isReady
                                    ? l10n.netAmountDueForDisbursement
                                    : l10n.netTransferredAmount),
                            style: TextStyle(
                                fontSize: 11,
                                color: isDanger
                                    ? AppColors.danger
                                    : AppColors.primaryDark,
                                fontWeight: FontWeight.bold),
                          ),
                          if (!isDanger) const SizedBox(height: 4),
                          if (!isDanger)
                            Row(
                              children: [
                                Icon(
                                    isReady
                                        ? Icons.flash_on
                                        : Icons.account_balance_wallet,
                                    size: 12,
                                    color: AppColors.primaryDark),
                                const SizedBox(width: 4),
                                Expanded(
                                    child: Text(
                                        isReady
                                            ? '${l10n.receivingBank}\n${req.bankName}'
                                            : '${l10n.disbursementSource}\n${l10n.readyForInstantBankingTransfer}',
                                        style: const TextStyle(
                                            fontSize: 9, color: Colors.grey),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                                CurrencyFormatter.format(req.netAmount,
                                    includeCurrency: false),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: isDanger
                                        ? AppColors.danger
                                        : AppColors.primaryDark))),
                        const SizedBox(width: 4),
                        Text(l10n.currencySar,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDanger
                                    ? AppColors.danger
                                    : AppColors.primaryDark)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Bank Info or Alerts
          if (req.bankName.isNotEmpty && !isReady)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_balance,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(l10n.receivingBank,
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                            const SizedBox(width: 6),
                            Expanded(
                                child: Text(req.bankName,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.credit_card,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(l10n.ibanNumber,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    height: 1.2)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(req.iban,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.right),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('${l10n.submissionDate} ${req.dateText}',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          if (req.auditCheckResult != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.blue.shade700, size: 16),
                      const SizedBox(width: 6),
                      Text(l10n.automatedTaxAuditResult,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(req.auditCheckResult!,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue.shade800,
                          height: 1.4)),
                ],
              ),
            ),
          ],

          if (req.alertNotice != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDanger ? Colors.white : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDanger ? AppColors.danger : Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(isDanger ? Icons.gavel : Icons.bolt,
                      color: isDanger ? AppColors.danger : Colors.grey.shade700,
                      size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isDanger)
                          Text(l10n.regulatoryNoticeFromSupervisor,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.danger)),
                        if (isDanger) const SizedBox(height: 4),
                        Text(
                          req.alertNotice!,
                          style: TextStyle(
                              fontSize: 10,
                              color: isDanger
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade700,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Action Buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDanger ? AppColors.primaryDark : AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: Icon(
                    isDanger
                        ? Icons.folder_off_outlined
                        : Icons.check_circle_outline,
                    size: 18),
                onPressed: () {},
                label: Text(
                  isDanger
                      ? l10n.rejectAndNotifyCustomer
                      : (isReady
                          ? l10n.approveAndIssueBankOrder
                          : l10n.approveAndSendToAdmin),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: BorderSide(
                      color:
                          isDanger ? AppColors.danger : AppColors.dangerLight),
                  backgroundColor: isDanger
                      ? AppColors.dangerLight.withValues(alpha: 0.3)
                      : AppColors.dangerLight.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(
                    isDanger ? Icons.cancel_outlined : Icons.lock_outline,
                    size: 18),
                onPressed: () {},
                label: Text(
                  isDanger ? l10n.freezeRequest : l10n.freezeRequestTemporarily,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
