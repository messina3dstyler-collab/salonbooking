import '../../appointment/models/appointment_model.dart';

import '../models/today_tasks_model.dart';

class TodayTasksBuilder {
  const TodayTasksBuilder({
    this.expiringWindow = const Duration(minutes: 60),
  });

  /// Finestra temporale entro la quale un appuntamento viene
  /// considerato prossimo all'inizio e quindi "in scadenza".
  final Duration expiringWindow;

  TodayTasksModel build(
      List<AppointmentModel> appointments, {
        int pendingRequests = 0,
        DateTime? referenceTime,
      }) {
    final now = referenceTime ?? DateTime.now();

    final unconfirmedAppointments =
    appointments.where(
          (appointment) => appointment.isPending,
    );

    final expiringAppointments =
    appointments.where(
          (appointment) {
        if (appointment.isCancelled ||
            appointment.isCompleted) {
          return false;
        }

        final start = appointment.appointmentStart;
        final difference = start.difference(now);

        return difference >= Duration.zero &&
            difference <= expiringWindow;
      },
    );

    return TodayTasksModel(
      pendingRequests: pendingRequests,
      unconfirmedAppointments:
      unconfirmedAppointments.length,
      expiringAppointments:
      expiringAppointments.length,
    );
  }
}