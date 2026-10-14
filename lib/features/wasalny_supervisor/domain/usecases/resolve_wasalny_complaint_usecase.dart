import '../entities/wasalny_complaint.dart';
import '../repositories/wasalny_complaints_repository.dart';

class ResolveWasalnyComplaintUseCase {
  final WasalnyComplaintsRepository repository;

  const ResolveWasalnyComplaintUseCase(this.repository);

  Future<WasalnyComplaint> call(
    String id, {
    required String note,
  }) {
    return repository.resolveComplaint(id, note: note);
  }
}
