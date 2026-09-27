import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _compactFormatter = NumberFormat('#,##0', 'en_US');

  static String format(double amount, {bool showDecimals = true}) {
    if (showDecimals) {
      return '${_formatter.format(amount)} ر.س';
    }
    return '${_compactFormatter.format(amount)} ر.س';
  }
}