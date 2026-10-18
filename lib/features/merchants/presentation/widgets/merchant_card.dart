import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/merchant_entity.dart';

class MerchantCard extends StatelessWidget {
  final MerchantEntity merchant;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;

  const MerchantCard({
    super.key,
    required this.merchant,
    this.onTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final palette = context.appThemePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSuspended = merchant.isSuspended ||
        merchant.status == MerchantStatus.temporarilySuspended;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: isDark ? palette.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? palette.border : AppColors.cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? palette.surfaceElevated
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? palette.border : AppColors.borderLight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        merchant.logoIcon ?? Icons.storefront,
                        size: 22,
                        color:
                            isDark ? palette.accent : const Color(0xFF1E3A5F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          merchant.getName(isArabic),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? palette.textPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              merchant.categoryIcon,
                              size: 13,
                              color: palette.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                merchant.getCategory(isArabic),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: palette.textSecondary,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                '•',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${l10n.crShortLabel} ${merchant.crNumber}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: palette.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatusPill(context, l10n),
                      if (merchant.isFeatured) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF3B3017)
                                : const Color(0xFFFFF4CC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 11,
                                color: isDark
                                    ? const Color(0xFFFFD36B)
                                    : const Color(0xFF9A6700),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                l10n.merchantFeaturedBadge,
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFFFFD36B)
                                      : const Color(0xFF805800),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? palette.surfaceElevated
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? palette.border : const Color(0xFFEDF2F7),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            isSuspended
                                ? Icons.calendar_today_outlined
                                : Icons.access_time,
                            size: 13,
                            color: isSuspended
                                ? palette.textSecondary
                                : palette.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              merchant.getActivityNote(isArabic),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: palette.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              merchant.getAdsSectionTitle(isArabic),
                              style: TextStyle(
                                fontSize: 9,
                                color: palette.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              merchant.getAdsCountLabel(isArabic),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSuspended
                                    ? palette.danger
                                    : palette.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          merchant.adsIcon,
                          size: 18,
                          color: isSuspended
                              ? palette.danger
                              : palette.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 6,
                spacing: 8,
                children: [
                  InkWell(
                    onTap: onActionTap,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Text(
                        merchant.getActionButtonText(isArabic),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: merchant.status == MerchantStatus.underAudit
                              ? AppColors.info
                              : palette.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        merchant.footerStatusIcon,
                        size: 14,
                        color: merchant.footerStatusColor ??
                            (isSuspended
                                ? palette.danger
                                : palette.textSecondary),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          merchant.getFooterStatusText(isArabic),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: merchant.footerStatusColor ??
                                (isSuspended
                                    ? palette.danger
                                    : palette.textSecondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, AppLocalizations l10n) {
    final palette = context.appThemePalette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    late final Color bgColor;
    late final Color textColor;
    late final IconData icon;
    late final String label;

    switch (merchant.status) {
      case MerchantStatus.active:
        bgColor = isDark ? const Color(0xFF16382F) : const Color(0xFFE7F8F1);
        textColor = palette.success;
        icon = Icons.check_circle_outline;
        label = l10n.merchantInfoStatusActive;
      case MerchantStatus.activeVerified:
        bgColor = isDark ? const Color(0xFF182F41) : const Color(0xFFEBF5FB);
        textColor = isDark ? const Color(0xFF8CCBFA) : const Color(0xFF1B6FB2);
        icon = Icons.verified_outlined;
        label = l10n.merchantInfoStatusActiveVerified;
      case MerchantStatus.underAudit:
        bgColor = isDark ? palette.accentContainer : const Color(0xFFEBF3FC);
        textColor = isDark ? palette.accent : const Color(0xFF2869A9);
        icon = Icons.assignment_late_outlined;
        label = l10n.merchantInfoStatusUnderAudit;
      case MerchantStatus.updateRequired:
        bgColor = isDark ? const Color(0xFF273344) : const Color(0xFFF1F3F5);
        textColor = isDark ? palette.textSecondary : const Color(0xFF555F6D);
        icon = Icons.notifications_active_outlined;
        label = l10n.merchantInfoStatusUpdateRequired;
      case MerchantStatus.temporarilySuspended:
        bgColor = isDark ? const Color(0xFF40262B) : const Color(0xFFFDE8E8);
        textColor = isDark ? const Color(0xFFFF9A9A) : const Color(0xFFC53030);
        icon = Icons.pause_circle_outline;
        label = l10n.merchantInfoStatusSuspended;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 112),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
