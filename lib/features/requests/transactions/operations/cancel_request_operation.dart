import '../../models/appointment_request.dart';
import '../../models/request_timeline_event.dart';

import '../request_transaction_operation.dart';

class CancelRequestOperation extends RequestTransactionOperation {
  CancelRequestOperation(
      super.context,
      );

  Future<void> execute(
      AppointmentRequest request,
      ) async {
    final now = DateTime.now();

    final updated = request.copyWith(
      status: AppointmentRequestStatus.cancelled,
      updatedAt: now,
    );

    updateRequestDocument(
      requestMapper.toMap(updated),
      updated.id,
    );

    final event = RequestTimelineEvent(
      id: now.microsecondsSinceEpoch.toString(),
      requestId: updated.id,
      type: RequestTimelineEventType.cancelled,
      createdAt: now,
      author: RequestAuthor.system,
      message: "Richiesta annullata.",
    );

    createTimelineEvent(
      requestId: updated.id,
      eventId: event.id,
      data: timelineMapper.toMap(event),
    );
  }
}