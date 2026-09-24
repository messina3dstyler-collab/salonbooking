import '../../models/appointment_request.dart';
import '../../models/request_timeline_event.dart';

import '../request_transaction_operation.dart';

class RejectRequestOperation extends RequestTransactionOperation {
  RejectRequestOperation(
      super.context,
      );

  Future<void> execute(
      AppointmentRequest request,
      ) async {
    //--------------------------------------------------
    // REQUEST STATE
    //--------------------------------------------------

    final isPendingCustomer =
        request.status ==
            AppointmentRequestStatus.pendingCustomer;

    final isPendingSalonCancellation =
        request.status ==
            AppointmentRequestStatus.pendingSalon &&
            request.type ==
                AppointmentRequestType.cancelAppointment;

    if (!isPendingCustomer &&
        !isPendingSalonCancellation) {
      throw StateError(
        "La Request '${request.id}' non è più pendente.",
      );
    }

    if (request.id.trim().isEmpty) {
      throw StateError(
        "La Request non contiene un id valido.",
      );
    }

    //--------------------------------------------------
    // UPDATE REQUEST
    //--------------------------------------------------

    final now = DateTime.now();

    final updated = request.copyWith(
      status: AppointmentRequestStatus.rejected,
      updatedAt: now,
    );

    updateRequestDocument(
      requestMapper.toMap(updated),
      updated.id,
    );

    //--------------------------------------------------
    // TIMELINE
    //--------------------------------------------------

    final event = RequestTimelineEvent(
      id: now.microsecondsSinceEpoch.toString(),
      requestId: updated.id,
      type: RequestTimelineEventType.rejected,
      createdAt: now,
      author: isPendingSalonCancellation
          ? RequestTimelineAuthor.admin
          : RequestTimelineAuthor.customer,
      message: isPendingSalonCancellation
          ? "La richiesta di cancellazione è stata rifiutata dal salone."
          : "Il cliente ha rifiutato la proposta.",
    );

    createTimelineEvent(
      requestId: updated.id,
      eventId: event.id,
      data: timelineMapper.toMap(event),
    );
  }
}