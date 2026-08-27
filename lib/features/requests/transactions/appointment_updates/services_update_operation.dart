import '../../models/appointment_request.dart';

import 'appointment_update_operation.dart';

class ServicesUpdateOperation
    extends AppointmentUpdateOperation {
  ServicesUpdateOperation(
      super.context,
      );

  @override
  Future<void> execute(
      AppointmentRequest request,
      ) async {
    final services =
    request.payload["services"];

    // TODO
    //
    // appointment.services =
    // services

    if (services == null) {
      return;
    }
  }
}