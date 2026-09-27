import 'package:equatable/equatable.dart';

class FinanceSummaryEntity extends Equatable {
  final double totalLiquidity;                    // 4,850,200.00
  final double rajhiAccountBalance;               // 3,100,000.00
  final double snbEscrowBalance;                  // 1,750,200.00
  final int pendingMerchantWithdrawalsCount;      // 38 طلب
  final double pendingMerchantWithdrawalsAmount;  // 142,500.00
  final int pendingSupervisorWithdrawalsCount;    // 10 طلب
  final double pendingSupervisorWithdrawalsAmount;// 11,500.00
  final int pendingSubscriptionsCount;            // 18 طلب
  final double pendingSubscriptionsAmount;        // 64,200.00
  final double operationalExpenses;               // 58,400.00
  final double monthlyCommissionEarned;           // 284,900.00
  final double frozenWalletsAmount;               // 25,400.00
  final double merchantWalletBalance;             // 2,150,000.00
  final double wasalnyEscrowWalletBalance;        // 980,000.00
  final double servicesWalletBalance;             // 620,000.00
  final double deliveryWalletBalance;             // 450,000.00
  final double instantLiquidityCoverageRatio;     // 99.8%

  const FinanceSummaryEntity({
    required this.totalLiquidity,
    required this.rajhiAccountBalance,
    required this.snbEscrowBalance,
    required this.pendingMerchantWithdrawalsCount,
    required this.pendingMerchantWithdrawalsAmount,
    required this.pendingSupervisorWithdrawalsCount,
    required this.pendingSupervisorWithdrawalsAmount,
    required this.pendingSubscriptionsCount,
    required this.pendingSubscriptionsAmount,
    required this.operationalExpenses,
    required this.monthlyCommissionEarned,
    required this.frozenWalletsAmount,
    required this.merchantWalletBalance,
    required this.wasalnyEscrowWalletBalance,
    required this.servicesWalletBalance,
    required this.deliveryWalletBalance,
    required this.instantLiquidityCoverageRatio,
  });

  @override
  List<Object?> get props => [totalLiquidity, pendingMerchantWithdrawalsCount];
}