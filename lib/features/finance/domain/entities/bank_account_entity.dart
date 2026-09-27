class BankAccountEntity {
  final String id;
  final String bankName;
  final String accountRole;
  final String accountType;
  final String iban;
  final double balance; // إضافة المتغير هنا
  final bool isVerified;

  const BankAccountEntity({
    required this.id,
    required this.bankName,
    required this.accountRole,
    required this.accountType,
    required this.iban,
    required this.balance,
    this.isVerified = true,
  });
}