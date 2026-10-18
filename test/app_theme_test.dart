import 'package:barwah_app/core/constants/app_colors.dart';
import 'package:barwah_app/core/theme/app_theme.dart';
import 'package:barwah_app/core/utils/app_theme_controller.dart';
import 'package:barwah_app/core/widgets/theme_mode_menu_button.dart';
import 'package:barwah_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppThemeController.instance.load();
  });

  test('light theme retains its existing core colors', () {
    final theme = AppTheme.lightTheme;

    expect(theme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, AppColors.backgroundLight);
    expect(theme.colorScheme.primary, AppColors.primaryDark);
    expect(theme.colorScheme.surface, AppColors.surface);
  });

  test('theme mode defaults to light and persists user selection', () async {
    final controller = AppThemeController.instance;
    final preferences = await SharedPreferences.getInstance();

    expect(controller.mode, ThemeMode.light);

    await controller.setMode(ThemeMode.dark);
    expect(controller.mode, ThemeMode.dark);
    expect(preferences.getString('app_theme_mode'), 'dark');

    await controller.setMode(ThemeMode.system);
    expect(controller.mode, ThemeMode.system);
    expect(preferences.getString('app_theme_mode'), 'system');
  });

  testWidgets('appearance menu switches the app theme immediately',
      (tester) async {
    final controller = AppThemeController.instance;
    await controller.setMode(ThemeMode.light);

    await tester.pumpWidget(
      AnimatedBuilder(
        animation: controller,
        builder: (context, _) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: controller.mode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(
              actions: const [ThemeModeMenuButton()],
            ),
            body: Builder(
              builder: (context) => Text(Theme.of(context).brightness.name),
            ),
          ),
        ),
      ),
    );

    expect(find.text('light'), findsOneWidget);
    await tester.tap(find.byTooltip('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(find.text('dark'), findsOneWidget);
  });
}
