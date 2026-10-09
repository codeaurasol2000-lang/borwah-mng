import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class WasalnyComplaintsScreen extends StatelessWidget {
  const WasalnyComplaintsScreen({super.key});

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
          title: Text(l10n.wasalnyAccountFollowComplaint),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFFFF0D8),
                        child: Icon(
                          Icons.report_problem_outlined,
                          color: Color(0xFF8A5A00),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.wasalnyComplaintReference,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        l10n.wasalnyComplaintOpenStatus,
                        style: const TextStyle(
                          color: Color(0xFF8A5A00),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.wasalnyComplaintSubject,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.wasalnyComplaintDescription,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ComplaintProgress(
                    label: l10n.wasalnyComplaintReceived,
                    complete: true,
                  ),
                  _ComplaintProgress(
                    label: l10n.wasalnyComplaintUnderReview,
                    complete: true,
                  ),
                  _ComplaintProgress(
                    label: l10n.wasalnyComplaintWaitingAction,
                    complete: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComplaintProgress extends StatelessWidget {
  final String label;
  final bool complete;
  final bool isLast;

  const _ComplaintProgress({
    required this.label,
    required this.complete,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = complete ? AppColors.successDark : AppColors.textMuted;
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Icon(
                  complete ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 17,
                  color: color,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: complete
                          ? AppColors.successDark.withValues(alpha: 0.35)
                          : const Color(0xFFE4E6E9),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Text(
                label,
                style: TextStyle(
                  color: complete ? AppColors.textPrimary : color,
                  fontSize: 12,
                  fontWeight: complete ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
