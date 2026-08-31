import 'package:cloud_firestore/cloud_firestore.dart';

import '../mappers/appointment_request_mapper.dart';
import '../mappers/request_timeline_mapper.dart';
import 'request_transaction_context.dart';

abstract class RequestTransactionOperation {
  const RequestTransactionOperation(
      this.context,
      );

  final RequestTransactionContext context;

  //--------------------------------------------------
  // CORE
  //--------------------------------------------------

  FirebaseFirestore get firestore => context.firestore;

  Transaction get transaction => context.transaction;

  AppointmentRequestMapper get requestMapper =>
      context.requestMapper;

  RequestTimelineMapper get timelineMapper =>
      context.timelineMapper;

  //--------------------------------------------------
  // COLLECTIONS
  //--------------------------------------------------

  CollectionReference<Map<String, dynamic>> get requests =>
      context.requests;

  CollectionReference<Map<String, dynamic>> get appointments =>
      firestore.collection("appointments");

  //--------------------------------------------------
  // DOCUMENTS
  //--------------------------------------------------

  DocumentReference<Map<String, dynamic>> requestDocument(
      String requestId,
      ) =>
      requests.doc(requestId);

  DocumentReference<Map<String, dynamic>> appointmentDocument(
      String appointmentId,
      ) =>
      appointments.doc(appointmentId);

  //--------------------------------------------------
  // REQUEST
  //--------------------------------------------------

  Future<DocumentSnapshot<Map<String, dynamic>>>
  loadRequestDocument(
      String requestId,
      ) {
    return transaction.get(
      requestDocument(requestId),
    );
  }

  void createRequestDocument(
      Map<String, dynamic> data,
      String requestId,
      ) {
    transaction.set(
      requestDocument(requestId),
      data,
    );
  }

  void updateRequestDocument(
      Map<String, dynamic> data,
      String requestId,
      ) {
    transaction.update(
      requestDocument(requestId),
      data,
    );
  }

  //--------------------------------------------------
  // APPOINTMENT
  //--------------------------------------------------

  Future<DocumentSnapshot<Map<String, dynamic>>>
  loadAppointmentDocument(
      String appointmentId,
      ) {
    return transaction.get(
      appointmentDocument(
        appointmentId,
      ),
    );
  }

  void updateAppointmentDocument({
    required String appointmentId,
    required Map<String, dynamic> data,
  }) {
    transaction.update(
      appointmentDocument(
        appointmentId,
      ),
      {
        ...data,
        "updatedAt": Timestamp.now(),
      },
    );
  }

  //--------------------------------------------------
  // TIMELINE
  //--------------------------------------------------

  void createTimelineEvent({
    required String requestId,
    required String eventId,
    required Map<String, dynamic> data,
  }) {
    transaction.set(
      context
          .timeline(requestId)
          .doc(eventId),
      data,
    );
  }
}