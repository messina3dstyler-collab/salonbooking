import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/dashboard_query_helper.dart';
import '../helpers/dashboard_statistics_builder.dart';
import '../helpers/today_overview_builder.dart';
import '../models/admin_dashboard_model.dart';
import '../models/dashboard_snapshot.dart';

import 'admin_dashboard_datasource.dart';

class AdminDashboardFirestoreDatasource
    implements AdminDashboardDatasource {
  AdminDashboardFirestoreDatasource({
    FirebaseFirestore? firestore,
  }) : _helper = DashboardQueryHelper(
    firestore: firestore ?? FirebaseFirestore.instance,
  );

  final DashboardQueryHelper _helper;

  final TodayOverviewBuilder _todayOverviewBuilder =
  const TodayOverviewBuilder();

  final DashboardStatisticsBuilder _statisticsBuilder =
  const DashboardStatisticsBuilder();

  @override
  Future<AdminDashboardModel> getDashboard({
    required String salonId,
  }) async {
    final snapshot = await _helper.loadDashboardSnapshot(
      salonId: salonId,
    );

    return _buildDashboard(snapshot);
  }

  @override
  Stream<AdminDashboardModel> watchDashboard({
    required String salonId,
  }) {
    return _helper.watchDashboardSnapshot(
      salonId: salonId,
    ).map(_buildDashboard);
  }

  AdminDashboardModel _buildDashboard(
      DashboardSnapshot snapshot,
      ) {
    final overview = _todayOverviewBuilder.build(snapshot);

    return _statisticsBuilder.build(
      snapshot: snapshot,
      overview: overview,
    );
  }
}