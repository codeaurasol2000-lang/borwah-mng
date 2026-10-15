import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/entities/finance_summary_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../widgets/finance_navigation.dart';
import '../widgets/new_settlement_bottom_sheet.dart';
import 'settlement_details_screen.dart';

class SettlementsScreen extends StatefulWidget {
  final bool showBottomNavigation;

  const SettlementsScreen({super.key, this.showBottomNavigation = true});

  @override
  State<SettlementsScreen> createState() => _SettlementsScreenState();
}

class _SettlementsScreenState extends State<SettlementsScreen>
    with AutomaticKeepAliveClientMixin<SettlementsScreen> {
  static const _filters = [
    'الكل',
    'قيد المراجعة',
    'معتمدة',
    'قيد نزاع',
    'بانتظار الإدارة',
    'مرفوض',
  ];

  String _selectedFilter = 'قيد المراجعة';
  String _searchQuery = '';
  List<_SettlementRequest> _createdRequests = [];
  FinanceSummaryEntity? _financeSummary;

  @override
  void initState() {
    super.initState();
    _loadCreatedRequests();
  }

  Future<void> _loadCreatedRequests() async {
    try {
      final repository = sl<FinanceRepository>();
      final requestResult = await repository.getSupervisorWithdrawals();
      final summaryResult = await repository.getFinanceSummary();
      if (!mounted) return;
      requestResult.fold(
        (failure) => FlutterError.reportError(
          FlutterErrorDetails(
            exception: StateError(failure.message),
            library: 'settlements screen',
            context: ErrorDescription('while loading saved settlements'),
          ),
        ),
        (requests) {
          final l10n = AppLocalizations.of(context)!;
          setState(() {
            _createdRequests = requests
                .where((request) => request.settlementMode != null)
                .map((request) => _mapSavedRequest(request, l10n))
                .toList(growable: false);
            summaryResult.fold(
              (_) => _financeSummary = null,
              (summary) => _financeSummary = summary,
            );
          });
        },
      );
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'settlements screen',
          context: ErrorDescription('while loading saved settlements'),
        ),
      );
    }
  }

  _SettlementRequest _mapSavedRequest(
    WithdrawalRequestEntity request,
    AppLocalizations l10n,
  ) {
    final isRefund = request.settlementMode == 'refund';
    return _SettlementRequest(
      id: request.requestNumber,
      financeRequestId: request.id,
      name: request.beneficiaryName,
      description: request.beneficiaryRole,
      amount: request.netAmount.toStringAsFixed(2),
      reference: request.reference?.isNotEmpty == true
          ? request.reference!
          : request.requestNumber,
      referenceTitle: l10n.settlementReferenceLabel,
      badge: isRefund ? l10n.settlementRefundMode : l10n.settlementOffsetMode,
      status: request.adminApprovalPending
          ? 'بانتظار الإدارة'
          : switch (request.status) {
              RequestStatus.approved => 'معتمدة',
              RequestStatus.frozen ||
              RequestStatus.underInvestigation =>
                'قيد نزاع',
              RequestStatus.rejected => 'مرفوض',
              _ => 'قيد المراجعة',
            },
      initials: request.beneficiaryName.isEmpty
          ? '?'
          : request.beneficiaryName.substring(0, 1),
      age: DateFormat.yMd(l10n.localeName)
          .add_jm()
          .format(DateTime.tryParse(request.dateText) ?? DateTime.now()),
      color: isRefund ?  AppColors.textPrimary :  AppColors.hexFFE8F0FF,
      badgeColor: isRefund ? AppColors.danger : AppColors.info,
      bankName: request.bankName,
      iban: request.iban,
      notes: request.notes,
      decisionAt: request.decisionAt,
      decisionBy: request.decisionBy,
      decisionNote: request.alertNotice,
      canDecide: request.status == RequestStatus.pending,
      adminApprovalPending: request.adminApprovalPending,
      submittedAt: DateTime.tryParse(request.dateText) ?? DateTime(1970),
    );
  }

  List<_SettlementRequest> get _filteredRequests {
    final allRequests = _createdRequests;
    final query = _searchQuery.trim().toLowerCase();
    final visible = allRequests.where((request) {
      final matchesStatus = _selectedFilter == 'الكل' ||
          request.status == _selectedFilter;
      final matchesSearch = query.isEmpty ||
          [request.id, request.name, request.reference, request.iban ?? '']
              .any((value) => value.toLowerCase().contains(query));
      return matchesStatus && matchesSearch;
    }).toList();
    visible.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    return visible;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: FinanceSwipeNavigation(
        currentIndex: 2,
        enabled: widget.showBottomNavigation,
        child: Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: widget.showBottomNavigation
              ? AppBar(
                  backgroundColor: AppColors.white,
                  elevation: 0.5,
                  scrolledUnderElevation: 0,
                  leading: widget.showBottomNavigation
                      ? IconButton(
                          tooltip: l10n.settlementBack,
                          icon: Icon(
                            isArabic
                                ? Icons.arrow_forward_ios
                                : Icons.arrow_back_ios,
                            size: 19,
                          ),
                          onPressed: () => Navigator.pop(context),
                        )
                      : null,
                  title: Column(
                    children: [
                      Text(
                        l10n.settlementsScreenTitle,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.settlementsSubtitle,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  centerTitle: true,
                  actions: const [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primaryDark,
                        child: Icon(Icons.person_outline,
                            color: AppColors.white, size: 17),
                      ),
                    ),
                  ],
                )
              : null,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              _buildBalances(),
              const SizedBox(height: 14),
              _buildAddSettlementAction(),
              const SizedBox(height: 14),
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: isArabic
                      ? 'ابحث برقم التسوية أو المستفيد أو المرجع'
                      : 'Search settlement, beneficiary, or reference',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildFilters(),
              const SizedBox(height: 16),
              _buildRequestsHeader(),
              const SizedBox(height: 8),
              if (_filteredRequests.isEmpty)
                _buildEmptyRequestsMessage(isArabic)
              else
                ..._filteredRequests.map(_buildRequestCard),
              const SizedBox(height: 8),
            ],
          ),
          bottomNavigationBar: widget.showBottomNavigation
              ? const FinanceBottomNavigationBar(currentIndex: 2)
              : null,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user_outlined,
                          color: AppColors.white, size: 12),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.settlementsAuthority,
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                '#SETTL-2024-098',
                style: TextStyle(color: AppColors.white70, fontSize: 10),
                textDirection: ui.TextDirection.ltr,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.settlementsPageTitle,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
                color: AppColors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            l10n.settlementsPageDescription,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
                color: AppColors.white70, fontSize: 11, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildBalances() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _buildBalanceCard(
            title: l10n.settlementsEscrowWallet,
            amount: _financeSummary == null
                ? '—'
                : NumberFormat('#,##0.00', 'en_US')
                    .format(_financeSummary!.snbEscrowBalance),
            subtitle: l10n.localeName.startsWith('ar')
                ? 'رصيد ضمان SNB من ملخص المالية'
                : 'SNB escrow balance from finance summary',
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildBalanceCard(
            title: l10n.settlementsPendingBalance,
            amount: NumberFormat('#,##0.00', 'en_US').format(
              _createdRequests
                  .where((request) =>
                      request.canDecide || request.adminApprovalPending)
                  .fold<double>(
                    0,
                    (total, request) =>
                        total + (double.tryParse(request.amount) ?? 0),
                  ),
            ),
            subtitle: l10n.settlementsReadyRefund,
            icon: Icons.pending_actions,
            color: AppColors.danger,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard({
    required String title,
    required String amount,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      constraints: const BoxConstraints(minHeight: 92),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark),
              ),
              const SizedBox(width: 4),
              Text(l10n.currencyEgy,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: AppColors.info),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSettlementAction() {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: AppColors.primaryDark,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final request = await NewSettlementBottomSheet.show(context);
          if (!mounted || request == null) return;
          final l10n = AppLocalizations.of(context)!;
          setState(() {
            _createdRequests.insert(0, _mapSavedRequest(request, l10n));
          });
          AppSnackBar.showSuccess(
            context,
            '${l10n.settlementSubmitSuccess} · ${request.requestNumber}',
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline,
                  color: AppColors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.addNewSettlement,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.instantRefundSettlement,
                  style: const TextStyle(color: AppColors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final l10n = AppLocalizations.of(context)!;
    final labels = {
      'الكل': l10n.filterAll,
      'قيد المراجعة': l10n.filterInReview,
      'معتمدة': l10n.filterApproved,
      'قيد نزاع': l10n.filterDisputed,
      'بانتظار الإدارة': l10n.localeName.startsWith('ar')
          ? 'بانتظار الإدارة'
          : 'Pending Admin Approval',
      'مرفوض': l10n.financeRequestRejectedBadge,
    };
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      alignment: WrapAlignment.start,
      children: _filters.map((filter) {
        final isSelected = filter == _selectedFilter;
        return ChoiceChip(
          label: Text(labels[filter]!),
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedFilter = filter),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: AppColors.surfaceLight,
          selectedColor: AppColors.primaryDark,
          side: BorderSide.none,
          visualDensity: VisualDensity.compact,
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        );
      }).toList(),
    );
  }

  Widget _buildRequestsHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        const Icon(Icons.assignment_outlined, color: AppColors.info, size: 17),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            l10n.pendingSettlementRequests,
            textAlign: TextAlign.end,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark),
          ),
        ),
        Text(
          '${_filteredRequests.length} ${l10n.settlementRequestOne}',
          style: const TextStyle(fontSize: 11, color: AppColors.info),
        ),
      ],
    );
  }

  ({
    String description,
    String name,
    String referenceTitle,
    String badge,
    String status,
    String initials,
    String age
  }) _localizedRequestLabels(
    _SettlementRequest request,
    AppLocalizations l10n,
  ) =>
      (
        description: request.description,
        name: request.name,
        referenceTitle: request.referenceTitle,
        badge: request.badge,
        status: switch (request.status) {
          'قيد المراجعة' => l10n.filterInReview,
          'معتمدة' => l10n.filterApproved,
          'قيد نزاع' => l10n.filterDisputed,
          'بانتظار الإدارة' => l10n.localeName.startsWith('ar')
              ? 'بانتظار الإدارة'
              : 'Pending Admin Approval',
          'مرفوض' => l10n.financeRequestRejectedBadge,
          _ => request.status,
        },
        initials: request.initials,
        age: request.age,
      );

  Widget _buildRequestCard(_SettlementRequest request) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final labels = _localizedRequestLabels(request, l10n);
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SettlementDetailsScreen(
                id: request.id,
                financeRequestId: request.financeRequestId,
                name: labels.name,
                description: labels.description,
                amount: request.amount,
                reference: request.reference,
                referenceTitle: labels.referenceTitle,
                badge: labels.badge,
                status: labels.status,
                initials: labels.initials,
                age: labels.age,
                color: request.color,
                badgeColor: request.badgeColor,
                linkedBank:
                    request.bankName ?? l10n.settlementsLinkedRajhiEscrow,
                iban: request.iban ?? 'SA44 8000 0123 6080 1012 3456',
                notes: request.notes,
                decisionAt: request.decisionAt,
                decisionBy: request.decisionBy,
                decisionNote: request.decisionNote,
                canDecide: request.canDecide,
                adminApprovalPending: request.adminApprovalPending,
              ),
            ),
          );
          if (mounted && request.financeRequestId != null) {
            _loadCreatedRequests();
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildTag(labels.badge, request.badgeColor),
                  const SizedBox(width: 5),
                  _buildTag(labels.status, AppColors.surfaceLight,
                      textColor: AppColors.infoDark),
                  const Spacer(),
                  Text(
                    request.id,
                    textDirection: ui.TextDirection.ltr,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: request.color,
                    child: Text(
                      labels.initials,
                      style: const TextStyle(
                          color: AppColors.infoDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          labels.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark),
                        ),
                        Text(
                          labels.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            request.amount,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark),
                          ),
                          const SizedBox(width: 3),
                          Text(l10n.currencyEgy,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                      Text(labels.age,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.info)),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: Divider(height: 1, color: AppColors.surfaceLight),
              ),
              Row(
                children: [
                  _buildTag('${labels.referenceTitle} ${request.reference}',
                      AppColors.surfaceLight,
                      textColor: AppColors.infoDark),
                  const Spacer(),
                  Icon(
                    isArabic ? Icons.arrow_back : Icons.arrow_forward,
                    size: 14,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 3),
                  Text(l10n.viewLabel,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color,
      {Color textColor = AppColors.primaryDark}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 10, color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildEmptyRequestsMessage(bool isArabic) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          isArabic
              ? 'لا توجد طلبات تسوية بهذه الحالة.'
              : 'No settlements in this status.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      );
}

class _SettlementRequest {
  final DateTime submittedAt;
  final String id;
  final String? financeRequestId;
  final String name;
  final String description;
  final String amount;
  final String reference;
  final String referenceTitle;
  final String badge;
  final String status;
  final String initials;
  final String age;
  final Color color;
  final Color badgeColor;
  final String? bankName;
  final String? iban;
  final String? notes;
  final DateTime? decisionAt;
  final String? decisionBy;
  final String? decisionNote;
  final bool canDecide;
  final bool adminApprovalPending;

  _SettlementRequest({
    required this.submittedAt,
    required this.id,
    this.financeRequestId,
    required this.name,
    required this.description,
    required this.amount,
    required this.reference,
    required this.referenceTitle,
    required this.badge,
    required this.status,
    required this.initials,
    required this.age,
    required this.color,
    required this.badgeColor,
    this.bankName,
    this.iban,
    this.notes,
    this.decisionAt,
    this.decisionBy,
    this.decisionNote,
    this.canDecide = true,
    this.adminApprovalPending = false,
  });
}
