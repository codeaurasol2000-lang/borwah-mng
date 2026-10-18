import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/widgets/local_event_inbox_screen.dart';
import '../../../../features/merchants/presentation/screens/merchant_conversation_screen.dart';
import '../../../../features/finance/presentation/utils/open_financial_request_notice.dart';
import '../../../../features/finance/presentation/widgets/finance_navigation.dart';
import '../../../../l10n/app_localizations.dart';
import 'services_complaints_screen.dart';
import 'services_providers_screen.dart';
import 'services_supervisor_profile_screen.dart';
import 'services_requests_review_screen.dart';
import 'services_supervisor_dashboard_screen.dart';
import '../../../../features/wasalny_supervisor/data/wasalny_local_event_store.dart';
import '../../../../features/merchants/data/merchant_conversation_local_store.dart';

class ServicesSupervisorTabsShell extends StatefulWidget {
  final VoidCallback onLogout;

  const ServicesSupervisorTabsShell({super.key, required this.onLogout});

  @override
  State<ServicesSupervisorTabsShell> createState() =>
      _ServicesSupervisorTabsShellState();
}

class _ServicesSupervisorTabsShellState
    extends State<ServicesSupervisorTabsShell> {
  late final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  int _overviewRefreshToken = 0;
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

  void _selectPage(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
      _isBarsVisible = true;
      if (index == 0) _overviewRefreshToken++;
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
        icon: Icons.dashboard_outlined,
        label: l10n.localeName.startsWith('ar') ? 'الرئيسية' : 'Overview',
      ),
      FinanceNavigationItem(
        icon: Icons.engineering_outlined,
        label: l10n.servicesProvidersTab,
      ),
      FinanceNavigationItem(
        icon: Icons.pending_actions_outlined,
        label: l10n.servicesReviewTab,
      ),
      FinanceNavigationItem(
        icon: Icons.report_gmailerrorred_outlined,
        label: l10n.servicesComplaintsTab,
      ),
      FinanceNavigationItem(
        icon: Icons.person_outline,
        label: l10n.productAccountTab,
      ),
    ];
    final titles = navItems.map((item) => item.label).toList()
      ..[4] = l10n.servicesProfileTitle;
    final pages = [
      ServicesSupervisorDashboardScreen(
        onOpenPage: _selectPage,
        refreshToken: _overviewRefreshToken,
      ),
      const ServicesProvidersScreen(),
      const ServicesRequestsReviewScreen(),
      const ServicesComplaintsScreen(),
      ServicesSupervisorProfileScreen(onLogout: widget.onLogout),
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
                subtitle: _currentIndex == 4 || _currentIndex == 0
                    ? null
                    : l10n.servicesSupervisorRoleBadge,
                showProfileButton: _currentIndex != 4,
                onProfilePressed: () => _selectPage(4),
                showBackButton: _currentIndex == 4,
                onBackPressed: () => _selectPage(0),
                additionalActions: [
                        IconButton(
                          tooltip: l10n.servicesChatsTitle,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => MerchantConversationScreen(
                            conversationId: 'service-supervisor:general',
                                conversationTitle: l10n.servicesChatsTitle,
                              ),
                            ),
                          ),
                          icon: Badge(
                            isLabelVisible: _unreadChatCount > 0,
                            label: Text('$_unreadChatCount'),
                            child: const Icon(Icons.chat_bubble_outline),
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.servicesNotificationsTitle,
                          onPressed: () async {
                            await _showNotices(context, l10n);
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
              if (index == 0) _overviewRefreshToken++;
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

  Future<void> _showNotices(BuildContext context, AppLocalizations l10n) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => LocalEventInboxScreen(
          recipient: 'services',
          title: l10n.servicesNotificationsTitle,
          onOpenEvent: (event) => openFinancialRequestNotice(context, event),
        ),
      ),
    );
  }

  Future<void> _refreshUnreadNotifications() async {
    try {
      final events = await WasalnyLocalEventStore().getEvents('services');
      final count = events.where((event) => !event.isRead).length;
      final messages = await MerchantConversationLocalStore().getAllMessages();
      final unreadChats = messages
          .where((message) =>
              message.merchantId.startsWith('service-') &&
              !message.fromSupervisor &&
              !message.isRead)
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
        library: 'services supervisor notifications',
        context: ErrorDescription('while refreshing unread notifications'),
      ));
    }
  }
}
