import '../../../domain/entities/bank_link_request_entity.dart';

class BankReconciliationState {
  final List<BankLinkRequestEntity> requests;
  final List<BankLinkRequestEntity> frozenRequests;
  final bool isLoading;
  final String? errorMessage;
  final String? processingRequestId;

  const BankReconciliationState({
    this.requests = const [],
    this.frozenRequests = const [],
    this.isLoading = false,
    this.errorMessage,
    this.processingRequestId,
  });

  BankReconciliationState copyWith({
    List<BankLinkRequestEntity>? requests,
    List<BankLinkRequestEntity>? frozenRequests,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? processingRequestId,
    bool clearProcessingRequestId = false,
  }) =>
      BankReconciliationState(
        requests: requests ?? this.requests,
        frozenRequests: frozenRequests ?? this.frozenRequests,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        processingRequestId: clearProcessingRequestId
            ? null
            : processingRequestId ?? this.processingRequestId,
      );
}
