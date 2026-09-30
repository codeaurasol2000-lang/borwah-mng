import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/finance_navigation.dart';

class BankReconciliationScreen extends StatelessWidget {
  const BankReconciliationScreen({super.key});

  void _showActionMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: FinanceSwipeNavigation(
        currentIndex: 3,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: const Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: AppColors.primaryDark,
                child:
                    Icon(Icons.shield_outlined, color: Colors.white, size: 19),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.appName,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  l10n.reconciliationFinanceSubtitle,
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textSecondary),
                ),
              ],
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primaryDark,
                  child:
                      Icon(Icons.person_outline, color: Colors.white, size: 17),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              _buildScreenHeading(context),
              const SizedBox(height: 12),
              _buildAuthorityBanner(context),
              const SizedBox(height: 12),
              _buildGovernmentConnection(context),
              const SizedBox(height: 14),
              _buildAccountCard(context),
              const SizedBox(height: 14),
              _buildNextAccountCard(context),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigation(context),
        ),
      ),
    );
  }

  Widget _buildScreenHeading(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.reconciliationEngine,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 8, color: AppColors.infoDark),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user_outlined,
                      size: 11, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    l10n.reconciliationImmediateCompliance,
                    style: const TextStyle(
                        fontSize: 8, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.circle, size: 9, color: AppColors.info),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          l10n.reconciliationPageTitle,
          textAlign: l10n.localeName == 'ar' ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
              fontSize: 19,
              height: 1.35,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark),
        ),
      ],
    );
  }

  Widget _buildAuthorityBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.gavel, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: l10n.localeName == 'ar'
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reconciliationAuthorityTitle,
                  textAlign: l10n.localeName == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  l10n.reconciliationAuthorityNotice,
                  textAlign: l10n.localeName == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: TextStyle(
                      color: Colors.white70, fontSize: 9, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.gavel, color: Colors.white, size: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildGovernmentConnection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_outlined,
              color: AppColors.primaryDark, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: l10n.localeName == 'ar'
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(l10n.reconciliationGovernmentPortal,
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text(l10n.reconciliationGovernmentSync,
                    style:
                        TextStyle(fontSize: 8, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _statusPill(l10n.reconciliationConnected, const Color(0xFFDCE8FF),
              AppColors.infoDark),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAccountIdentity(context),
          const SizedBox(height: 14),
          _buildComplianceScore(context),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.checklist, color: AppColors.info, size: 17),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.reconciliationAccountDetails,
                  textAlign: l10n.localeName == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMatchedName(
            context,
            index: '1',
            title: l10n.reconciliationCommercialName,
            value: l10n.reconciliationCommercialEntity,
          ),
          const SizedBox(height: 7),
          _buildMatchedName(
            context,
            index: '2',
            title: l10n.reconciliationBeneficiaryName,
            value: l10n.reconciliationBeneficiaryEntity,
          ),
          const SizedBox(height: 7),
          _buildIbanRow(context),
          const SizedBox(height: 7),
          _buildCommercialRegistrationRow(context),
          const SizedBox(height: 7),
          _buildDocumentRow(context),
          const SizedBox(height: 14),
          Text(
            l10n.reconciliationFinalActions,
            textAlign:
                l10n.localeName == 'ar' ? TextAlign.right : TextAlign.left,
            style: TextStyle(fontSize: 8, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => _showActionMessage(
                  context, l10n.reconciliationApproveSuccess),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.verified_outlined, size: 18),
              label: Text(l10n.reconciliationApproveAccount,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () => _showActionMessage(
                  context, l10n.reconciliationIbanRequestSent),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                backgroundColor: const Color(0xFFEFF1F3),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.edit_document, size: 16),
              label: Text(l10n.reconciliationRequestIban,
                  style: const TextStyle(fontSize: 10)),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 40,
            child: TextButton.icon(
              onPressed: () =>
                  _showActionMessage(context, l10n.reconciliationRejectSuccess),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.dangerDark,
                backgroundColor: const Color(0xFFFFE0DE),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.block, size: 16),
              label: Text(l10n.reconciliationRejectTransfer,
                  style: const TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountIdentity(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _statusPill(l10n.reconciliationComplianceReview,
                const Color(0xFFE4ECFF), AppColors.infoDark),
            const Spacer(),
            _statusPill('#TRD-5501', AppColors.primaryDark, Colors.white),
          ],
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Color(0xFFF5F6F7),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              Icon(Icons.apartment, color: AppColors.primaryDark, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: l10n.localeName == 'ar'
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(l10n.reconciliationBusinessName,
                        textAlign: l10n.localeName == 'ar'
                            ? TextAlign.right
                            : TextAlign.left,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark)),
                    Text(l10n.reconciliationNewAccountRequest,
                        textAlign: l10n.localeName == 'ar'
                            ? TextAlign.right
                            : TextAlign.left,
                        style: TextStyle(
                            fontSize: 9, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComplianceScore(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
          color: Color(0xFFF0F2F4),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined,
                  color: AppColors.primaryDark, size: 18),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.reconciliationAmlScore,
                  textAlign: l10n.localeName == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark),
                ),
              ),
              SizedBox(width: 8),
              Text('100%',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 1,
              minHeight: 9,
              backgroundColor: Colors.white,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.info, size: 13),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  l10n.reconciliationAmlMatched,
                  textAlign: l10n.localeName == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  style: TextStyle(fontSize: 8, color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchedName(
    BuildContext context, {
    required String index,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: const BoxDecoration(
          color: Color(0xFFF0F2F4),
          borderRadius: BorderRadius.all(Radius.circular(9))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _statusPill(
                  AppLocalizations.of(context)!.reconciliationMatchVerified,
                  const Color(0xFFDDE3E8),
                  AppColors.infoDark),
              const Spacer(),
              Text('$index. $title',
                  style: const TextStyle(
                      fontSize: 8, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 5),
          Text(value,
              textAlign: TextAlign.right,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.primaryDark)),
        ],
      ),
    );
  }

  Widget _buildIbanRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
          color: const Color(0xFFF0F2F4),
          borderRadius: BorderRadius.circular(9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _statusPill(l10n.reconciliationBankName, AppColors.surfaceLight,
                  AppColors.primaryDark),
              const Spacer(),
              Text(l10n.reconciliationIbanLabel,
                  style:
                      TextStyle(fontSize: 8, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.copy_outlined, color: AppColors.info, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'SA44 8000 0123 6080 1012 3456',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.ltr,
                    style:
                        TextStyle(fontSize: 13, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommercialRegistrationRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFF0F2F4),
          borderRadius: BorderRadius.circular(9)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: l10n.localeName == 'ar'
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(l10n.reconciliationRegistrationLabel,
                    style:
                        TextStyle(fontSize: 8, color: AppColors.textSecondary)),
                SizedBox(height: 4),
                Text('1010892341',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _statusPill(l10n.reconciliationValidUntil, const Color(0xFFE0E4E7),
              AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFFF0F2F4),
          borderRadius: BorderRadius.circular(9)),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () => _showActionMessage(
                context, l10n.reconciliationDocumentPreviewToast),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              backgroundColor: Colors.white,
              side: BorderSide.none,
              minimumSize: const Size(72, 34),
              padding: const EdgeInsets.symmetric(horizontal: 9),
            ),
            icon: const Icon(Icons.visibility_outlined, size: 14),
            label: Text(l10n.reconciliationPreviewDocument,
                style: const TextStyle(fontSize: 9)),
          ),
          const Spacer(),
          const Text('doc-iban-5501.pdf',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: const Color(0xFFE0E4E7),
                borderRadius: BorderRadius.circular(7)),
            child: const Icon(Icons.picture_as_pdf_outlined,
                color: AppColors.info, size: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAccountCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.pending_actions,
                  color: AppColors.textSecondary, size: 17),
              const SizedBox(width: 6),
              Expanded(
                child: Text(l10n.reconciliationNextAccount,
                    textAlign: l10n.localeName == 'ar'
                        ? TextAlign.right
                        : TextAlign.left,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark)),
              ),
              _statusPill('#TRD-6022', const Color(0xFFE8EAEC),
                  AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFF0F2F4),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 16),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: l10n.localeName == 'ar'
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(l10n.reconciliationNextBusiness,
                          textAlign: l10n.localeName == 'ar'
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark)),
                      SizedBox(height: 4),
                      Text(l10n.reconciliationNextBank,
                          textAlign: l10n.localeName == 'ar'
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                              fontSize: 8, color: AppColors.textSecondary)),
                      SizedBox(height: 5),
                      Text(l10n.reconciliationNameMismatch,
                          textAlign: l10n.localeName == 'ar'
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                              fontSize: 8,
                              color: AppColors.textSecondary,
                              height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                _statusPill(l10n.reconciliationAuditAlert,
                    const Color(0xFFFFE0DE), AppColors.dangerDark),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            decoration: BoxDecoration(
                color: const Color(0xFFE9ECEF),
                borderRadius: BorderRadius.circular(9)),
            child: Row(
              children: [
                Icon(Icons.arrow_back, size: 14, color: AppColors.primaryDark),
                SizedBox(width: 6),
                Expanded(
                  child: Text(l10n.reconciliationOpenAudit,
                      textAlign: l10n.localeName == 'ar'
                          ? TextAlign.right
                          : TextAlign.left,
                      style:
                          TextStyle(fontSize: 9, color: AppColors.primaryDark)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: 3,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle:
          const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      elevation: 16,
      onTap: (index) => FinanceNavigation.openTab(
        context,
        index,
        currentIndex: 3,
      ),
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.history_edu, size: 24),
            label: AppLocalizations.of(context)!.navAudit),
        BottomNavigationBarItem(
            icon: const Icon(Icons.percent, size: 24),
            label: AppLocalizations.of(context)!.navCommissions),
        BottomNavigationBarItem(
            icon: const Icon(Icons.sync_alt, size: 24),
            label: AppLocalizations.of(context)!.navSettlements),
        BottomNavigationBarItem(
            icon: const Icon(Icons.fact_check_outlined, size: 24),
            label: AppLocalizations.of(context)!.navReconciliation),
        BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance, size: 24),
            label: AppLocalizations.of(context)!.navHome),
      ],
    );
  }

  Widget _statusPill(String label, Color background, Color foreground) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 210),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(18)),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 8, color: foreground, fontWeight: FontWeight.w600),
      ),
    );
  }
}
