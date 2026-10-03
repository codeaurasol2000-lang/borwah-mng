import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../../l10n/app_localizations.dart';

import '../screens/audit_screen.dart';
import '../screens/bank_reconciliation_screen.dart';
import '../screens/commissions_screen.dart';
import '../screens/finance_dashboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settlements_screen.dart';
import 'finance_navigation.dart';

class FinanceTabsShell extends StatefulWidget {
  const FinanceTabsShell({super.key});

  @override
  State<FinanceTabsShell> createState() => _FinanceTabsShellState();
}

class _FinanceTabsShellState extends State<FinanceTabsShell> {
  late final PageController _pageController = PageController(initialPage: 4);
  int _currentIndex = 4;
  bool _isBarsVisible = true;

  static const _pages = <Widget>[
    AuditScreen(showBottomNavigation: false),
    CommissionsScreen(showBottomNavigation: false),
    SettlementsScreen(showBottomNavigation: false),
    BankReconciliationScreen(showBottomNavigation: false),
    FinanceDashboardScreen(showBottomNavigation: false),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
      _isBarsVisible = true;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = switch (_currentIndex) {
      0 => l10n.navAudit,
      1 => l10n.navCommissions,
      2 => l10n.navSettlements,
      3 => l10n.navReconciliation,
      _ => l10n.navHome,
    };

    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      // شريط AppBar متجاوب يختفي عند التمرير لأسفل ويعود عند الصعود
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_isBarsVisible ? kToolbarHeight : 0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          height: _isBarsVisible ? (kToolbarHeight + topPadding) : 0.0,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isBarsVisible ? 1.0 : 0.0,
              child: FinancePageAppBar(
                title: title,
                subtitle: _currentIndex == 4 ? l10n.cfoRole : l10n.financialDepartment,
                showProfileButton: _currentIndex == 4,
                onProfilePressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
              ),
            ),
          ),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical) {
            if (notification.direction == ScrollDirection.reverse) {
              if (_isBarsVisible) {
                setState(() => _isBarsVisible = false);
              }
            } else if (notification.direction == ScrollDirection.forward) {
              if (!_isBarsVisible) {
                setState(() => _isBarsVisible = true);
              }
            }
          }
          return false;
        },
        child: PageView(
          controller: _pageController,
          pageSnapping: true,
          allowImplicitScrolling: true,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: _pages,
        ),
      ),
      // شريط BottomNavigationBar متجاوب يختفي بسلاسة عند التمرير لأسفل ويعود عند الصعود
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        height: _isBarsVisible ? 76.0 : 0.0,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isBarsVisible ? 1.0 : 0.0,
            child: FinanceBottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _selectPage,
            ),
          ),
        ),
      ),
    );
  }
}
