import '../../models/appointment_request.dart';

import 'appointment_update_operation.dart';

class RescheduleUpdateOperation
    extends AppointmentUpdateOperation {
  RescheduleUpdateOperation(
      super.context,
      );

  @override
  Future<void> execute(
      AppointmentRequest request,
      ) async {
    final payload = request.payload;

    final newStart =
    payload["newStart"];

    final newEnd =
    payload["newEnd"];

    // TODO
    //
    // Aggiornare realmente l'appuntamento
    // tramite AppointmentDatasource /
    // AppointmentTransactionService.
    //
    // start = newStart
    // end = newEnd

    if (newStart == null ||
        newEnd == null) {
      return;
    }
  }
}