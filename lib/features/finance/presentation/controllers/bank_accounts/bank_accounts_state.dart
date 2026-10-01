import 'package:equatable/equatable.dart';
import '../../../domain/entities/bank_account_entity.dart';

abstract class BankAccountsState extends Equatable {
  const BankAccountsState();

  @override
  List<Object> get props => [];
}

class BankAccountsInitial extends BankAccountsState {}

class BankAccountsLoading extends BankAccountsState {}

class BankAccountsLoaded extends BankAccountsState {
  final List<BankAccountEntity> accounts;

  const BankAccountsLoaded(this.accounts);

  @override
  List<Object> get props => [accounts];
}

class BankAccountsError extends BankAccountsState {
  final String message;

  const BankAccountsError(this.message);

  @override
  List<Object> get props => [message];
}
