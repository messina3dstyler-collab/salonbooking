import '../../models/appointment_request.dart';
import '../../models/request_timeline_event.dart';

import '../request_transaction_operation.dart';

class ReminderRequestOperation extends RequestTransactionOperation {
  ReminderRequestOperation(
      super.context,
      );

  Future<void> execute(
      AppointmentRequest request,
      ) async {
    final now = DateTime.now();

    final event = RequestTimelineEvent(
      id: now.microsecondsSinceEpoch.toString(),
      requestId: request.id,
      type: RequestTimelineEventType.notificationSent,
      createdAt: now,
      author: RequestTimelineAuthor.system,
      message: "Promemoria inviato al cliente.",
    );

    createTimelineEvent(
      requestId: request.id,
      eventId: event.id,
      data: timelineMapper.toMap(event),
    );
  }
}