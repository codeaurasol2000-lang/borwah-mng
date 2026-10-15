import 'package:shared_preferences/shared_preferences.dart';

class FinanceSupervisorPayoutDetails {
  final String accountHolderName;
  final String bankName;
  final String iban;

  const FinanceSupervisorPayoutDetails({
    required this.accountHolderName,
    required this.bankName,
    required this.iban,
  });

  bool get isComplete =>
      accountHolderName.trim().isNotEmpty &&
      bankName.trim().isNotEmpty &&
      iban.trim().isNotEmpty;

  String get maskedIban {
    final normalized = iban.replaceAll(RegExp(r'\s+'), '');
    if (normalized.length < 8) return normalized;
    return '${normalized.substring(0, 4)} **** **** ${normalized.substring(normalized.length - 4)}';
  }
}

class FinanceSupervisorPayoutDetailsStore {
  static const _accountHolderNameKey =
      'finance_supervisor_personal_account_holder_v1';
  static const _bankNameKey = 'finance_supervisor_personal_bank_name_v1';
  static const _ibanKey = 'finance_supervisor_personal_iban_v1';

  Future<FinanceSupervisorPayoutDetails> load() async {
    final preferences = await SharedPreferences.getInstance();
    return FinanceSupervisorPayoutDetails(
      accountHolderName: preferences.getString(_accountHolderNameKey) ?? '',
      bankName: preferences.getString(_bankNameKey) ?? '',
      iban: preferences.getString(_ibanKey) ?? '',
    );
  }

  Future<void> save(FinanceSupervisorPayoutDetails details) async {
    final preferences = await SharedPreferences.getInstance();
    final holderSaved = await preferences.setString(
      _accountHolderNameKey,
      details.accountHolderName.trim(),
    );
    final bankSaved = await preferences.setString(
      _bankNameKey,
      details.bankName.trim(),
    );
    final ibanSaved = await preferences.setString(
      _ibanKey,
      details.iban.replaceAll(RegExp(r'\s+'), '').toUpperCase(),
    );
    if (!holderSaved || !bankSaved || !ibanSaved) {
      throw StateError('Personal payout details could not be saved.');
    }
  }
}
