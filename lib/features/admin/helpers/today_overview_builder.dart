import '../models/dashboard_snapshot.dart';
import '../models/today_overview_model.dart';

import 'next_appointment_builder.dart';
import 'revenue_builder.dart';
import 'team_status_builder.dart';
import 'today_tasks_builder.dart';

class TodayOverviewBuilder {
  const TodayOverviewBuilder({
    NextAppointmentBuilder nextAppointmentBuilder =
    const NextAppointmentBuilder(),
    RevenueBuilder revenueBuilder = const RevenueBuilder(),
    TodayTasksBuilder tasksBuilder = const TodayTasksBuilder(),
    TeamStatusBuilder teamStatusBuilder = const TeamStatusBuilder(),
  })  : _nextAppointmentBuilder = nextAppointmentBuilder,
        _revenueBuilder = revenueBuilder,
        _tasksBuilder = tasksBuilder,
        _teamStatusBuilder = teamStatusBuilder;

  final NextAppointmentBuilder _nextAppointmentBuilder;
  final RevenueBuilder _revenueBuilder;
  final TodayTasksBuilder _tasksBuilder;
  final TeamStatusBuilder _teamStatusBuilder;

  TodayOverviewModel build(DashboardSnapshot snapshot) {
    final nextAppointment = _nextAppointmentBuilder.build(
      snapshot.todayAppointments,
    );

    final tasks = _tasksBuilder.build(
      snapshot.todayAppointments,
    );

    final revenue = _revenueBuilder.build(
      snapshot.todayAppointments,
    );

    final team = _teamStatusBuilder.build(
      employees: snapshot.employees,
      appointments: snapshot.todayAppointments,
    );

    return TodayOverviewModel(
      date: DateTime.now(),
      todayAppointments: snapshot.todayAppointments.length,
      pendingRequests: 0,
      nextAppointment: nextAppointment,
      tasks: tasks,
      revenue: revenue,
      team: team,
    );
  }
}