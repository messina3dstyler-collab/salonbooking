import '../../appointment/models/appointment_model.dart';

import '../models/today_tasks_model.dart';

class TodayTasksBuilder {
  const TodayTasksBuilder();

  TodayTasksModel build(
      List<AppointmentModel> appointments,
      ) {
    return TodayTasksModel(
      unconfirmedAppointments:
      appointments.where((appointment) => appointment.isPending).length,
    );
  }
}