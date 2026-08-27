import '../../employee/models/employee_calendar_model.dart';
import '../models/admin_agenda_item.dart';

extension CalendarToAgenda on EmployeeCalendarModel {
  AdminAgendaItem toAgendaItem() {
    return AdminAgendaItem(
      id: id,
      employeeId: employeeId,
      employeeName: '',
      start: startDate,
      end: endDate,
      title: title.isEmpty ? _defaultTitle(type) : title,
      note: note,
      type: _convert(type),
      calendarEvent: this,
    );
  }
}

AdminAgendaItemType _convert(CalendarEventType type) {
  switch (type) {
    case CalendarEventType.vacation:
      return AdminAgendaItemType.vacation;
    case CalendarEventType.sick:
      return AdminAgendaItemType.sick;
    case CalendarEventType.breakTime:
      return AdminAgendaItemType.breakTime;
    case CalendarEventType.meeting:
      return AdminAgendaItemType.meeting;
    case CalendarEventType.blocked:
      return AdminAgendaItemType.blocked;
  }
}

String _defaultTitle(CalendarEventType type) {
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