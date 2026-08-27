import '../../employee/services/employee_calendar_service.dart';
import '../extensions/appointment_to_admin_agenda.dart';
import '../extensions/calendar_to_admin_agenda.dart';
import '../models/admin_agenda_item.dart';
import 'admin_appointments_service.dart';

class AdminAgendaService {
  const AdminAgendaService(
      this._appointmentsService,
      this._calendarService,
      );

  final AdminAppointmentsService _appointmentsService;
  final EmployeeCalendarService _calendarService;

  Future<List<AdminAgendaItem>> loadAgenda({
    required String salonId,
    required DateTime date,
    required Map<String, String> employeeNames,
  }) async {
    final agenda = <AdminAgendaItem>[];

    final appointments = await _appointmentsService.getAppointmentsByDate(
      salonId: salonId,
      date: date,
    );

    agenda.addAll(
      appointments.map(
            (e) => e.toAdminAgendaItem(),
      ),
    );

    for (final employeeId in employeeNames.keys) {
      final events = await _calendarService.getEventsByEmployeeAndDate(
        employeeId: employeeId,
        date: date,
      );

      agenda.addAll(
        events.map(
              (e) => e.toAdminAgendaItem(
            employeeName: employeeNames[e.employeeId] ?? 'Operatore',
          ),
        ),
      );
    }

    agenda.sort(
          (a, b) => a.start.compareTo(b.start),
    );

    return agenda;
  }
}