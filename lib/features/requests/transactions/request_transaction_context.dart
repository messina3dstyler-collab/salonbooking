import 'package:cloud_firestore/cloud_firestore.dart';

import '../../appointment/services/appointment_request_service_base.dart';

import '../datasource/appointment_request_datasource.dart';
import '../mappers/appointment_request_mapper.dart';
import '../mappers/request_timeline_mapper.dart';

class RequestTransactionContext {
  const RequestTransactionContext({
    required this.firestore,
    required this.transaction,
    required this.datasource,
    required this.requestMapper,
    required this.timelineMapper,
    required this.appointmentRequestService,
  });

  //--------------------------------------------------
  // CORE
  //--------------------------------------------------

  final FirebaseFirestore firestore;

  final Transaction transaction;

  //--------------------------------------------------
  // REQUEST
  //--------------------------------------------------

  final AppointmentRequestDatasource datasource;

  final AppointmentRequestMapper requestMapper;

  final RequestTimelineMapper timelineMapper;

  //--------------------------------------------------
  // APPOINTMENT
  //--------------------------------------------------

  final AppointmentRequestServiceBase
  appointmentRequestService;

  //--------------------------------------------------
  // COLLECTIONS
  //--------------------------------------------------

  CollectionReference<Map<String, dynamic>>
  get requests =>
      firestore.collection(
        "appointment_requests",
      );

  CollectionReference<Map<String, dynamic>>
  timeline(
      String requestId,
      ) {
    return requests
        .doc(requestId)
        .collection(
      "timeline",
    );
  }

  //--------------------------------------------------
  // LOAD REQUEST
  //--------------------------------------------------

  Future<DocumentSnapshot<Map<String, dynamic>>>
  loadRequest(
      String requestId,
      ) {
    return transaction.get(
      requests.doc(requestId),
    );
  }
}