import 'package:flutter/material.dart';

import '../screens/expenses_management_screen.dart';
import '../screens/frozen_requests_screen.dart';
import '../screens/merchant_withdrawals_screen.dart';
import '../screens/subscriptions_screen.dart';

class FinanceNavigation {
  const FinanceNavigation._();

  static void openTab(
    BuildContext context,
    int index, {
    required int currentIndex,
  }) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FrozenRequestsScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ExpensesManagementScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubscriptionsScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MerchantWithdrawalsScreen()),
      );
    } else if (index == 4 && currentIndex != 4) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}

class FinanceSwipeNavigation extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const FinanceSwipeNavigation({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity.abs() < 100) return;

        final targetIndex = velocity < 0 ? currentIndex - 1 : currentIndex + 1;
        if (targetIndex >= 0 && targetIndex <= 4) {
          FinanceNavigation.openTab(
            context,
            targetIndex,
            currentIndex: currentIndex,
          );
        }
      },
      child: child,
    );
  }
}
