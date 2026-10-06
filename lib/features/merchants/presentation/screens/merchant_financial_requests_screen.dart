import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

enum _FinancialRequestType { salesProfit, balanceWithdrawal, packageFees }

class _FinancialRequest {
  final String id;
  final _FinancialRequestType type;
  final String merchantName;
  final String title;
  final String amount;
  final String date;
  final String status;
  final String note;
  final IconData icon;
  final bool isPending;
  final bool isRestricted;

  const _FinancialRequest({
    required this.id,
    required this.type,
    required this.merchantName,
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.note,
    required this.icon,
    this.isPending = false,
    this.isRestricted = false,
  });
}

class MerchantFinancialRequestsScreen extends StatefulWidget {
  const MerchantFinancialRequestsScreen({super.key});

  @override
  State<MerchantFinancialRequestsScreen> createState() =>
      _MerchantFinancialRequestsScreenState();
}

class _MerchantFinancialRequestsScreenState
    extends State<MerchantFinancialRequestsScreen> {
  _FinancialRequestType? _selectedType;

  List<_FinancialRequest> _requests(AppLocalizations l10n) => [
        _FinancialRequest(
          id: 'FIN-3021',
          type: _FinancialRequestType.salesProfit,
          merchantName: l10n.finRequestCarMerchant,
          title: l10n.finRequestCarTitle,
          amount: l10n.finRequestCarAmount,
          date: l10n.finRequestTodayTime,
          status: l10n.finRequestUnderReview,
          note: l10n.finRequestBankVerified,
          icon: Icons.directions_car_outlined,
          isPending: true,
        ),
        _FinancialRequest(
          id: 'FIN-3016',
          type: _FinancialRequestType.packageFees,
          merchantName: l10n.finRequestPackageMerchant,
          title: l10n.finRequestPackageTitle,
          amount: l10n.finRequestPackageAmount,
          date: l10n.finRequestYesterdayTime,
          status: l10n.finRequestCompleted,
          note: l10n.finRequestApprovedByFinance,
          icon: Icons.devices_outlined,
        ),
        _FinancialRequest(
          id: 'FIN-2998',
          type: _FinancialRequestType.balanceWithdrawal,
          merchantName: l10n.finRequestJewelryMerchant,
          title: l10n.finRequestWithdrawalTitle,
          amount: l10n.finRequestWithdrawalAmount,
          date: l10n.finRequestOlderTime,
          status: l10n.finRequestAwaitingManager,
          note: l10n.finRequestSalesMatched,
          icon: Icons.diamond_outlined,
          isPending: true,
          isRestricted: true,
        ),
      ];

  List<_FinancialRequest> _visibleRequests(AppLocalizations l10n) {
    final requests = _requests(l10n);
    if (_selectedType == null) return requests;
    return requests.where((request) => request.type == _selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final requests = _visibleRequests(l10n);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _buildRestrictionBanner(l10n),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.account_balance_wallet_outlined,
                  title: l10n.finRequestMerchantProceeds,
                  amount: l10n.finRequestTotalProceeds,
                  note: l10n.finRequestProceedsNote,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.hourglass_top,
                  title: l10n.finRequestUnderReview,
                  amount: '3',
                  note: l10n.finRequestReviewQueue,
                  isCount: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.finRequestHistoryTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _badge('3', const Color(0xFFE8EAED), AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                l10n.finRequestUpdatedJustNow,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                ),
              ),
              const Icon(Icons.history, size: 13, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 10),
          _buildFilters(l10n),
          const SizedBox(height: 14),
          if (requests.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Text(
                l10n.finRequestNoResults,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ...requests.map((request) => _buildRequestCard(l10n, request)),
          const SizedBox(height: 2),
          _buildPolicyNote(l10n),
        ],
      ),
    );
  }

  Widget _buildRestrictionBanner(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E9EB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(9),
            ),
            child:
                const Icon(Icons.lock_outline, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.finRequestReadOnlyNotice,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String amount,
    required String note,
    bool isCount = false,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: const Color(0xFFF0F2F4),
                child: Icon(icon, size: 14, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            amount,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: isCount ? AppColors.textSecondary : AppColors.info,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations l10n) {
    final filters = <({String label, _FinancialRequestType? type})>[
      (label: l10n.finRequestAllFilter, type: null),
      (
        label: l10n.finRequestSalesFilter,
        type: _FinancialRequestType.salesProfit
      ),
      (
        label: l10n.finRequestWithdrawalFilter,
        type: _FinancialRequestType.balanceWithdrawal
      ),
      (
        label: l10n.finRequestPackageFilter,
        type: _FinancialRequestType.packageFees
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < filters.length; index++) ...[
            if (index > 0) const SizedBox(width: 7),
            ChoiceChip(
              label: Text(filters[index].label),
              selected: _selectedType == filters[index].type,
              onSelected: (_) =>
                  setState(() => _selectedType = filters[index].type),
              showCheckmark: false,
              selectedColor: AppColors.primaryDark,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: _selectedType == filters[index].type
                    ? Colors.white
                    : AppColors.info,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: _selectedType == filters[index].type
                    ? AppColors.primaryDark
                    : AppColors.cardBorder,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    AppLocalizations l10n,
    _FinancialRequest request,
  ) {
    final statusColor =
        request.isPending ? const Color(0xFF68717A) : AppColors.info;
    final statusBackground =
        request.isPending ? const Color(0xFFE7E9EB) : const Color(0xFFD8E6FF);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _badge(
                  request.status,
                  statusBackground,
                  statusColor,
                  icon: request.isPending
                      ? Icons.schedule
                      : Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                request.date,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.circle, size: 4, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(request.icon, color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.merchantName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            request.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.amount,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    l10n.finRequestCurrency,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    request.note,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  request.isPending
                      ? Icons.verified_user_outlined
                      : Icons.person_pin_outlined,
                  size: 14,
                  color: AppColors.info,
                ),
              ],
            ),
          ),
          if (request.isRestricted) ...[
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                l10n.finRequestRestrictedStatus,
                style: const TextStyle(
                  color: AppColors.info,
                  fontSize: 9,
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: request.isPending ? 1 : 2,
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.lock_outline, size: 14),
                  label: Text(
                    l10n.finRequestSendToFinance,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F1F3),
                    disabledForegroundColor: AppColors.textSecondary,
                    disabledBackgroundColor: const Color(0xFFF0F1F3),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: request.isPending ? 1 : 2,
                child: ElevatedButton.icon(
                  onPressed: () => _showDetails(l10n, request),
                  icon: const Icon(Icons.receipt_long_outlined, size: 14),
                  label: Text(
                    l10n.finRequestViewDetails,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: AppColors.primaryDark,
                    backgroundColor: const Color(0xFFF0F1F3),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyNote(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.policy_outlined,
            size: 22,
            color: AppColors.info,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.finRequestPolicyTitle,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.finRequestPolicyMessage,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(
    String label,
    Color background,
    Color foreground, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDetails(
    AppLocalizations l10n,
    _FinancialRequest request,
  ) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.finRequestViewDetails),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(request.merchantName),
            const SizedBox(height: 8),
            Text(request.title),
            const SizedBox(height: 8),
            Text('${request.amount} ${l10n.finRequestCurrency}'),
            const SizedBox(height: 8),
            Text(request.status),
            const SizedBox(height: 8),
            Text(request.note),
            const SizedBox(height: 8),
            Text('${l10n.finRequestNumber}: ${request.id}'),
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
}
