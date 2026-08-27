import '../../appointment/models/appointment_model.dart';

import '../models/next_appointment_model.dart';

class NextAppointmentBuilder {
  const NextAppointmentBuilder();

  NextAppointmentModel build(
      List<AppointmentModel> appointments, {
        DateTime? now,
      }) {
    final referenceTime = now ?? DateTime.now();

    AppointmentModel? nextAppointment;

    for (final appointment in appointments) {
      if (appointment.isCancelled ||
          !appointment.appointmentStart.isAfter(referenceTime)) {
        continue;
      }

      if (nextAppointment == null ||
          appointment.appointmentStart
              .isBefore(nextAppointment.appointmentStart)) {
        nextAppointment = appointment;
      }
    }

    if (nextAppointment == null) {
      return NextAppointmentModel.empty();
    }

    final start = nextAppointment.appointmentStart;
    final minutes = start.difference(referenceTime).inMinutes;

    return NextAppointmentModel(
      id: nextAppointment.id,
      time:
      '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
      customer: nextAppointment.customerName,
      service: nextAppointment.serviceName,
      employee: nextAppointment.employeeName,
      countdown: 'Tra $minutes min',
    );
  }
}