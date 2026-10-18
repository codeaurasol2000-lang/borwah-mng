import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../core/widgets/local_event_inbox_screen.dart';
import '../../l10n/app_localizations.dart';

import '../../features/finance/presentation/screens/audit_screen.dart';
import '../../features/finance/presentation/screens/bank_reconciliation_screen.dart';
import '../../features/finance/presentation/screens/commissions_screen.dart';
import '../../features/finance/presentation/screens/finance_dashboard_screen.dart';
import '../../features/finance/presentation/screens/finance_supervisor_chats_screen.dart';
import '../../features/finance/presentation/utils/open_financial_request_notice.dart';
import '../../features/wasalny_supervisor/data/wasalny_local_event_store.dart';
import '../../features/finance/presentation/screens/profile_screen.dart';
import '../../features/finance/presentation/screens/settlements_screen.dart';
import '../../features/finance/presentation/widgets/finance_navigation.dart';

class FinanceTabsShell extends StatefulWidget {
  final VoidCallback onLogout;

  const FinanceTabsShell({super.key, required this.onLogout});

  @override
  State<FinanceTabsShell> createState() => _FinanceTabsShellState();
}

class _FinanceTabsShellState extends State<FinanceTabsShell> {
  late final PageController _pageController = PageController(initialPage: 4);
  int _currentIndex = 4;
  bool _isBarsVisible = true;
  int _unreadNotificationCount = 0;
  Timer? _notificationRefreshTimer;

  late final _pages = <Widget>[
    const AuditScreen(showBottomNavigation: false),
    const CommissionsScreen(showBottomNavigation: false),
    const SettlementsScreen(showBottomNavigation: false),
    const BankReconciliationScreen(showBottomNavigation: false),
    FinanceDashboardScreen(
      showBottomNavigation: false,
      onLogout: widget.onLogout,
    ),
  ];

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
      final events = await WasalnyLocalEventStore().getEvents('finance');
      final count = events.where((event) => !event.isRead).length;
      if (mounted && count != _unreadNotificationCount) {
        setState(() => _unreadNotificationCount = count);
      }
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance notifications',
        context: ErrorDescription('while refreshing unread notifications'),
      ));
    }
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                subtitle: _currentIndex == 4
                    ? l10n.cfoRole
                    : l10n.financialDepartment,
                showProfileButton: _currentIndex == 4,
                onProfilePressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(onLogout: widget.onLogout),
                  ),
                ),
                additionalActions: [
                  IconButton(
                    tooltip: l10n.localeName.startsWith('ar')
                        ? 'الدردشات'
                        : 'Chats',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const FinanceSupervisorChatsScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline),
                  ),
                  IconButton(
                    tooltip: l10n.productNotificationsTitle,
                    onPressed: () async {
                      await Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => LocalEventInboxScreen(
                            recipient: 'finance',
                            title: l10n.productNotificationsTitle,
                            onOpenEvent: (event) =>
                                openFinancialRequestNotice(context, event),
                          ),
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
