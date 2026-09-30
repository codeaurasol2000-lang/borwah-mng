import 'package:flutter/material.dart';

import '../screens/bank_reconciliation_screen.dart';
import '../screens/settlements_screen.dart';

class FinanceNavigation {
  const FinanceNavigation._();

  static void openTab(
    BuildContext context,
    int index, {
    required int currentIndex,
  }) {
    if (index == currentIndex) return;

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettlementsScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BankReconciliationScreen()),
      );
    } else if (index == 4 && currentIndex != 4) {
      Navigator.pop(context);
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
        if (velocity == 0) return;

        final targetIndex = velocity < 0 ? currentIndex - 1 : currentIndex + 1;
        if (targetIndex >= 2 && targetIndex <= 4) {
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
