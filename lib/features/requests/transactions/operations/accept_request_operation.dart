import '../../models/appointment_request.dart';
import '../../models/request_timeline_event.dart';

import '../request_transaction_operation.dart';

class AcceptRequestOperation extends RequestTransactionOperation {
  AcceptRequestOperation(
      super.context,
      );

  Future<void> execute(
      AppointmentRequest request,
      ) async {
    //--------------------------------------------------
    // UPDATE APPOINTMENT
    //--------------------------------------------------

    await context.appointmentRequestService
        .applyAcceptedRequest(
      request: request,
      transaction: transaction,
    );

    //--------------------------------------------------
    // UPDATE REQUEST
    //--------------------------------------------------

    final updated = request.copyWith(
      status: AppointmentRequestStatus.accepted,
      updatedAt: DateTime.now(),
    );

    updateRequestDocument(
      requestMapper.toMap(updated),
      updated.id,
    );

    //--------------------------------------------------
    // TIMELINE
    //--------------------------------------------------

    final now = DateTime.now();

    final appointmentEvent =
    RequestTimelineEvent(
      id: now.microsecondsSinceEpoch
          .toString(),
      requestId: updated.id,
      type: RequestTimelineEventType
          .appointmentUpdated,
      createdAt: now,
      author: RequestAuthor.system,
      message:
      "L'appuntamento è stato aggiornato.",
    );

    createTimelineEvent(
      requestId: updated.id,
      eventId: appointmentEvent.id,
      data: timelineMapper.toMap(
        appointmentEvent,
      ),
    );

    final acceptedEvent =
    RequestTimelineEvent(
      id: (now.microsecondsSinceEpoch + 1)
          .toString(),
      requestId: updated.id,
      type:
      RequestTimelineEventType
          .accepted,
      createdAt: now,
      author: RequestAuthor.customer,
      message:
      "La richiesta è stata accettata.",
    );

    createTimelineEvent(
      requestId: updated.id,
      eventId: acceptedEvent.id,
      data: timelineMapper.toMap(
        acceptedEvent,
      ),
    );
  }
}