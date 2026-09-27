import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_colors.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/controllers/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة حقن التبعيات (GetIt)
  await di.initDependencies();

  runApp( BarwahApp());
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

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryDark,
            primary: AppColors.primaryDark,
          ),
          appBarTheme:  AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
          ),
        ),

        home: LoginScreen(),
      ),
    );
  }
}