import '../../domain/entities/bank_account_entity.dart';

class BankAccountModel extends BankAccountEntity {
  const BankAccountModel({
    required super.id,
    required super.title,
    required super.subTitle,
    required super.ibanOrNumber,
    required super.currentBalance,
    super.secondaryBalanceNote,
    required super.type,
    required super.status,
    super.isVerified,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subTitle: json['sub_title'] ?? '',
      ibanOrNumber: json['iban_or_number'] ?? '',
      currentBalance: (json['current_balance'] as num).toDouble(),
      secondaryBalanceNote: json['secondary_balance_note'],
      type: json['type'] == 'eWallet' ? AccountType.eWallet : AccountType.bank,
      status: json['status'] ?? '',
      isVerified: json['is_verified'] ?? true,
    );
  }
}