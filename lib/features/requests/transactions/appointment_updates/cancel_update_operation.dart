import '../../models/appointment_request.dart';

import 'appointment_update_operation.dart';

class CancelUpdateOperation
    extends AppointmentUpdateOperation {
  CancelUpdateOperation(
      super.context,
      );

  @override
  Future<void> execute(
      AppointmentRequest request,
      ) async {
    // TODO
    //
    // appointment.status =
    // cancelled
  }
}