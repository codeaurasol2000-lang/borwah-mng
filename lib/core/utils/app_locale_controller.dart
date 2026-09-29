import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController._();

  static final instance = AppLocaleController._();

  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString('app_language');
    if (languageCode == 'ar' || languageCode == 'en') {
      _locale = Locale(languageCode!);
      notifyListeners();
    }
  }

  void toggle() {
    _locale = _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    SharedPreferences.getInstance().then(
      (preferences) => preferences.setString('app_language', _locale.languageCode),
    );
    notifyListeners();
  }
}