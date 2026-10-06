import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/merchant_entity.dart';

class MerchantPendingOperationsScreen extends StatefulWidget {
  final MerchantEntity merchant;

  const MerchantPendingOperationsScreen({super.key, required this.merchant});

  @override
  State<MerchantPendingOperationsScreen> createState() =>
      _MerchantPendingOperationsScreenState();
}

class _MerchantPendingOperationsScreenState
    extends State<MerchantPendingOperationsScreen> {
  final Set<String> _resolvedReferences = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');
    final pendingAds = widget.merchant.recentAdvertisements
        .where((ad) =>
            ad.status == MerchantAdvertisementStatus.underReview &&
            !_resolvedReferences.contains(ad.reference))
        .toList();
    final totalPendingCount =
        widget.merchant.underReviewAdsCount ?? pendingAds.length;
    final remainingPendingCount =
        (totalPendingCount - _resolvedReferences.length)
            .clamp(0, totalPendingCount);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        appBar: AppBar(
          title: Text(l10n.merchantInfoPendingOperations),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDark,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _MerchantHeading(merchant: widget.merchant, isArabic: isArabic),
            const SizedBox(height: 16),
            if (remainingPendingCount > 0) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.merchantPendingCount(remainingPendingCount),
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (remainingPendingCount > pendingAds.length) ...[
                      const SizedBox(height: 6),
                      Text(
                        l10n.merchantPendingMoreDetailsUnavailable,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (pendingAds.isEmpty && remainingPendingCount == 0)
              _EmptyPendingOperations(
                  message: l10n.merchantPendingOperationsEmpty)
            else if (pendingAds.isNotEmpty)
              ...pendingAds.map(
                (ad) => _PendingAdvertisementCard(
                  title: ad.getTitle(isArabic),
                  reference: ad.reference,
                  price: ad.price,
                  onApprove: () => _resolve(ad.reference, l10n),
                  onReject: () => _resolve(ad.reference, l10n),
                  l10n: l10n,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _resolve(String reference, AppLocalizations l10n) {
    setState(() => _resolvedReferences.add(reference));
    AppSnackBar.showSuccess(context, l10n.merchantPendingOperationHandled);
  }
}

class _MerchantHeading extends StatelessWidget {
  final MerchantEntity merchant;
  final bool isArabic;

  const _MerchantHeading({required this.merchant, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryDark,
            child: Icon(
              merchant.logoIcon ?? merchant.categoryIcon,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              merchant.getName(isArabic),
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingAdvertisementCard extends StatelessWidget {
  final String title;
  final String reference;
  final String price;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final AppLocalizations l10n;

  const _PendingAdvertisementCard({
    required this.title,
    required this.reference,
    required this.price,
    required this.onApprove,
    required this.onReject,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.campaign_outlined, color: AppColors.info),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(label: l10n.merchantPendingReference, value: reference),
          _InfoRow(label: l10n.merchantPendingPrice, value: price),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  child: Text(l10n.merchantPendingReject),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: onApprove,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                  ),
                  child: Text(l10n.merchantPendingApprove),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPendingOperations extends StatelessWidget {
  final String message;

  const _EmptyPendingOperations({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          const Icon(
            Icons.task_alt_outlined,
            size: 52,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
