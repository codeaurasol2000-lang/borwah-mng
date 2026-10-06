import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/expense_request_entity.dart';
import '../../../domain/usecases/get_expense_requests_usecase.dart';
import '../../../domain/usecases/submit_expense_request_usecase.dart';
import 'expense_requests_state.dart';

class ExpenseRequestsCubit extends Cubit<ExpenseRequestsState> {
  final GetExpenseRequestsUseCase getExpenseRequestsUseCase;
  final SubmitExpenseRequestUseCase submitExpenseRequestUseCase;

  ExpenseRequestsCubit({
    required this.getExpenseRequestsUseCase,
    required this.submitExpenseRequestUseCase,
  }) : super(const ExpenseRequestsState());

  Future<void> loadRequests() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await getExpenseRequestsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (requests) => emit(state.copyWith(
        requests: requests,
        isLoading: false,
        clearError: true,
      )),
    );
  }

  Future<Either<Failure, ExpenseRequestEntity>> submitRequest({
    required double amount,
    required String bankAccountId,
    required String reason,
    String? attachmentName,
  }) async {
    if (state.isSubmitting) {
      return const Left(ServerFailure());
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await submitExpenseRequestUseCase(
      amount: amount,
      bankAccountId: bankAccountId,
      reason: reason,
      attachmentName: attachmentName,
    );

    return result.fold(
      (failure) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        ));
        return Left(failure);
      },
      (request) {
        emit(state.copyWith(
          requests: [...state.requests, request],
          isSubmitting: false,
          clearError: true,
        ));
        return Right(request);
      },
    );
  }
}
