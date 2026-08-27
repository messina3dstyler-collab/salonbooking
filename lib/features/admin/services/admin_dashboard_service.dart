import '../models/admin_dashboard_model.dart';
import '../repositories/admin_dashboard_repository.dart';

class AdminDashboardService {
  AdminDashboardService(this._repository);

  final AdminDashboardRepository _repository;

  Future<AdminDashboardModel> getDashboard({
    required String salonId,
  }) {
    return _repository.getDashboard(
      salonId: salonId,
    );
  }

  Stream<AdminDashboardModel> watchDashboard({
    required String salonId,
  }) {
    return _repository.watchDashboard(
      salonId: salonId,
    );
  }
}