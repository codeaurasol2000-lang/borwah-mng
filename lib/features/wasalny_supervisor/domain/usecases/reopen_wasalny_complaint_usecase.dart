import '../entities/wasalny_complaint.dart';
import '../repositories/wasalny_complaints_repository.dart';

class ReopenWasalnyComplaintUseCase {
  final WasalnyComplaintsRepository repository;

  const ReopenWasalnyComplaintUseCase(this.repository);

  Future<WasalnyComplaint> call(String id, {required String note}) {
    return repository.reopenComplaint(id, note: note);
  }
}
