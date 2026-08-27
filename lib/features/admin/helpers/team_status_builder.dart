import '../../appointment/models/appointment_model.dart';
import '../../employee/models/employee_model.dart';

import '../models/employee_status.dart';
import '../models/team_member_model.dart';

class TeamStatusBuilder {
  const TeamStatusBuilder();

  List<TeamMemberModel> build({
    required List<EmployeeModel> employees,
    required List<AppointmentModel> appointments,
    DateTime? now,
  }) {
    final referenceTime = now ?? DateTime.now();

    return employees.map((employee) {
      AppointmentModel? currentAppointment;
      AppointmentModel? nextAppointment;

      for (final appointment in appointments) {
        if (appointment.employeeId != employee.id || appointment.isCancelled) {
          continue;
        }

        final start = appointment.appointmentStart;
        final end = appointment.appointmentEnd;

        if (referenceTime.isAfter(start) && referenceTime.isBefore(end)) {
          currentAppointment = appointment;
          continue;
        }

        if (start.isAfter(referenceTime) &&
            (nextAppointment == null ||
                start.isBefore(nextAppointment.appointmentStart))) {
          nextAppointment = appointment;
        }
      }

      final status = !employee.active
          ? EmployeeStatus.offline
          : currentAppointment != null
          ? EmployeeStatus.busy
          : EmployeeStatus.available;

      return TeamMemberModel(
        id: employee.id,
        name: employee.name,
        avatarUrl: employee.photoUrl,
        status: status,
        subtitle: currentAppointment?.serviceName ?? 'Disponibile',
        currentCustomer: currentAppointment?.customerName ?? '',
        nextAppointmentTime: nextAppointment == null
            ? ''
            : _formatTime(nextAppointment.appointmentStart),
      );
    }).toList();
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}