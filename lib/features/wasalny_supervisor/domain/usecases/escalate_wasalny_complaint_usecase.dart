import '../entities/wasalny_complaint.dart';
import '../repositories/wasalny_complaints_repository.dart';

class EscalateWasalnyComplaintUseCase {
  final WasalnyComplaintsRepository repository;

  const EscalateWasalnyComplaintUseCase(this.repository);

  Future<WasalnyComplaint> call(
    String id, {
    required String reason,
  }) {
    return repository.escalateComplaint(id, reason: reason);
  }
}

