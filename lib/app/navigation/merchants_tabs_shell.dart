import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection_container.dart';
import '../../features/finance/presentation/widgets/finance_navigation.dart';
import '../../features/wasalny_supervisor/data/wasalny_local_event_store.dart';
import '../../features/merchants/presentation/controllers/merchants_cubit.dart';
import '../../features/merchants/presentation/screens/ads_management_screen.dart';
import '../../features/merchants/presentation/screens/merchant_financial_requests_screen.dart';
import '../../features/merchants/presentation/screens/merchant_profile_screen.dart';
import '../../features/merchants/presentation/screens/merchant_supervisor_notifications_screen.dart';
import '../../features/merchants/presentation/screens/merchant_supervisor_chats_screen.dart';
import '../../features/merchants/presentation/screens/merchant_upgrade_requests_screen.dart';
import '../../features/merchants/data/merchant_conversation_local_store.dart';
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
  int _adsRefreshToken = 0;
  bool _isBarsVisible = true;
  int _unreadNotificationCount = 0;
  int _unreadChatCount = 0;
  Timer? _notificationRefreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshUnreadNotifications();
    _notificationRefreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refreshUnreadNotifications(),
    );
  }

  @override
  void dispose() {
    _notificationRefreshTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _refreshUnreadNotifications() async {
    try {
      final events = await WasalnyLocalEventStore().getEvents('merchant');
      final count = events.where((event) => !event.isRead).length;
      final messages = await MerchantConversationLocalStore().getAllMessages();
      final unreadChats = messages
          .where((message) => !message.fromSupervisor && !message.isRead)
          .length;
      if (mounted &&
          (count != _unreadNotificationCount || unreadChats != _unreadChatCount)) {
        setState(() {
          _unreadNotificationCount = count;
          _unreadChatCount = unreadChats;
        });
      }
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'merchant notifications',
        context: ErrorDescription('while refreshing unread notifications'),
      ));
    }
  }

  void _selectPage(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
      _isBarsVisible = true;
      if (index == 1) _adsRefreshToken++;
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
      FinanceNavigationItem(
        icon: Icons.upgrade,
        label: l10n.navMerchantUpgrades,
      ),
      FinanceNavigationItem(icon: Icons.person_outline, label: l10n.navAccount),
    ];
    final titles = [
      l10n.navMerchants,
      l10n.navAds,
      l10n.navFinancialRequests,
      l10n.navMerchantUpgrades,
      l10n.navAccount,
    ];
    final pages = [
      BlocProvider(
        create: (_) => sl<MerchantsCubit>()..loadMerchants(),
        child: MerchantsDashboardScreen(
          showAppBar: false,
          onProfileTap: () => _selectPage(4),
          onOpenReviewQueue: _selectPage,
        ),
      ),
      AdsManagementScreen(refreshToken: _adsRefreshToken),
      const MerchantFinancialRequestsScreen(),
      const MerchantUpgradeRequestsScreen(),
      MerchantProfileScreen(
        onLogout: widget.onLogout,
        onSupervisedMerchantsTap: () => _selectPage(0),
      ),
    ];
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                onProfilePressed: () => _selectPage(4),
                additionalActions: [
                  IconButton(
                    tooltip: l10n.localeName.startsWith('ar')
                        ? 'محادثات التجار'
                        : 'Merchant chats',
                    onPressed: () async {
                      await Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const MerchantSupervisorChatsScreen(),
                        ),
                      );
                      await _refreshUnreadNotifications();
                    },
                    icon: Badge(
                      isLabelVisible: _unreadChatCount > 0,
                      label: Text('$_unreadChatCount'),
                      child: const Icon(Icons.chat_bubble_outline),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.localeName.startsWith('ar')
                        ? 'إشعارات مشرف التجار'
                        : 'Merchant supervisor notifications',
                    onPressed: () async {
                      await Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              const MerchantSupervisorNotificationsScreen(),
                        ),
                      );
                      await _refreshUnreadNotifications();
                    },
                    icon: Badge(
                      isLabelVisible: _unreadNotificationCount > 0,
                      label: Text('$_unreadNotificationCount'),
                      child: const Icon(Icons.notifications_none_outlined),
                    ),
                  ),
                ],
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
          onPageChanged: (index) {
            if (index == _currentIndex) return;
            setState(() {
              _currentIndex = index;
              if (index == 1) _adsRefreshToken++;
            });
          },
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
