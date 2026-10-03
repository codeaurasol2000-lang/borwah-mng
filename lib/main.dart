import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection_container.dart' as di;
import 'core/utils/app_locale_controller.dart';
import 'features/auth/presentation/controllers/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocaleController.instance.load();

  try {
    // تهيئة حقن التبعيات (GetIt)
    await di.initDependencies();
  } catch (e, stackTrace) {
    debugPrint("DI Initialization Error: $e");
    debugPrint(stackTrace.toString());
  }

  runApp(const BarwahApp());
}

class BarwahApp extends StatelessWidget {
  const BarwahApp({super.key});

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
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
