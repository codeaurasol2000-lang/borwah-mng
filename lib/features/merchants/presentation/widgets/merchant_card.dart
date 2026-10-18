import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/merchant_entity.dart';

class MerchantCard extends StatelessWidget {
  final MerchantEntity merchant;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;
  final bool? isSuspendedOverride;
  final String? recentAction;
  final String? recentActionDetails;
  final String? recentActionTime;

  const MerchantCard({
    super.key,
    required this.merchant,
    this.onTap,
    this.onActionTap,
    this.isSuspendedOverride,
    this.recentAction,
    this.recentActionDetails,
    this.recentActionTime,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final colors = Theme.of(context).colorScheme;
    final isSuspended = merchant.isSuspended ||
        merchant.status == MerchantStatus.temporarilySuspended;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header: Status Pill, Merchant Name, Category & CR, Logo
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Center(
                      child: Icon(
                        merchant.logoIcon ?? Icons.storefront,
                        size: 22,
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Name, Category, CR
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
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              merchant.categoryIcon,
                              size: 13,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                merchant.getCategory(isArabic),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text('•',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: colors.onSurfaceVariant)),
                            ),
                            Flexible(
                              child: Text(
                                '${l10n.crShortLabel} ${merchant.crNumber}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colors.onSurfaceVariant,
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
                      _buildStatusPill(l10n, colors),
                      if (merchant.isFeatured) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.tertiaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 11,
                                color: colors.onTertiaryContainer,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                l10n.merchantFeaturedBadge,
                                style: TextStyle(
                                  color: colors.onTertiaryContainer,
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

            // 2. Middle Metric Box: Ads Count, Section Title, Last Activity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Row(
                  children: [
                    // Activity Note
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            isSuspended
                                ? Icons.calendar_today_outlined
                                : Icons.access_time,
                            size: 13,
                            color: isSuspended
                                ? colors.onSurfaceVariant
                                : colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              merchant.getActivityNote(isArabic),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSuspended
                                    ? colors.onSurfaceVariant
                                    : colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Ads Count and Title with Icon
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              merchant.getAdsSectionTitle(isArabic),
                              style: TextStyle(
                                fontSize: 9,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              merchant.getAdsCountLabel(isArabic),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSuspended
                                    ? AppColors.danger
                                    : colors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          merchant.adsIcon,
                          size: 18,
                          color: isSuspended
                              ? AppColors.danger
                              : colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 3. Footer: Status Note on Right, Action Button on Left
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 6,
                spacing: 8,
                children: [
                  // Action link text
                  InkWell(
                    onTap: onActionTap,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Text(
                        merchant.getActionButtonText(isArabic),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: merchant.status == MerchantStatus.underAudit
                              ? AppColors.info
                              : colors.onSurface,
                        ),
                      ),
                    ),
                  ),

                  // Footer Status note with Icon
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        merchant.footerStatusIcon,
                        size: 14,
                        color: merchant.footerStatusColor ??
                            (isSuspended
                                ? AppColors.danger
                                : colors.onSurfaceVariant),
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
                                    ? AppColors.danger
                                    : colors.onSurfaceVariant),
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

  Widget _buildStatusPill(
      AppLocalizations l10n, ColorScheme colors) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String label;

    switch (merchant.status) {
      case MerchantStatus.active:
        bgColor = colors.brightness == Brightness.dark
            ? AppColors.successDark.withValues(alpha: 0.24)
            : AppColors.successLight;
        textColor = colors.brightness == Brightness.dark
            ? AppColors.hexFF61E3B0
            : AppColors.successDark;
        icon = Icons.check_circle_outline;
        label = l10n.merchantInfoStatusActive;
        break;
      case MerchantStatus.activeVerified:
        bgColor = colors.secondaryContainer;
        textColor = colors.onSecondaryContainer;
        icon = Icons.verified_outlined;
        label = l10n.merchantInfoStatusActiveVerified;
        break;
      case MerchantStatus.underAudit:
        bgColor = colors.secondaryContainer;
        textColor = colors.onSecondaryContainer;
        icon = Icons.assignment_late_outlined;
        label = l10n.merchantInfoStatusUnderAudit;
        break;
      case MerchantStatus.updateRequired:
        bgColor = colors.surfaceContainerHighest;
        textColor = colors.onSurfaceVariant;
        icon = Icons.notifications_active_outlined;
        label = l10n.merchantInfoStatusUpdateRequired;
        break;
      case MerchantStatus.temporarilySuspended:
        bgColor = colors.brightness == Brightness.dark
            ? AppColors.dangerDark.withValues(alpha: 0.24)
            : AppColors.dangerLight;
        textColor = colors.brightness == Brightness.dark
            ? AppColors.hexFFFCA5A5
            : AppColors.dangerDark;
        icon = Icons.pause_circle_outline;
        label = l10n.merchantInfoStatusSuspended;
        break;
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
