import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../wasalny_supervisor/data/wasalny_local_event_store.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/repositories/finance_repository.dart';
import '../widgets/withdrawal_request_details_sheet.dart';

Future<void> openFinancialRequestNotice(
  BuildContext context,
  WasalnyLocalEvent event,
) async {
  final requestId = event.requestId;
  if (requestId == null || requestId.isEmpty) return;

  try {
    final repository = sl<FinanceRepository>();
    final merchantResult = await repository.getMerchantWithdrawals();
    final merchantRequests = merchantResult.fold(
      (failure) => throw StateError(failure.message),
      (items) => items,
    );
    WithdrawalRequestEntity? request;
    for (final item in merchantRequests) {
      if (item.id == requestId) {
        request = item;
        break;
      }
    }
    if (request == null) {
      final supervisorResult = await repository.getSupervisorWithdrawals();
      final supervisorRequests = supervisorResult.fold(
        (failure) => throw StateError(failure.message),
        (items) => items,
      );
      for (final item in supervisorRequests) {
        if (item.id == requestId) {
          request = item;
          break;
        }
      }
    }

    if (!context.mounted) return;
    if (request == null) {
      AppSnackBar.showError(
        context,
        AppLocalizations.of(context)!.financeRequestDecisionFailed,
      );
      return;
    }
    await showWithdrawalRequestDetailsSheet(context, request);
  } on Object catch (error, stackTrace) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'financial request notification',
      context: ErrorDescription('while opening the linked financial request'),
    ));
    if (context.mounted) {
      AppSnackBar.showError(
        context,
        AppLocalizations.of(context)!.financeRequestDecisionFailed,
      );
    }
  }
}
