import '../entities/wasalny_complaint.dart';
import '../repositories/wasalny_complaints_repository.dart';

class InspectWasalnyComplaintUseCase {
  final WasalnyComplaintsRepository repository;

  const InspectWasalnyComplaintUseCase(this.repository);

  Future<WasalnyComplaint> call(
    String id, {
    required String notes,
  }) {
    return repository.inspectComplaint(id, notes: notes);
  }
}

