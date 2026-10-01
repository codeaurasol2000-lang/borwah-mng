import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: FinancePageAppBar(
        title: title,
        subtitle: _currentIndex == 4 ? l10n.cfoRole : l10n.financialDepartment,
        showProfileButton: _currentIndex == 4,
        onProfilePressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        ),
      ),
      body: PageView(
        controller: _pageController,
        pageSnapping: true,
        allowImplicitScrolling: true,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: _pages,
      ),
      bottomNavigationBar: FinanceBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _selectPage,
      ),
    );
  }
}
