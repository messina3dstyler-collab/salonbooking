import '../../appointment/models/appointment_model.dart';

import '../models/revenue_overview_model.dart';

class RevenueBuilder {
  const RevenueBuilder();

  RevenueOverviewModel build(
      List<AppointmentModel> appointments,
      ) {
    final expectedRevenue = appointments
        .where((appointment) => !appointment.isCancelled)
        .fold<double>(
      0,
          (total, appointment) => total + appointment.price,
    );

    return RevenueOverviewModel(
      expectedRevenue: expectedRevenue,
    );
  }
}