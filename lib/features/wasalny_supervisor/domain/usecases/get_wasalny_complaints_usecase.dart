import '../entities/wasalny_complaint.dart';
import '../repositories/wasalny_complaints_repository.dart';

class GetWasalnyComplaintsUseCase {
  final WasalnyComplaintsRepository repository;

  const GetWasalnyComplaintsUseCase(this.repository);

  Future<List<WasalnyComplaint>> call() {
    return repository.getComplaints();
  }
}

