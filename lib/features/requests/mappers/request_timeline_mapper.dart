import '../models/request_timeline_event.dart';

class RequestTimelineMapper {
  const RequestTimelineMapper();

  RequestTimelineEvent fromMap(
      Map<String, dynamic> map,
      ) {
    return RequestTimelineEvent.fromMap(
      map,
    );
  }

  Map<String, dynamic> toMap(
      RequestTimelineEvent event,
      ) {
    return event.toMap();
  }

  List<RequestTimelineEvent> fromList(
      List<Map<String, dynamic>> list,
      ) {
    return list
        .map(fromMap)
        .toList();
  }

  List<Map<String, dynamic>> toList(
      List<RequestTimelineEvent> list,
      ) {
    return list
        .map(toMap)
        .toList();
  }
}