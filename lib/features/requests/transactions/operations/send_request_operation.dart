import '../../models/appointment_request.dart';
import '../../models/request_timeline_event.dart';

import '../request_transaction_operation.dart';

class SendRequestOperation extends RequestTransactionOperation {
  SendRequestOperation(
      super.context,
      );

  Future<void> execute(
      AppointmentRequest request,
      ) async {
    final now = DateTime.now();

    final updated = request.copyWith(
      status: AppointmentRequestStatus.pendingCustomer,
      updatedAt: now,
    );

    updateRequestDocument(
      requestMapper.toMap(updated),
      updated.id,
    );

    final event = RequestTimelineEvent(
      id: now.microsecondsSinceEpoch.toString(),
      requestId: updated.id,
      type: RequestTimelineEventType.notificationSent,
      createdAt: now,
      author: RequestTimelineAuthor.system,
      message: "Richiesta inviata al cliente.",
    );

    createTimelineEvent(
      requestId: updated.id,
      eventId: event.id,
      data: timelineMapper.toMap(event),
    );
  }
}