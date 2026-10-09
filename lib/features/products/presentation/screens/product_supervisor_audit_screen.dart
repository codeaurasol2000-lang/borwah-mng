import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/product_supervisor_audit_entry.dart';
import '../../domain/repositories/product_supervisor_audit_repository.dart';

class ProductSupervisorAuditScreen extends StatefulWidget {
  const ProductSupervisorAuditScreen({super.key});

  @override
  State<ProductSupervisorAuditScreen> createState() =>
      _ProductSupervisorAuditScreenState();
}

class _ProductSupervisorAuditScreenState
    extends State<ProductSupervisorAuditScreen> {
  late Future<List<ProductSupervisorAuditEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _entriesFuture = sl<ProductSupervisorAuditRepository>().getEntries();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDark,
        title: Text(
          l10n.productAuditHistoryTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<ProductSupervisorAuditEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _AuditMessage(
              icon: Icons.error_outline,
              message: l10n.productAuditLoadError,
              actionLabel: l10n.retryLoadMerchants,
              onPressed: () => setState(
                () => _entriesFuture =
                    sl<ProductSupervisorAuditRepository>().getEntries(),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return _AuditMessage(
              icon: Icons.fact_check_outlined,
              message: l10n.productAuditEmpty,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const SizedBox(height: 9),
            itemBuilder: (context, index) {
              final entry = snapshot.data![index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.surfaceLight,
                      child: Icon(Icons.receipt_long_outlined,
                          color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _actionLabel(entry.actionKey, l10n),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(entry.subject,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                          if (entry.details.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(entry.details,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11)),
                          ],
                          const SizedBox(height: 7),
                          Text(
                            DateFormat('yyyy/MM/dd  HH:mm')
                                .format(entry.occurredAt.toLocal()),
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _actionLabel(String actionKey, AppLocalizations l10n) =>
      switch (actionKey) {
        'product_approved' => l10n.productAuditActionApproved,
        'product_hidden' => l10n.productAuditActionHidden,
        'product_rejected' => l10n.productAuditActionRejected,
        'product_suspended' => l10n.productAuditActionSuspended,
        'product_details_updated' => l10n.productAuditActionUpdated,
        'promotion_approved' => l10n.productPromotionAuditApproved,
        'promotion_rejected' => l10n.productPromotionAuditRejected,
        'profile_field_availability_changed' =>
          l10n.productAuditActionFieldAvailability,
        'profile_urgent_notifications_changed' =>
          l10n.productAuditActionUrgentNotifications,
        'wallet_withdrawal_requested' =>
          l10n.productAuditActionWithdrawalRequested,
        _ => l10n.productAuditActionOther,
      };
}

class _AuditMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onPressed;

  const _AuditMessage({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textMuted, size: 42),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            if (onPressed != null) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: onPressed, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
