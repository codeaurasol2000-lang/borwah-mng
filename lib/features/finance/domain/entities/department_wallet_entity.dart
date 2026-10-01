import 'package:equatable/equatable.dart';

enum DepartmentType { merchants, usedEscrow, services, couriers }

enum DepartmentWalletChannel {
  instantSettlement,
  alRajhiMainOperating,
  scheduledPayment,
  snbEscrow,
  underInspection,
  inShipping,
  weeklySettlement,
  stcPay,
}

enum DepartmentWalletStatus {
  activeMatched,
  protectedEscrow,
  approvedProvider,
  strategicPartner,
  activeCourier,
}

class DepartmentWalletItemEntity extends Equatable {
  final String title;
  final String reference;
  final double availableBalance;
  final double pendingBalance;
  final int operationsCount;
  final DepartmentWalletChannel channel;
  final DepartmentWalletStatus status;

  const DepartmentWalletItemEntity({
    required this.title,
    required this.reference,
    required this.availableBalance,
    required this.pendingBalance,
    required this.operationsCount,
    required this.channel,
    required this.status,
  });

  @override
  List<Object?> get props => [
        title,
        reference,
        availableBalance,
        pendingBalance,
        operationsCount,
        channel,
        status,
      ];
}

class DepartmentWalletEntity extends Equatable {
  final DepartmentType type;
  final double totalBalance;
  final int primaryMetricCount;
  final int pendingMetricCount;
  final double pendingMetricAmount;
  final String feeValue;
  final List<DepartmentWalletItemEntity> items;

  const DepartmentWalletEntity({
    required this.type,
    required this.totalBalance,
    required this.primaryMetricCount,
    required this.pendingMetricCount,
    required this.pendingMetricAmount,
    required this.feeValue,
    required this.items,
  });

  @override
  List<Object?> get props => [
        type,
        totalBalance,
        primaryMetricCount,
        pendingMetricCount,
        pendingMetricAmount,
        feeValue,
        items,
      ];
}