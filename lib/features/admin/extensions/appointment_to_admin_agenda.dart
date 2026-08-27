import '../models/admin_appointment_model.dart';
import '../models/admin_agenda_item.dart';

extension AppointmentToAdminAgenda on AdminAppointmentModel {
  AdminAgendaItem toAdminAgendaItem() {
    final start = appointmentDate;
    final end = start.add(
      Duration(minutes: serviceDuration),
    );

    return AdminAgendaItem(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      start: start,
      end: end,
      type: AdminAgendaItemType.appointment,
      title: customerName.isEmpty
          ? serviceName
          : customerName,
      subtitle: serviceName,
      note: notes,
      appointment: this,
    );
  }
}