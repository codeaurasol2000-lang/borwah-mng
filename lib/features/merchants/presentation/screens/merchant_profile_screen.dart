import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'merchant_wallet_screen.dart';
import 'supervised_merchants_screen.dart';

class MerchantProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback? onSupervisedMerchantsTap;

  const MerchantProfileScreen({
    super.key,
    required this.onLogout,
    this.onSupervisedMerchantsTap,
  });

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  bool _fieldAvailability = false;
  bool _directAdNotifications = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          children: [
            _buildProfileSummary(l10n),
            const SizedBox(height: 16),
            _buildSectionHeading(
              l10n.merchantProfileDocumentsTitle,
              Icons.circle,
              const Color(0xFF0E2B4F),
            ),
            const SizedBox(height: 8),
            _buildAuthorizationCard(l10n),
            const SizedBox(height: 8),
            _buildDocumentTile(
              l10n,
              icon: Icons.menu_book_outlined,
              title: l10n.merchantProfileGovernanceGuide,
              subtitle: l10n.merchantProfileGuideSubtitle,
              trailing: '2025',
              id: 'GUIDE-2025',
            ),
            const SizedBox(height: 8),
            _buildDocumentTile(
              l10n,
              icon: Icons.gavel_outlined,
              title: l10n.merchantProfileDelegationDocument,
              subtitle: l10n.merchantProfileDelegationSubtitle,
              id: 'DEL-SUP-4092',
            ),
            const SizedBox(height: 18),
            _buildSectionHeading(
              l10n.merchantProfileFieldPermissions,
              Icons.circle,
              AppColors.info,
              trailing: l10n.merchantProfileUpdatedAutomatically,
            ),
            const SizedBox(height: 8),
            _buildPreferences(l10n),
            const SizedBox(height: 18),
            _buildSectionHeading(
              l10n.merchantProfileSecurityAudit,
              Icons.circle,
              AppColors.textMuted,
              trailing: l10n.merchantProfileViewAll,
            ),
            const SizedBox(height: 8),
            _buildAuditHistory(l10n),
            const SizedBox(height: 18),
            _buildSectionHeading(
              l10n.merchantProfileFinancialWallet,
              Icons.account_balance_wallet_outlined,
              AppColors.info,
              trailing: l10n.merchantProfileJustUpdated,
            ),
            const SizedBox(height: 8),
            _buildWalletCard(l10n),
            const SizedBox(height: 14),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: widget.onLogout,
                icon: const Icon(Icons.logout, size: 18),
                label: Text(l10n.logout),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSummary(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EDF2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFD5DEE8)),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 38,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    left: -5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.merchantProfileName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.merchantProfileRegion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      runSpacing: 5,
                      children: [
                        _pill(
                          l10n.merchantProfileSupervisorId,
                          const Color(0xFFEAF0F7),
                          AppColors.info,
                          icon: Icons.badge_outlined,
                        ),
                        _pill(
                          l10n.merchantProfileActive,
                          const Color(0xFFEAF0F7),
                          AppColors.info,
                          icon: Icons.circle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _profileMetric(
                  icon: Icons.campaign_outlined,
                  value: '142',
                  label: l10n.merchantProfileMonthlyAds,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _profileMetric(
                  icon: Icons.storefront_outlined,
                  value: '18',
                  label: l10n.merchantProfileStores,
                  onTap: () {
                    widget.onSupervisedMerchantsTap?.call();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SupervisedMerchantsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileMetric({
    required IconData icon,
    required String value,
    required String label,
    VoidCallback? onTap,
  }) {
    return Material(
      color: const Color(0xFFF5F7F9),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 62),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 14, color: AppColors.info),
                  const SizedBox(width: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios,
                        size: 10, color: AppColors.info),
                  ],
                ],
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeading(
    String title,
    IconData icon,
    Color color, {
    String? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, size: 9, color: color),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          Text(
            trailing,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.info, fontSize: 9),
          ),
        ],
      ],
    );
  }

  Widget _buildAuthorizationCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _documentIcon(Icons.assignment_ind_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.merchantProfileAuthorizationCard,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.merchantProfileValidUntil,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      runSpacing: 5,
                      children: [
                        _pill(
                          l10n.merchantProfileActive,
                          const Color(0xFFEAF0F7),
                          AppColors.info,
                          icon: Icons.circle,
                        ),
                        _pill(
                          'PDF',
                          const Color(0xFFDCE8FF),
                          AppColors.primaryDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: l10n.merchantProfileOpenDocument,
                onPressed: () => _showDocumentDetails(l10n, 'AUTH-SUP-4092'),
                icon: const Icon(Icons.download_outlined, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _showDocumentDetails(l10n, 'AUTH-SUP-4092'),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: Text(
                    l10n.merchantProfileOpenDocument,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  Widget _buildDocumentTile(
    AppLocalizations l10n, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String id,
    String? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          _documentIcon(icon),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 4),
            _pill(trailing, const Color(0xFFE9EBED), AppColors.textSecondary),
          ],
          const SizedBox(width: 4),
          TextButton(
            onPressed: () => _showDocumentDetails(l10n, id),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            child: Text(l10n.merchantProfileOpenDocument),
          ),
        ],
      ),
    );
  }

  Widget _documentIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppColors.primaryDark, size: 21),
    );
  }

  Widget _buildPreferences(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _preferenceRow(
            icon: Icons.access_time,
            title: l10n.merchantProfileAvailability,
            subtitle: l10n.merchantProfileAvailabilitySubtitle,
            value: _fieldAvailability,
            onChanged: (value) => setState(() => _fieldAvailability = value),
          ),
          const Divider(height: 1, color: Color(0xFFE3E7EB)),
          _preferenceRow(
            icon: Icons.campaign_outlined,
            title: l10n.merchantProfileDirectNotifications,
            subtitle: l10n.merchantProfileNotificationsSubtitle,
            value: _directAdNotifications,
            onChanged: (value) =>
                setState(() => _directAdNotifications = value),
          ),
        ],
      ),
    );
  }

  Widget _preferenceRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        _documentIcon(icon),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.info,
        ),
      ],
    );
  }

  Widget _buildAuditHistory(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.merchantProfileLatestActivities,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                l10n.merchantProfileToday,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          _activity(
            icon: Icons.check_circle_outline,
            title: l10n.merchantProfileActivityApproved,
            subtitle: l10n.merchantProfileLicenseNumber,
            time: '28 ${l10n.merchantProfileMinutesUnit}',
          ),
          const Divider(height: 1, color: Color(0xFFE3E7EB)),
          _activity(
            icon: Icons.edit_note_outlined,
            title: l10n.merchantProfileActivityEdit,
            subtitle: l10n.merchantProfileActivityEditDetails,
            time: l10n.merchantProfileTwoHoursAgo,
          ),
          const Divider(height: 1, color: Color(0xFFE3E7EB)),
          _activity(
            icon: Icons.fact_check_outlined,
            title: l10n.merchantProfileActivityLocation,
            subtitle: l10n.merchantProfileActivityLocationDetails,
            time: '10:15 ${l10n.merchantProfileMorningAbbreviation}',
          ),
        ],
      ),
    );
  }

  Widget _activity({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _documentIcon(icon),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              time,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(AppLocalizations l10n) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: _openWallet,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.merchantProfileBalanceTitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.merchantProfileBalance} ${l10n.finRequestCurrency}',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    l10n.merchantProfileBalanceDetails,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: l10n.merchantProfileWalletDetails,
              onPressed: _openWallet,
              icon: const Icon(Icons.arrow_back, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(
    String label,
    Color background,
    Color foreground, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: foreground),
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDocumentDetails(
    AppLocalizations l10n,
    String documentId,
  ) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.merchantProfileDocumentDetails),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.merchantProfileName),
            const SizedBox(height: 8),
            Text('${l10n.merchantProfileDocumentNumber}: $documentId'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.merchantProfileClose),
          ),
        ],
      ),
    );
  }

  void _openWallet() {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => const MerchantWalletScreen(),
      ),
    );
  }
}
