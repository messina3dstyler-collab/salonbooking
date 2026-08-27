import 'package:cloud_firestore/cloud_firestore.dart';

import 'repositories/appointment_repository.dart';
import 'services/appointment_request_service.dart';
import 'services/appointment_request_service_base.dart';
import 'services/appointment_service.dart';

class AppointmentModule {
  AppointmentModule._();

  //--------------------------------------------------
  // FIREBASE
  //--------------------------------------------------

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //--------------------------------------------------
  // REPOSITORY
  //--------------------------------------------------

  static final AppointmentRepository repository =
  AppointmentRepository(
    _firestore,
  );

  //--------------------------------------------------
  // SERVICES
  //--------------------------------------------------

  static final AppointmentService service =
  AppointmentService(
    repository,
  );

  static final AppointmentRequestServiceBase
  requestService =
  AppointmentRequestService(
    repository,
  );
}