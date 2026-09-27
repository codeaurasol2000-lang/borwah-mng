import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../finance/domain/usecases/get_bank_accounts_usecase.dart';
import 'bank_accounts_state.dart';

class BankAccountsCubit extends Cubit<BankAccountsState> {
  final GetBankAccountsUseCase getBankAccountsUseCase;

  BankAccountsCubit({required this.getBankAccountsUseCase}) : super(BankAccountsInitial());

  Future<void> loadBankAccounts() async {
    emit(BankAccountsLoading());
    final result = await getBankAccountsUseCase();
    result.fold(
      (failure) => emit(BankAccountsError(failure.message)),
      (accounts) => emit(BankAccountsLoaded(accounts)),
    );
  }
}
