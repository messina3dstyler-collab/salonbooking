import '../models/admin_dashboard_model.dart';

abstract class AdminDashboardDatasource {
  Future<AdminDashboardModel> getDashboard({
    required String salonId,
  });

  Stream<AdminDashboardModel> watchDashboard({
    required String salonId,
  });
}