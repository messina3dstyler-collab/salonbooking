import '../models/admin_dashboard_model.dart';
import '../models/dashboard_snapshot.dart';
import '../models/today_overview_model.dart';

class DashboardStatisticsBuilder {
  const DashboardStatisticsBuilder();

  AdminDashboardModel build({
    required DashboardSnapshot snapshot,
    required TodayOverviewModel overview,
  }) {
    final customers = <String>{};
    int completed = 0;
    int cancelled = 0;

    final services = <String, int>{};
    final employees = <String, int>{};

    for (final appointment in snapshot.allAppointments) {
      if (appointment.userId.isNotEmpty) {
        customers.add(appointment.userId);
      }

      if (appointment.isCompleted) {
        completed++;
      }

      if (appointment.isCancelled) {
        cancelled++;
      }

      if (appointment.serviceName.isNotEmpty) {
        services.update(
          appointment.serviceName,
              (v) => v + 1,
          ifAbsent: () => 1,
        );
      }

      if (appointment.employeeName.isNotEmpty) {
        employees.update(
          appointment.employeeName,
              (v) => v + 1,
          ifAbsent: () => 1,
        );
      }
    }

    return AdminDashboardModel(
      todayOverview: overview,
      totalAppointments: snapshot.allAppointments.length,
      totalCustomers: customers.length,
      totalEmployees: snapshot.employees.length,
      completedAppointments: completed,
      cancelledAppointments: cancelled,
      topService: _top(services),
      topEmployee: _top(employees),
    );
  }

  String _top(Map<String, int> values) {
    if (values.isEmpty) {
      return '';
    }

    return values.entries.reduce(
          (a, b) => a.value >= b.value ? a : b,
    ).key;
  }
}