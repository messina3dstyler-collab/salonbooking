import '../datasource/admin_dashboard_datasource.dart';
import '../models/admin_dashboard_model.dart';

import 'admin_dashboard_repository.dart';

class AdminDashboardRepositoryImpl implements AdminDashboardRepository {
  AdminDashboardRepositoryImpl({
    required AdminDashboardDatasource datasource,
  }) : _datasource = datasource;

  final AdminDashboardDatasource _datasource;

  @override
  Future<AdminDashboardModel> getDashboard({
    required String salonId,
  }) {
    return _datasource.getDashboard(
      salonId: salonId,
    );
  }

  @override
  Stream<AdminDashboardModel> watchDashboard({
    required String salonId,
  }) {
    return _datasource.watchDashboard(
      salonId: salonId,
    );
  }
}