import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _compactFormatter = NumberFormat('#,##0', 'en_US');

  static String format(
    double amount, {
    bool showDecimals = true,
    bool includeCurrency = true,
  }) {
    final value = showDecimals
        ? _formatter.format(amount)
        : _compactFormatter.format(amount);
    return includeCurrency ? '$value EGP' : value;
  }
}
