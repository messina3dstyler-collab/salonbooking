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
    // REQUEST STATE
    //--------------------------------------------------

    if (request.status !=
        AppointmentRequestStatus.pendingCustomer) {
      throw StateError(
        "La Request '${request.id}' non è più pendente.",
      );
    }

    if (request.id.trim().isEmpty) {
      throw StateError(
        "La Request non contiene un id valido.",
      );
    }

    if (request.appointmentId.trim().isEmpty) {
      throw StateError(
        "La Request '${request.id}' non contiene appointmentId.",
      );
    }

    if (request.customerId.trim().isEmpty) {
      throw StateError(
        "La Request '${request.id}' non contiene customerId.",
      );
    }

    if (request.salonId.trim().isEmpty) {
      throw StateError(
        "La Request '${request.id}' non contiene salonId.",
      );
    }

    //--------------------------------------------------
    // READ APPOINTMENT
    //
    // IMPORTANTE:
    // tutte le letture vengono effettuate prima
    // delle scritture della transaction.
    //--------------------------------------------------

    final appointmentSnapshot =
    await loadAppointmentDocument(
      request.appointmentId,
    );

    if (!appointmentSnapshot.exists ||
        appointmentSnapshot.data() == null) {
      throw StateError(
        "L'appuntamento '${request.appointmentId}' "
            "non esiste.",
      );
    }

    final appointment =
    appointmentSnapshot.data()!;

    //--------------------------------------------------
    // REQUEST -> APPOINTMENT CONSISTENCY
    //--------------------------------------------------

    final appointmentUserId =
        appointment['userId']?.toString() ?? '';

    final appointmentSalonId =
        appointment['salonId']?.toString() ?? '';

    if (appointmentUserId != request.customerId) {
      throw StateError(
        "La Request '${request.id}' non appartiene "
            "al customer dell'appuntamento.",
      );
    }

    if (appointmentSalonId != request.salonId) {
      throw StateError(
        "La Request '${request.id}' e l'appuntamento "
            "appartengono a saloni differenti.",
      );
    }

    //--------------------------------------------------
    // APPOINTMENT ID CONSISTENCY
    //--------------------------------------------------

    if (request.appointmentId !=
        appointmentSnapshot.id) {
      throw StateError(
        "appointmentId non coerente con il documento "
            "Appointment.",
      );
    }

    //--------------------------------------------------
    // PREVENT DOUBLE ACCEPTANCE
    //--------------------------------------------------

    final existingAcceptedRequestId =
    appointment['acceptedRequestId']
        ?.toString()
        .trim();

    if (existingAcceptedRequestId != null &&
        existingAcceptedRequestId.isNotEmpty &&
        existingAcceptedRequestId != request.id) {
      throw StateError(
        "L'appuntamento è già collegato "
            "alla Request '$existingAcceptedRequestId'.",
      );
    }

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

    final now = DateTime.now();

    final updated = request.copyWith(
      status: AppointmentRequestStatus.accepted,
      updatedAt: now,
    );

    updateRequestDocument(
      requestMapper.toMap(updated),
      updated.id,
    );

    //--------------------------------------------------
    // TIMELINE - APPOINTMENT UPDATED
    //--------------------------------------------------

    final appointmentEvent =
    RequestTimelineEvent(
      id: now.microsecondsSinceEpoch.toString(),
      requestId: updated.id,
      type: RequestTimelineEventType.appointmentUpdated,
      createdAt: now,
      author: RequestTimelineAuthor.system,
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

    //--------------------------------------------------
    // TIMELINE - ACCEPTED
    //--------------------------------------------------

    final acceptedEvent =
    RequestTimelineEvent(
      id: (now.microsecondsSinceEpoch + 1)
          .toString(),
      requestId: updated.id,
      type: RequestTimelineEventType.accepted,
      createdAt: now,
      author: RequestTimelineAuthor.customer,
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