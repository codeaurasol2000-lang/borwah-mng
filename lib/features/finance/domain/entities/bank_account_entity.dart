import 'package:equatable/equatable.dart';

enum AccountType { bank, eWallet }

class BankAccountEntity extends Equatable {
  final String id;
  final String title;              // اسم البنك أو المحفظة
  final String subTitle;           // نوع الحساب أو الغرض
  final String ibanOrNumber;       // رقم الآيبان أو رقم المحفظة
  final double currentBalance;      // الرصيد الدفتري الحالي
  final String? secondaryBalanceNote;
  final AccountType type;
  final String status;             // نشط، تجميد للأمانات، مجاني
  final bool isVerified;

  const BankAccountEntity({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.ibanOrNumber,
    required this.currentBalance,
    this.secondaryBalanceNote,
    required this.type,
    required this.status,
    this.isVerified = true,
  });

  @override
  List<Object?> get props => [id, title, ibanOrNumber, currentBalance];
}