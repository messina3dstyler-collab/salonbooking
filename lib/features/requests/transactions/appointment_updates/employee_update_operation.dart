import '../../models/appointment_request.dart';

import 'appointment_update_operation.dart';

class EmployeeUpdateOperation
    extends AppointmentUpdateOperation {
  EmployeeUpdateOperation(
      super.context,
      );

  @override
  Future<void> execute(
      AppointmentRequest request,
      ) async {
    final payload = request.payload;

    final employee =
    payload["newEmployee"];

    // TODO
    //
    // appointment.employeeId =
    // employee

    if (employee == null) {
      return;
    }
  }
}