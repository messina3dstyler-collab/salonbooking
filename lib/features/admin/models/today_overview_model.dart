import 'next_appointment_model.dart';
import 'revenue_overview_model.dart';
import 'team_member_model.dart';
import 'today_tasks_model.dart';
import 'employee_status.dart';

class TodayOverviewModel {
  const TodayOverviewModel({
    required this.date,
    required this.todayAppointments,
    required this.pendingRequests,
    required this.nextAppointment,
    required this.tasks,
    required this.revenue,
    required this.team,
  });

  //--------------------------------------------------
  // DATI
  //--------------------------------------------------

  final DateTime date;

  final int todayAppointments;

  final int pendingRequests;

  final NextAppointmentModel nextAppointment;

  final TodayTasksModel tasks;

  final RevenueOverviewModel revenue;

  final List<TeamMemberModel> team;

  //--------------------------------------------------
  // FACTORY
  //--------------------------------------------------

  factory TodayOverviewModel.empty() {
    return TodayOverviewModel(
      date: DateTime.now(),
      todayAppointments: 0,
      pendingRequests: 0,
      nextAppointment: NextAppointmentModel.empty(),
      tasks: TodayTasksModel.empty(),
      revenue: RevenueOverviewModel.empty(),
      team: const [],
    );
  }

  //--------------------------------------------------
  // COPY
  //--------------------------------------------------

  TodayOverviewModel copyWith({
    DateTime? date,
    int? todayAppointments,
    int? pendingRequests,
    NextAppointmentModel? nextAppointment,
    TodayTasksModel? tasks,
    RevenueOverviewModel? revenue,
    List<TeamMemberModel>? team,
  }) {
    return TodayOverviewModel(
      date: date ?? this.date,
      todayAppointments:
      todayAppointments ?? this.todayAppointments,
      pendingRequests:
      pendingRequests ?? this.pendingRequests,
      nextAppointment:
      nextAppointment ?? this.nextAppointment,
      tasks: tasks ?? this.tasks,
      revenue: revenue ?? this.revenue,
      team: team ?? this.team,
    );
  }

  //--------------------------------------------------
  // HELPERS
  //--------------------------------------------------

  bool get hasAppointments =>
      todayAppointments > 0;

  bool get hasPendingRequests =>
      pendingRequests > 0;

  bool get hasTeam =>
      team.isNotEmpty;

  bool get hasNextAppointment =>
      nextAppointment.hasAppointment;

  bool get hasRevenue =>
      revenue.expectedRevenue > 0;

  bool get hasTasks =>
      tasks.hasTasks;

  int get availableEmployees =>
      team
          .where(
            (e) =>
        e.status == EmployeeStatus.available,
      )
          .length;

  int get busyEmployees =>
      team
          .where(
            (e) =>
        e.status == EmployeeStatus.busy,
      )
          .length;

  int get pausedEmployees =>
      team
          .where(
            (e) =>
        e.status == EmployeeStatus.pause,
      )
          .length;

  int get offlineEmployees =>
      team
          .where(
            (e) =>
        e.status == EmployeeStatus.offline,
      )
          .length;
}