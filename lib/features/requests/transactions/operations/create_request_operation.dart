import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../extensions/request_author_extension.dart';
import '../../models/appointment_request.dart';
import '../../models/request_timeline_event.dart';

import 'request_transaction_operation.dart';

class CreateRequestOperation extends RequestTransactionOperation {
  CreateRequestOperation(
      super.context,
      );

  static const _uuid = Uuid();

  Future<void> execute(
      AppointmentRequest request,
      ) async {
    //--------------------------------------------------
    // REQUEST
    //--------------------------------------------------

    createRequestDocument(
      requestMapper.toMap(request),
      request.id,
    );

    //--------------------------------------------------
    // CANCELLATION LOCK
    //--------------------------------------------------
    //
    // Il lock viene creato esclusivamente per una richiesta
    // di cancellazione creata dal customer e già nello stato
    // pendingSalon.
    //
    // Non deve essere creato per altre Request cancelAppointment
    // eventualmente generate da altri workflow (es. Request
    // create dal salone in stato draft).
    //
    //--------------------------------------------------

    if (request.createdBy == RequestAuthor.customer &&
        request.type == AppointmentRequestType.cancelAppointment &&
        request.status == AppointmentRequestStatus.pendingSalon) {
      final lockDocument = firestore
          .collection(
        "appointment_cancellation_locks",
      )
          .doc(
        request.appointmentId,
      );

      transaction.set(
        lockDocument,
        {
          "appointmentId": request.appointmentId,
          "requestId": request.id,
          "customerId": request.customerId,
          "salonId": request.salonId,
          "createdAt": Timestamp.now(),
        },
      );
    }

    //--------------------------------------------------
    // TIMELINE
    //--------------------------------------------------

    final event = RequestTimelineEvent(
      id: _uuid.v4(),
      requestId: request.id,
      type: RequestTimelineEventType.created,
      createdAt: DateTime.now(),
      author: request.createdBy.timelineAuthor,
      message: "Richiesta creata.",
    );

    createTimelineEvent(
      requestId: request.id,
      eventId: event.id,
      data: timelineMapper.toMap(event),
    );
  }
}
