import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../core/di/injection_container.dart';
import '../../features/finance/presentation/widgets/finance_navigation.dart';
import '../../features/products/presentation/controllers/product_review_cubit.dart';
import '../../features/products/presentation/screens/product_ads_review_screen.dart';
import '../../features/products/presentation/screens/product_promotions_screen.dart';
import '../../features/products/presentation/screens/product_reports_screen.dart';
import '../../features/products/presentation/screens/product_supervisor_profile_screen.dart';
import '../../features/products/presentation/screens/product_supervisor_chats_screen.dart';
import '../../features/products/presentation/screens/product_supervisor_notifications_screen.dart';
import '../../features/products/presentation/screens/product_supervisor_complaints_screen.dart';
import '../../features/products/presentation/screens/product_supervisor_dashboard_screen.dart';
import '../../features/wasalny_supervisor/data/wasalny_local_event_store.dart';
import '../../l10n/app_localizations.dart';

class ProductSupervisorTabsShell extends StatefulWidget {
  final VoidCallback onLogout;

  const ProductSupervisorTabsShell({super.key, required this.onLogout});

  @override
  State<ProductSupervisorTabsShell> createState() =>
      _ProductSupervisorTabsShellState();
}

class _ProductSupervisorTabsShellState
    extends State<ProductSupervisorTabsShell> {
  late final PageController _pageController = PageController(initialPage: 4);
  int _currentIndex = 4;
  bool _isBarsVisible = true;
  int _unreadNotificationCount = 0;
  Timer? _notificationRefreshTimer;

  @override
  void dispose() {
    _notificationRefreshTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _refreshUnreadNotifications();
    _notificationRefreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refreshUnreadNotifications(),
    );
  }

  Future<void> _refreshUnreadNotifications() async {
    try {
      final events = await WasalnyLocalEventStore().getEvents('products');
      final unreadCount = events.where((event) => !event.isRead).length;
      if (mounted && unreadCount != _unreadNotificationCount) {
        setState(() => _unreadNotificationCount = unreadCount);
      }
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'product supervisor notifications',
        context: ErrorDescription('while refreshing the unread count'),
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
    final navItems = [
      FinanceNavigationItem(
        icon: Icons.person_outline,
        label: l10n.productAccountTab,
      ),
      FinanceNavigationItem(
        icon: Icons.bar_chart_outlined,
        label: l10n.productReportsTab,
      ),
      FinanceNavigationItem(
        icon: Icons.workspace_premium_outlined,
        label: l10n.productSubscriptionsTab,
      ),
      FinanceNavigationItem(
        icon: Icons.pending_actions_outlined,
        label: l10n.productReviewTab,
      ),
      FinanceNavigationItem(
        icon: Icons.dashboard_outlined,
        label: l10n.navHome,
      ),
    ];
    final titles = [
      l10n.productAccountTab,
      l10n.productReportsTab,
      l10n.productSubscriptionsTab,
      l10n.productReviewTab,
      l10n.navHome,
    ];
    final pages = [
      ProductSupervisorProfileScreen(
        onLogout: widget.onLogout,
        additionalOperations: [
          _AccountShortcut(
            title: l10n.servicesComplaintsTab,
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const ProductSupervisorComplaintsScreen(),
            )),
          ),
        ],
      ),
      const ProductReportsScreen(),
      const ProductPromotionsScreen(),
      BlocProvider(
        create: (_) => sl<ProductReviewCubit>()..loadReviews(),
        child: const ProductAdsReviewScreen(),
      ),
      ProductSupervisorDashboardScreen(
        onOpenTab: _selectPage,
        onOpenComplaints: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const ProductSupervisorComplaintsScreen(),
        )),
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
                subtitle: l10n.productSupervisorRoleBadge,
                showProfileButton: true,
                onProfilePressed: () => _selectPage(0),
                additionalActions: [
                        IconButton(
                          tooltip: l10n.productChatsTitle,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  const ProductSupervisorChatsScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline),
                        ),
                        IconButton(
                          tooltip: l10n.productNotificationsTitle,
                          onPressed: () async {
                            await Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  const ProductSupervisorNotificationsScreen(),
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

class _AccountShortcut extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _AccountShortcut({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(Icons.report_gmailerrorred_outlined),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 15),
        onTap: onTap,
      );
}
