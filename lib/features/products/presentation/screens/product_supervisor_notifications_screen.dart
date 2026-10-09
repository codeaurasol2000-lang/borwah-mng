import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class ProductSupervisorNotificationsScreen extends StatefulWidget {
  const ProductSupervisorNotificationsScreen({super.key});

  @override
  State<ProductSupervisorNotificationsScreen> createState() =>
      _ProductSupervisorNotificationsScreenState();
}

class _ProductSupervisorNotificationsScreenState
    extends State<ProductSupervisorNotificationsScreen> {
  bool _allRead = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notifications = [
      (
        Icons.inventory_2_outlined,
        l10n.productNotificationNewReviewTitle,
        l10n.productNotificationNewReviewBody,
        l10n.productNotificationToday,
      ),
      (
        Icons.account_balance_wallet_outlined,
        l10n.productNotificationWalletTitle,
        l10n.productNotificationWalletBody,
        l10n.productNotificationYesterday,
      ),
      (
        Icons.verified_outlined,
        l10n.productNotificationPolicyTitle,
        l10n.productNotificationPolicyBody,
        l10n.productNotificationEarlier,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDark,
        title: Text(
          l10n.productNotificationsTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => _allRead = true),
            child: Text(l10n.productNotificationsMarkAllRead),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => setState(() => _allRead = true),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.surfaceLight,
                      child: Icon(item.$1, color: AppColors.primaryDark),
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
                                  item.$2,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!_allRead && index == 0)
                                const Icon(Icons.circle,
                                    color: AppColors.info, size: 9),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.$3,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.$4,
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
