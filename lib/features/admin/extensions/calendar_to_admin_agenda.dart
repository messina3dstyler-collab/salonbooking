import '../../employee/models/employee_calendar_model.dart';
import '../models/admin_agenda_item.dart';

extension CalendarToAdminAgenda on EmployeeCalendarModel {
  AdminAgendaItem toAdminAgendaItem({
    required String employeeName,
  }) {
    return AdminAgendaItem(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      start: startDate,
      end: endDate,
      type: switch (type) {
        CalendarEventType.vacation => AdminAgendaItemType.vacation,
        CalendarEventType.sick => AdminAgendaItemType.sick,
        CalendarEventType.breakTime => AdminAgendaItemType.breakTime,
        CalendarEventType.meeting => AdminAgendaItemType.meeting,
        CalendarEventType.blocked => AdminAgendaItemType.blocked,
      },
      title: title.isEmpty ? _defaultTitle(type) : title,
      subtitle: '',
      note: note,
      calendarEvent: this,
    );
  }

  String _defaultTitle(
      CalendarEventType type,
      ) {
    switch (type) {
      case CalendarEventType.vacation:
        return 'Ferie';
      case CalendarEventType.sick:
        return 'Malattia';
      case CalendarEventType.breakTime:
        return 'Pausa';
      case CalendarEventType.meeting:
        return 'Riunione';
      case CalendarEventType.blocked:
        return 'Bloccato';
    }
  }
}