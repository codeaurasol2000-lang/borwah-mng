import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_locale_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../screens/audit_screen.dart';
import '../screens/bank_reconciliation_screen.dart';
import '../screens/commissions_screen.dart';
import '../screens/settlements_screen.dart';

class FinancePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showProfileButton;
  final VoidCallback? onProfilePressed;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget> additionalActions;

  const FinancePageAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showProfileButton = false,
    this.onProfilePressed,
    this.showBackButton = false,
    this.onBackPressed,
    this.additionalActions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return AppBar(
      centerTitle: false,
      titleSpacing: 12,
      leading: showBackButton
          ? IconButton(
              tooltip: l10n.settlementBack,
              onPressed: onBackPressed,
              icon: Icon(
                  isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                  size: 18),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          if (subtitle != null)
            Text(subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 9)),
        ],
      ),
      actions: [
        IconButton(
          tooltip: l10n.switchLanguage,
          onPressed: AppLocaleController.instance.toggle,
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.translate,
                  color: AppColors.primaryDark, size: 18),
              const SizedBox(width: 3),
              Text(
                isArabic ? l10n.languageEnglish : l10n.languageArabic,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark),
              ),
            ],
          ),
        ),
        if (showProfileButton)
          IconButton(
            tooltip: l10n.profileTitle,
            onPressed: onProfilePressed,
            icon: const CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.primaryDark,
              child: Icon(Icons.person_outline, color: Colors.white, size: 17),
            ),
          ),
        ...additionalActions,
      ],
    );
  }
}

class FinanceNavigation {
  const FinanceNavigation._();

  static void openTab(
    BuildContext context,
    int index, {
    required int currentIndex,
  }) {
    if (index == currentIndex) return;

    if (index == 4) {
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    final screen = switch (index) {
      0 => const AuditScreen(),
      1 => const CommissionsScreen(),
      2 => const SettlementsScreen(),
      3 => const BankReconciliationScreen(),
      _ => null,
    };
    if (screen == null) return;

    final beginX = index < currentIndex ? 1.0 : -1.0;
    final route = PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, animation, __, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(beginX, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    );

    Navigator.of(context).pushAndRemoveUntil(
      route,
      (route) => route.isFirst,
    );
  }
}

class FinanceBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const FinanceBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle:
          const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      elevation: 16,
      currentIndex: currentIndex,
      onTap: onTap ??
          (index) => FinanceNavigation.openTab(
                context,
                index,
                currentIndex: currentIndex,
              ),
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.history_edu, size: 24),
            label: l10n.navAudit),
        BottomNavigationBarItem(
            icon: const Icon(Icons.percent, size: 24),
            label: l10n.navCommissions),
        BottomNavigationBarItem(
            icon: const Icon(Icons.sync_alt, size: 24),
            label: l10n.navSettlements),
        BottomNavigationBarItem(
            icon: const Icon(Icons.fact_check_outlined, size: 24),
            label: l10n.navReconciliation),
        BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance, size: 24),
            label: l10n.navHome),
      ],
    );
  }
}

class FinanceSwipeNavigation extends StatefulWidget {
  final int currentIndex;
  final Widget child;
  final bool enabled;

  const FinanceSwipeNavigation({
    super.key,
    required this.currentIndex,
    required this.child,
    this.enabled = true,
  });

  @override
  State<FinanceSwipeNavigation> createState() => _FinanceSwipeNavigationState();
}

class _FinanceSwipeNavigationState extends State<FinanceSwipeNavigation> {
  double _dragDistance = 0;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (_) => _dragDistance = 0,
      onHorizontalDragUpdate: (details) => _dragDistance += details.delta.dx,
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        final dragDistance = _dragDistance;
        _dragDistance = 0;

        const velocityThreshold = 350.0;
        const distanceThreshold = 72.0;
        if (velocity.abs() < velocityThreshold &&
            dragDistance.abs() < distanceThreshold) {
          return;
        }

        final swipedLeft = velocity.abs() >= velocityThreshold
            ? velocity < 0
            : dragDistance < 0;
        final targetIndex =
            swipedLeft ? widget.currentIndex - 1 : widget.currentIndex + 1;
        if (targetIndex >= 0 && targetIndex <= 4) {
          FinanceNavigation.openTab(
            context,
            targetIndex,
            currentIndex: widget.currentIndex,
          );
        }
      },
      onHorizontalDragCancel: () => _dragDistance = 0,
      child: widget.child,
    );
  }
}
