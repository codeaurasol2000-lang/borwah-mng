import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/usecases/get_supervisor_withdrawals_usecase.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/finance_navigation.dart';

class SupervisorWithdrawalsScreen extends StatefulWidget {
  const SupervisorWithdrawalsScreen({super.key});

  @override
  State<SupervisorWithdrawalsScreen> createState() =>
      _SupervisorWithdrawalsScreenState();
}

class _SupervisorWithdrawalsScreenState
    extends State<SupervisorWithdrawalsScreen> {
  List<WithdrawalRequestEntity> _requests = [];
  bool _isLoading = true;
  String _selectedFilter = 'الكل';

  List<WithdrawalRequestEntity> get _filteredRequests {
    if (_selectedFilter == 'المشرفين') {
      return _requests
          .where((r) => r.beneficiaryType == BeneficiaryType.supervisor)
          .toList();
    } else if (_selectedFilter == 'مقدمي الخدمة') {
      return _requests
          .where((r) => r.beneficiaryType == BeneficiaryType.serviceProvider)
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
    if (type == 'المشرفين')
      return _requests
          .where((r) => r.beneficiaryType == BeneficiaryType.supervisor)
          .length;
    if (type == 'مقدمي الخدمة')
      return _requests
          .where((r) => r.beneficiaryType == BeneficiaryType.serviceProvider)
          .length;
    return _requests.length;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await sl<GetSupervisorWithdrawalsUseCase>()();
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
      textDirection:
          l10n.localeName.startsWith('ar') ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: FinancePageAppBar(
          title: l10n.navWithdrawalOrders,
          subtitle: l10n.financialManagementSubtitle,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryDark))
            : Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 140),
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
                              Text(l10n.supervisorWithdrawalsHeaderSubtitle,
                                  style: const TextStyle(
                                      color: AppColors.primaryDark,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              Icon(Icons.shield,
                                  color: Colors.blue.shade700, size: 14),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 2. Titles
                      Text(
                        l10n.supervisorWithdrawalsHeaderTitle,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryDark,
                            height: 1.3),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.supervisorWithdrawalsHeaderSubtitle,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),

                      // 3. Metric Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricMiniCard(
                              title: l10n.awaitingApprovalTab,
                              count: '$_pendingCount',
                              sub:
                                  '${CurrencyFormatter.format(_totalPendingAmount, includeCurrency: false)} ${l10n.currencySar}',
                              icon: Icons.pending_actions,
                              color: AppColors.primaryDark,
                              countColor: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricMiniCard(
                              title: l10n.underRegulatoryHold,
                              count: '$_frozenCount',
                              sub: l10n.temporarilySuspendedBadge,
                              icon: Icons.playlist_remove,
                              color: AppColors.danger,
                              countColor: AppColors.danger,
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
                          _buildFilterChip('المشرفين',
                              icon: Icons.admin_panel_settings),
                          _buildFilterChip('مقدمي الخدمة',
                              icon: Icons.build_circle),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.primaryDark
                                      .withValues(alpha: 0.3),
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
                                            color: Colors.white70,
                                            fontSize: 10)),
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
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.shield_outlined,
                                  color: Colors.blue.shade700, size: 24),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l10n.samaComplianceNotice,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryDark)),
                                  ],
                                ),
                              ),
                              const Text('v3.4.1',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.blue)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFilterChip(String filterType, {IconData? icon}) {
    final l10n = AppLocalizations.of(context)!;
    bool isSelected = _selectedFilter == filterType;
    int count = _countFor(filterType);
    final localizedFilter = switch (filterType) {
      'المشرفين' => l10n.platformSupervisorsTab,
      'مقدمي الخدمة' => l10n.serviceProviders,
      _ => l10n.allTab,
    };
    String label = count > 0 ? '$localizedFilter ($count)' : localizedFilter;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterType),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.primaryDark : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon,
                  size: 14, color: isSelected ? Colors.white : Colors.black54),
            if (icon != null) const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontSize: 11,
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
      required Color color,
      required Color countColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: color == AppColors.danger
                ? AppColors.dangerLight
                : AppColors.cardBorder),
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
                  style: TextStyle(
                      fontSize: 11,
                      color: color == AppColors.danger
                          ? AppColors.danger
                          : Colors.blue.shade700,
                      fontWeight: FontWeight.bold)),
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
                        color: countColor)),
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
        : (isReady ? Colors.blue.shade100 : const Color(0xFFF1F5F9));

    // Icon based on type
    IconData headerIcon = Icons.verified_user;
    if (isDanger)
      headerIcon = Icons.gavel;
    else if (isReady)
      headerIcon = Icons.build_circle;
    else
      headerIcon = Icons.admin_panel_settings;

    // Gross Amount Title
    String grossTitle = l10n.totalFeesAndCommissions;
    if (isDanger)
      grossTitle = l10n.grossClaimedAmount;
    else if (isReady) grossTitle = l10n.grossAmount;

    // Fee Title
    String feeTitle = '';
    if (req.platformFeePercentage > 0) {
      feeTitle = '${l10n.platformFee} (${req.platformFeePercentage}%):';
      if (isDanger)
        feeTitle =
            '${l10n.deductedPlatformFee} (${req.platformFeePercentage}%):';
    }

    // Net Title
    String netTitle = l10n.netAmountDueForDisbursement;
    if (isDanger) netTitle = l10n.netHeldAmount;

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
                  headerIcon,
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
                          child: Row(
                            children: [
                              Flexible(
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
                              if (!isDanger && !isReady) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified,
                                    color: AppColors.primaryDark, size: 14),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      req.beneficiaryRole,
                      style: TextStyle(
                          fontSize: 10,
                          color: isDanger
                              ? AppColors.danger
                              : Colors.grey.shade600,
                          fontWeight:
                              isDanger ? FontWeight.bold : FontWeight.normal),
                    ),
                    Text(
                      req.requestNumber,
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade500),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDanger
                      ? AppColors.dangerLight
                      : (isReady
                          ? Colors.blue.shade50
                          : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isReady)
                      const Icon(Icons.flash_on,
                          color: AppColors.primaryDark, size: 12),
                    if (isDanger)
                      const Icon(Icons.warning_amber,
                          color: AppColors.danger, size: 12),
                    if (!isReady && !isDanger)
                      const Icon(Icons.circle,
                          color: AppColors.primaryDark, size: 8),
                    const SizedBox(width: 4),
                    Text(
                      isDanger
                          ? l10n.temporarilySuspendedBadge
                          : (isReady
                              ? l10n.readyForInstantDisbursement
                              : l10n.awaitingDisbursementBadge),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isDanger
                              ? AppColors.danger
                              : (isReady
                                  ? AppColors.primaryDark
                                  : Colors.black87)),
                    ),
                  ],
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
                        child: Text(grossTitle,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade700))),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            '${CurrencyFormatter.format(req.grossAmount, includeCurrency: false)} ${l10n.currencySar}',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87))),
                  ],
                ),
                if (req.platformFeePercentage > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.remove_circle_outline,
                                color: AppColors.danger, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                                child: Text(feeTitle,
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.danger),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
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
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: AppColors.cardBorder),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        netTitle,
                        style: TextStyle(
                            fontSize: 11,
                            color: isDanger ? AppColors.danger : Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                                CurrencyFormatter.format(req.netAmount,
                                    includeCurrency: false),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87))),
                        const SizedBox(width: 4),
                        Text(l10n.currencySar,
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                        isDanger
                            ? Icons.shield_outlined
                            : Icons.account_balance,
                        size: 14,
                        color:
                            isDanger ? AppColors.danger : Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        req.bankName,
                        style: TextStyle(
                            fontSize: 10,
                            color: isDanger
                                ? AppColors.danger
                                : Colors.grey.shade700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (req.transferMethod != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.bolt,
                          size: 14, color: AppColors.primaryDark),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          req.transferMethod!,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.primaryDark),
                        ),
                      ),
                    ],
                  ),
                ],
                if (req.iban.isNotEmpty && !isDanger) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.verified,
                          size: 14, color: AppColors.primaryDark),
                      const SizedBox(width: 6),
                      Text(req.iban,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade700,
                              fontWeight: req.iban.contains('موثق')
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (req.sourceOfFunds != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                      req.sourceOfFunds!.contains('تفاصيل') ||
                              req.sourceOfFunds!.contains('أجور')
                          ? Icons.check_circle_outline
                          : Icons.description_outlined,
                      color: Colors.blue.shade700,
                      size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          req.sourceOfFunds!.contains('أجور')
                              ? l10n.fieldCompletionDetails
                              : l10n.disbursementSource,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          req.sourceOfFunds!,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade800,
                              height: 1.4,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (req.auditCheckResult != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified, color: Colors.blue.shade700, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.complianceAndAuditResult,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark)),
                        const SizedBox(height: 4),
                        Text(req.auditCheckResult!,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue.shade800,
                                height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (req.alertNotice != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDanger
                    ? AppColors.dangerLight.withValues(alpha: 0.3)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDanger ? AppColors.danger : Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(isDanger ? Icons.warning_amber_rounded : Icons.bolt,
                      color: isDanger ? AppColors.danger : Colors.grey.shade700,
                      size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isDanger)
                          Text(l10n.regulatoryNoticeFromServicesSupervisor,
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
                                  ? AppColors.danger
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
                  backgroundColor: AppColors.primaryDark,
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
                  backgroundColor: AppColors.dangerLight.withValues(alpha: 0.3),
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
