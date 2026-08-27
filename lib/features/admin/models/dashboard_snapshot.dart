import '../../appointment/models/appointment_model.dart';
import '../../employee/models/employee_model.dart';

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.todayAppointments,
    required this.allAppointments,
    required this.employees,
  });

  final List<AppointmentModel> todayAppointments;
  final List<AppointmentModel> allAppointments;
  final List<EmployeeModel> employees;

  int get totalAppointments => allAppointments.length;

  int get totalEmployees => employees.length;
}