import '../../models/request_timeline_event.dart';

import 'request_transaction_operation.dart';
import '../../models/appointment_request.dart';

class ReminderRequestOperation
    extends RequestTransactionOperation {
  ReminderRequestOperation(
      super.context,
      );

  Future<void> execute(
      String requestId,
      ) async {
    final event = RequestTimelineEvent(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      requestId: requestId,
      type:
      RequestTimelineEventType.notificationSent,
      createdAt: DateTime.now(),
      author: RequestAuthor.system,
      message:
      "È stato inviato un sollecito al cliente.",
    );

    createTimelineEvent(
      requestId: requestId,
      eventId: event.id,
      data: timelineMapper.toMap(event),
    );
  }
}