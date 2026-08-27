import 'package:intl/intl.dart';

import '../models/request_timeline_event.dart';

extension RequestTimelineEventExtension
on RequestTimelineEvent {

  String get createdAtLabel {
    return DateFormat(
      "dd/MM/yyyy • HH:mm",
    ).format(createdAt);
  }
}