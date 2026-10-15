import '../models/wasalny_complaint_model.dart';

abstract class WasalnyComplaintsDataSource {
  Future<List<WasalnyComplaintModel>> getComplaints();
  Future<WasalnyComplaintModel> escalateComplaint(
    String id, {
    required String reason,
  });
  Future<WasalnyComplaintModel> resolveComplaint(
    String id, {
    required String note,
  });
  Future<WasalnyComplaintModel> inspectComplaint(
    String id, {
    required String notes,
  });
  Future<WasalnyComplaintModel> reopenComplaint(String id, {required String note});
}
