import '../../appointment/models/appointment_model.dart';
import '../../employee/models/employee_model.dart';

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.todayAppointments,
    required this.allAppointments,
    required this.employees,
    this.pendingRequests = 0,
  });

  final List<AppointmentModel> todayAppointments;
  final List<AppointmentModel> allAppointments;
  final List<EmployeeModel> employees;

  /// Numero complessivo di richieste che richiedono
  /// attenzione da parte del salone.
  ///
  /// Comprende:
  /// - richieste in pendingCustomer
  /// - richieste di cancellazione in pendingSalon
  final int pendingRequests;

  int get totalAppointments => allAppointments.length;

  int get totalEmployees => employees.length;
}