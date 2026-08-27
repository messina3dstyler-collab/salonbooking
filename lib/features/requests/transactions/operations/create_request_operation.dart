import 'package:uuid/uuid.dart';

import '../../models/appointment_request.dart';
import '../../models/request_timeline_event.dart';

import 'request_transaction_operation.dart';

class CreateRequestOperation
    extends RequestTransactionOperation {
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
    // TIMELINE
    //--------------------------------------------------

    final event = RequestTimelineEvent(
      id: _uuid.v4(),
      requestId: request.id,
      type: RequestTimelineEventType.created,
      createdAt: DateTime.now(),
      author: request.createdBy,
      message: "Richiesta creata.",
    );

    createTimelineEvent(
      requestId: request.id,
      eventId: event.id,
      data: timelineMapper.toMap(event),
    );
  }
}