import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/controllers/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      child: MaterialApp(
        title: 'برواح المازوري',
        debugShowCheckedModeBanner: false,

        // ضبط اللغة الافتراضية
        locale:  Locale('ar'),

        // اللغات المدعومة
        supportedLocales:  [
          Locale('ar'),
          Locale('en'),
        ],

        // مفوضات الترجمة والمحاذاة التلقائية (RTL / LTR)
        localizationsDelegates:  [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        theme: AppTheme.lightTheme,

        home: LoginScreen(),
      ),
    );
  }
}