import 'package:barwah_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onActionTap,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      context,
      message,
      backgroundColor:  AppColors.hexFF10B981,
      borderColor:  AppColors.hexFFA7F3D0,
      icon: Icons.check_circle_outline_rounded,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onActionTap,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      context,
      message,
      backgroundColor:  AppColors.hexFF0284C7,
      borderColor:  AppColors.hexFFE0F2FE,
      icon: Icons.info_outline_rounded,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onActionTap,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      context,
      message,
      backgroundColor:  AppColors.surface,
      borderColor:  AppColors.cardBorder,
      icon: Icons.warning_amber_rounded,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onActionTap,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      message,
      backgroundColor:  AppColors.hexFFEF4444,
      borderColor:  AppColors.cardBorder,
      icon: Icons.error_outline_rounded,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
      duration: duration,
    );
  }

  static void showCustom(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required Color borderColor,
    IconData icon = Icons.notifications_none_rounded,
    String? actionLabel,
    VoidCallback? onActionTap,
    Duration duration = const Duration(seconds: 2),
  }) {
    _show(
      context,
      message,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      icon: icon,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
      duration: duration,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required Color borderColor,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onActionTap,
    required Duration duration,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 1.2),
          borderRadius: BorderRadius.circular(14),
        ),
        action: actionLabel == null || onActionTap == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: AppColors.white,
                onPressed: onActionTap,
              ),
      ),
    );
  }
}
