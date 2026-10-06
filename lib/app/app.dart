import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/app_locale_controller.dart';
import '../features/auth/presentation/controllers/auth_cubit.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../l10n/app_localizations.dart';
import 'navigation/finance_tabs_shell.dart';
import 'navigation/merchants_tabs_shell.dart';

class BarwahApp extends StatelessWidget {
  const BarwahApp({super.key});

  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  void _openFinance(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => FinanceTabsShell(onLogout: _logout),
      ),
    );
  }

  void _openMerchants(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => MerchantsTabsShell(onLogout: _logout),
      ),
    );
  }

  void _logout() {
    final navigator = _navigatorKey.currentState;
    final context = _navigatorKey.currentContext;
    if (navigator == null || context == null) {
      throw StateError('Cannot log out before the app navigator is ready.');
    }

    context.read<AuthCubit>().logout();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: _buildLogin),
      (_) => false,
    );
  }

  Widget _buildLogin(BuildContext context) {
    return LoginScreen(
      onFinancialLogin: () => _openFinance(context),
      onMerchantLogin: () => _openMerchants(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: AnimatedBuilder(
        animation: AppLocaleController.instance,
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
            debugShowCheckedModeBanner: false,
            locale: AppLocaleController.instance.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppTheme.lightTheme,
            builder: (context, child) {
              final isArabic = AppLocaleController.instance.isArabic;

              return Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: Builder(builder: _buildLogin),
          );
        },
      ),
    );
  }
}
