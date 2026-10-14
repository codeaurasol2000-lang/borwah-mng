import 'package:flutter/foundation.dart';

import '../../../wasalny_supervisor/data/wasalny_local_event_store.dart';
import '../../domain/entities/withdrawal_request_entity.dart';

Future<void> notifyFinanceOfSupervisorRequest(
  WithdrawalRequestEntity request,
) async {
  try {
    await WasalnyLocalEventStore().publish(
      WasalnyLocalEvent(
        id: 'finance-new-${request.id}',
        recipient: 'finance',
        source: request.sourceAccount ?? 'supervisor',
        titleAr: 'طلب مالي جديد بانتظار المراجعة',
        titleEn: 'New financial request awaiting review',
        messageAr:
            '${request.beneficiaryRole} أرسل الطلب ${request.requestNumber} بمبلغ ${request.grossAmount.toStringAsFixed(2)}.',
        messageEn:
            '${request.beneficiaryRole} submitted ${request.requestNumber} for ${request.grossAmount.toStringAsFixed(2)}.',
        createdAt: DateTime.now(),
      ),
    );
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'finance request notifications',
        context: ErrorDescription('while notifying finance of a new request'),
      ),
    );
  }
}
