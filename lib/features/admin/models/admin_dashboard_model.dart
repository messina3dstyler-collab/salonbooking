import 'today_overview_model.dart';

class AdminDashboardModel {
  const AdminDashboardModel({
    required this.todayOverview,
    this.totalAppointments = 0,
    this.totalCustomers = 0,
    this.totalEmployees = 0,
    this.completedAppointments = 0,
    this.cancelledAppointments = 0,
    this.topService = '',
    this.topEmployee = '',
  });

  //--------------------------------------------------
  // TODAY
  //--------------------------------------------------

  final TodayOverviewModel todayOverview;

  //--------------------------------------------------
  // GLOBAL KPI
  //--------------------------------------------------

  final int totalAppointments;
  final int totalCustomers;
  final int totalEmployees;

  final int completedAppointments;
  final int cancelledAppointments;

  //--------------------------------------------------
  // BEST
  //--------------------------------------------------

  final String topService;
  final String topEmployee;

  //--------------------------------------------------
  // FACTORY
  //--------------------------------------------------

  factory AdminDashboardModel.empty() {
    return AdminDashboardModel(
      todayOverview: TodayOverviewModel.empty(),
    );
  }

  //--------------------------------------------------
  // COPY
  //--------------------------------------------------

  AdminDashboardModel copyWith({
    TodayOverviewModel? todayOverview,
    int? totalAppointments,
    int? totalCustomers,
    int? totalEmployees,
    int? completedAppointments,
    int? cancelledAppointments,
    String? topService,
    String? topEmployee,
  }) {
    return AdminDashboardModel(
      todayOverview: todayOverview ?? this.todayOverview,
      totalAppointments:
      totalAppointments ?? this.totalAppointments,
      totalCustomers:
      totalCustomers ?? this.totalCustomers,
      totalEmployees:
      totalEmployees ?? this.totalEmployees,
      completedAppointments:
      completedAppointments ??
          this.completedAppointments,
      cancelledAppointments:
      cancelledAppointments ??
          this.cancelledAppointments,
      topService: topService ?? this.topService,
      topEmployee: topEmployee ?? this.topEmployee,
    );
  }

  //--------------------------------------------------
  // COMPATIBILITÀ
  //--------------------------------------------------

  int get todayAppointments =>
      todayOverview.todayAppointments;

  int get pendingRequests =>
      todayOverview.pendingRequests;

  double get todayRevenue =>
      todayOverview.revenue.today;

  String get formattedRevenue =>
      "€ ${todayRevenue.toStringAsFixed(2)}";

  //--------------------------------------------------
  // HELPERS
  //--------------------------------------------------

  bool get hasAppointments =>
      totalAppointments > 0;

  bool get hasCustomers =>
      totalCustomers > 0;

  bool get hasEmployees =>
      totalEmployees > 0;

  bool get hasRevenue =>
      todayRevenue > 0;
}