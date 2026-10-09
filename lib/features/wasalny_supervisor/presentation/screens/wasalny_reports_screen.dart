import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class WasalnyReportsScreen extends StatelessWidget {
  const WasalnyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDark,
          title: Text(l10n.productReportsTab),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.wasalnyReportOverview,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            _ReportMetric(
              icon: Icons.handshake_outlined,
              label: l10n.wasalnyRequestsActiveDeals,
              value: '248',
              detail: l10n.wasalnyReportDealsDetail,
            ),
            _ReportMetric(
              icon: Icons.task_alt_outlined,
              label: l10n.wasalnyReportCompletionRate,
              value: '94.6%',
              detail: l10n.wasalnyReportCompletionDetail,
            ),
            _ReportMetric(
              icon: Icons.bolt_outlined,
              label: l10n.wasalnyReportResponseTime,
              value: isArabic ? '22 دقيقة' : '22 min',
              detail: l10n.wasalnyReportResponseDetail,
            ),
            _ReportMetric(
              icon: Icons.star_outline_rounded,
              label: l10n.wasalnyReportSatisfaction,
              value: '4.9 / 5',
              detail: l10n.wasalnyReportRatingDetail,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String detail;

  const _ReportMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.surfaceLight,
            child: Icon(icon, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(
                    color: AppColors.successDark,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
