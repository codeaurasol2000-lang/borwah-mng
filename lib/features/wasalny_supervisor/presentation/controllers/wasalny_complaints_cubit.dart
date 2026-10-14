import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../data/wasalny_local_event_store.dart';
import '../../../products/domain/entities/product_supervisor_audit_entry.dart';
import '../../../products/domain/repositories/product_supervisor_audit_repository.dart';
import '../../domain/entities/wasalny_complaint.dart';
import '../../domain/usecases/escalate_wasalny_complaint_usecase.dart';
import '../../domain/usecases/get_wasalny_complaints_usecase.dart';
import '../../domain/usecases/resolve_wasalny_complaint_usecase.dart';

sealed class WasalnyComplaintsState {
  const WasalnyComplaintsState();
}

class WasalnyComplaintsLoading extends WasalnyComplaintsState {
  const WasalnyComplaintsLoading();
}

class WasalnyComplaintsLoadFailure extends WasalnyComplaintsState {
  final Object error;

  const WasalnyComplaintsLoadFailure(this.error);
}

class WasalnyComplaintsLoaded extends WasalnyComplaintsState {
  final List<WasalnyComplaint> complaints;

  const WasalnyComplaintsLoaded(this.complaints);
}

class WasalnyComplaintsCubit extends Cubit<WasalnyComplaintsState> {
  final GetWasalnyComplaintsUseCase getComplaints;
  final EscalateWasalnyComplaintUseCase escalateComplaint;
  final ResolveWasalnyComplaintUseCase resolveComplaint;
  final ProductSupervisorAuditRepository? auditRepository;

  WasalnyComplaintsCubit({
    required this.getComplaints,
    required this.escalateComplaint,
    required this.resolveComplaint,
    this.auditRepository,
  }) : super(const WasalnyComplaintsLoading());

  Future<void> loadComplaints() async {
    emit(const WasalnyComplaintsLoading());
    try {
      emit(WasalnyComplaintsLoaded(await getComplaints()));
    } catch (error) {
      emit(WasalnyComplaintsLoadFailure(error));
    }
  }

  Future<bool> resolve({required String id, required String note}) {
    return _updateComplaint(
      () => resolveComplaint(id, note: note),
      id,
      actionKey: 'wasalny_complaint_resolved',
      actionDetails: note,
    );
  }

  Future<bool> escalate({required String id, required String reason}) {
    return _updateComplaint(
      () => escalateComplaint(id, reason: reason),
      id,
      actionKey: 'wasalny_complaint_escalated',
      actionDetails: reason,
    );
  }

  Future<bool> _updateComplaint(
    Future<WasalnyComplaint> Function() update,
    String id, {
    required String actionKey,
    required String actionDetails,
  }) async {
    final current = state;
    if (current is! WasalnyComplaintsLoaded) return false;
    try {
      final updated = await update();
      if (actionKey == 'wasalny_complaint_escalated') {
        try {
          await WasalnyLocalEventStore().publish(
            WasalnyLocalEvent(
              id: 'head-${updated.id}',
              recipient: 'head',
              source: 'wasalny',
              titleAr: 'تصعيد شكوى وصلني',
              titleEn: 'Wasalny complaint escalated',
              messageAr:
                  '${updated.id}: ${updated.titleAr} — ${updated.actionNoteAr ?? actionDetails}',
              messageEn:
                  '${updated.id}: ${updated.titleEn} — ${updated.actionNoteEn ?? actionDetails}',
              createdAt: DateTime.now(),
            ),
          );
        } catch (error, stackTrace) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: stackTrace,
              library: 'Wasalny complaints',
              context:
                  ErrorDescription('while notifying the head supervisor'),
            ),
          );
        }
      }
      await auditRepository?.recordEntry(
        ProductSupervisorAuditEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          actionKey: actionKey,
          subject: updated.titleAr,
          details: [
            updated.id,
            if (updated.dealCode != null) updated.dealCode!,
            actionDetails,
          ].join(' • '),
          occurredAt: DateTime.now(),
        ),
      );
      emit(
        WasalnyComplaintsLoaded([
          for (final complaint in current.complaints)
            complaint.id == id ? updated : complaint,
        ]),
      );
      return true;
    } catch (error) {
      emit(WasalnyComplaintsLoadFailure(error));
      return false;
    }
  }
}
