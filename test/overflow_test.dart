import 'package:barwah_app/core/di/injection_container.dart' as di;
import 'package:barwah_app/core/utils/app_locale_controller.dart';
import 'package:barwah_app/features/auth/presentation/controllers/auth_cubit.dart';
import 'package:barwah_app/features/auth/presentation/screens/login_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/bank_accounts_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/bank_reconciliation_screen.dart';
import 'package:barwah_app/features/finance/domain/entities/department_wallet_entity.dart';
import 'package:barwah_app/features/finance/presentation/screens/department_wallet_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/edit_matrix_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/expenses_management_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/frozen_requests_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/merchant_withdrawals_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/profile_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/subscriptions_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/supervisor_withdrawals_screen.dart';
import 'package:barwah_app/features/finance/presentation/screens/transaction_history_screen.dart';
import 'package:barwah_app/features/finance/presentation/widgets/finance_tabs_shell.dart';
import 'package:barwah_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildTestScreen(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => AuthCubit()),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: child,
    ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await di.initDependencies();
  });

  setUp(() async {
    await AppLocaleController.instance.setLocale('en');
  });

  Future<void> testScreen(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildTestScreen(widget));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('Test LoginScreen in English', (tester) async {
    await testScreen(tester, const LoginScreen());
  });

  testWidgets('Test FinanceTabsShell in English', (tester) async {
    await testScreen(tester, const FinanceTabsShell());
  });

  testWidgets('Test ProfileScreen in English', (tester) async {
    await testScreen(tester, const ProfileScreen());
  });

  testWidgets('Test BankAccountsScreen in English', (tester) async {
    await testScreen(tester, const BankAccountsScreen());
  });

  testWidgets('Test DepartmentWalletScreen in English', (tester) async {
    await testScreen(tester, const DepartmentWalletScreen(type: DepartmentType.couriers));
  });

  testWidgets('Test ExpensesManagementScreen in English', (tester) async {
    await testScreen(tester, const ExpensesManagementScreen());
  });

  testWidgets('Test FrozenRequestsScreen in English', (tester) async {
    await testScreen(tester, const FrozenRequestsScreen());
  });

  testWidgets('Test MerchantWithdrawalsScreen in English', (tester) async {
    await testScreen(tester, const MerchantWithdrawalsScreen());
  });

  testWidgets('Test SubscriptionsScreen in English', (tester) async {
    await testScreen(tester, const SubscriptionsScreen());
  });

  testWidgets('Test SupervisorWithdrawalsScreen in English', (tester) async {
    await testScreen(tester, const SupervisorWithdrawalsScreen());
  });

  testWidgets('Test EditMatrixScreen in English', (tester) async {
    await testScreen(tester, const EditMatrixScreen());
  });

  testWidgets('Test TransactionHistoryScreen in English', (tester) async {
    await testScreen(tester, const TransactionHistoryScreen(
      title: 'Test Wallet',
      id: 'WAL-123',
      availableBalance: 50000.0,
    ));
  });

  testWidgets('Test BankReconciliationScreen in English', (tester) async {
    await testScreen(tester, const BankReconciliationScreen());
  });
}
