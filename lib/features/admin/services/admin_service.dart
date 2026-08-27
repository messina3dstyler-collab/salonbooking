import '../models/admin_dashboard_model.dart';
import '../repositories/admin_repository.dart';

class AdminService {
  AdminService(this._repository);

  final AdminRepository _repository;

  Future<AdminDashboardModel> getDashboard(
      String salonId,
      ) {
    return _repository.getDashboard(
      salonId,
    );
  }
}