import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'currency_formatter.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController._();

  static final instance = AppLocaleController._();

  Locale _locale = const Locale('ar');

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> setLocale(String languageCode) async {
    if (languageCode != 'ar' && languageCode != 'en') {
      return;
    }
    if (_locale.languageCode == languageCode) return;

    _locale = Locale(languageCode);
    CurrencyFormatter.setLocale(languageCode);
    notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString('app_language', languageCode);
      if (!saved) throw StateError('Could not save the selected app language.');
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'app localization',
          context: ErrorDescription('while saving the selected language'),
        ),
      );
    }
  }

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString('app_language');
    CurrencyFormatter.setLocale(languageCode ?? _locale.languageCode);

    if (languageCode == 'ar' || languageCode == 'en') {
      final savedLanguageCode = languageCode!;
      _locale = Locale(savedLanguageCode);
      notifyListeners();
    }
  }

  Future<void> toggle() async {
    final nextLanguage = _locale.languageCode == 'ar' ? 'en' : 'ar';
    await setLocale(nextLanguage);
  }
}
