import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection_container.dart';
import '../../features/finance/presentation/widgets/finance_navigation.dart';
import '../../features/merchants/presentation/controllers/merchants_cubit.dart';
import '../../features/merchants/presentation/screens/ads_management_screen.dart';
import '../../features/merchants/presentation/screens/merchant_financial_requests_screen.dart';
import '../../features/merchants/presentation/screens/merchant_profile_screen.dart';
import '../../features/merchants/presentation/screens/merchants_dashboard_screen.dart';
import '../../l10n/app_localizations.dart';

class MerchantsTabsShell extends StatefulWidget {
  final VoidCallback onLogout;

  const MerchantsTabsShell({super.key, required this.onLogout});

  @override
  State<MerchantsTabsShell> createState() => _MerchantsTabsShellState();
}

class _MerchantsTabsShellState extends State<MerchantsTabsShell> {
  late final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isBarsVisible = true;

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
    final navItems = [
      FinanceNavigationItem(
          icon: Icons.storefront_outlined, label: l10n.navMerchants),
      FinanceNavigationItem(
          icon: Icons.view_agenda_outlined, label: l10n.navAds),
      FinanceNavigationItem(
        icon: Icons.receipt_long_outlined,
        label: l10n.navFinancialRequests,
      ),
      FinanceNavigationItem(icon: Icons.person_outline, label: l10n.navAccount),
    ];
    final titles = [
      l10n.navMerchants,
      l10n.navAds,
      l10n.navFinancialRequests,
      l10n.navAccount,
    ];
    final pages = [
      BlocProvider(
        create: (_) => sl<MerchantsCubit>()..loadMerchants(),
        child: MerchantsDashboardScreen(
          showAppBar: false,
          onProfileTap: () => _selectPage(3),
        ),
      ),
      const AdsManagementScreen(),
      const MerchantFinancialRequestsScreen(),
      MerchantProfileScreen(
        onLogout: widget.onLogout,
        onSupervisedMerchantsTap: () => _selectPage(0),
      ),
    ];
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_isBarsVisible ? kToolbarHeight : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          height: _isBarsVisible ? kToolbarHeight + topPadding : 0,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isBarsVisible ? 1 : 0,
              child: FinancePageAppBar(
                title: titles[_currentIndex],
                subtitle: l10n.merchantSupervisorRoleBadge,
                showProfileButton: _currentIndex == 0,
                onProfilePressed: () => _selectPage(3),
              ),
            ),
          ),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical) {
            if (notification.direction == ScrollDirection.reverse &&
                _isBarsVisible) {
              setState(() => _isBarsVisible = false);
            } else if (notification.direction == ScrollDirection.forward &&
                !_isBarsVisible) {
              setState(() => _isBarsVisible = true);
            }
          }
          return false;
        },
        child: PageView(
          controller: _pageController,
          pageSnapping: true,
          allowImplicitScrolling: true,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: pages,
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        height: _isBarsVisible ? 76 : 0,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isBarsVisible ? 1 : 0,
            child: FinanceBottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _selectPage,
              items: navItems,
            ),
          ),
        ),
      ),
    );
  }
}
