import 'package:cloud_firestore/cloud_firestore.dart';

import '../../requests/models/appointment_request.dart';

abstract class AppointmentRequestServiceBase {
  const AppointmentRequestServiceBase();

  Future<void> applyAcceptedRequest({
    required AppointmentRequest request,
    required Transaction transaction,
  });
}