import '../../appointment/models/appointment_model.dart';

import '../models/revenue_overview_model.dart';

class RevenueBuilder {
  const RevenueBuilder();

  RevenueOverviewModel build(
      List<AppointmentModel> appointments,
      ) {
    final validAppointments = appointments.where(
          (appointment) => !appointment.isCancelled,
    );

    final expectedRevenue = validAppointments.fold<double>(
      0,
          (total, appointment) => total + appointment.price,
    );

    return RevenueOverviewModel(
      expectedRevenue: expectedRevenue,
      today: expectedRevenue,
      collectedRevenue: 0,
    );
  }
}