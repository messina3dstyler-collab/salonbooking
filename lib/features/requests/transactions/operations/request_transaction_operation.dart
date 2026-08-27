import 'package:cloud_firestore/cloud_firestore.dart';

import '../../datasource/appointment_request_datasource.dart';
import '../../mappers/appointment_request_mapper.dart';
import '../../mappers/request_timeline_mapper.dart';
import '../request_transaction_context.dart';

abstract class RequestTransactionOperation {
  const RequestTransactionOperation(
      this.context,
      );

  final RequestTransactionContext context;

  //--------------------------------------------------
  // FIRESTORE
  //--------------------------------------------------

  FirebaseFirestore get firestore =>
      context.firestore;

  Transaction get transaction =>
      context.transaction;

  //--------------------------------------------------
  // COLLECTIONS
  //--------------------------------------------------

  CollectionReference<Map<String, dynamic>>
  get requests =>
      context.requests;

  CollectionReference<Map<String, dynamic>>
  timeline(
      String requestId,
      ) {
    return context.timeline(requestId);
  }

  //--------------------------------------------------
  // DATASOURCE
  //--------------------------------------------------

  AppointmentRequestDatasource
  get datasource =>
      context.datasource;

  //--------------------------------------------------
  // MAPPERS
  //--------------------------------------------------

  AppointmentRequestMapper
  get requestMapper =>
      context.requestMapper;

  RequestTimelineMapper
  get timelineMapper =>
      context.timelineMapper;

  //--------------------------------------------------
  // HELPERS
  //--------------------------------------------------

  DocumentReference<Map<String, dynamic>>
  requestDocument(
      String requestId,
      ) {
    return requests.doc(requestId);
  }

  DocumentReference<Map<String, dynamic>>
  timelineDocument({
    required String requestId,
    required String eventId,
  }) {
    return timeline(requestId).doc(
      eventId,
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
  loadRequest(
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

  void deleteRequestDocument(
      String requestId,
      ) {
    transaction.delete(
      requestDocument(requestId),
    );
  }

  void createTimelineEvent({
    required String requestId,
    required String eventId,
    required Map<String, dynamic> data,
  }) {
    transaction.set(
      timelineDocument(
        requestId: requestId,
        eventId: eventId,
      ),
      data,
    );
  }
}