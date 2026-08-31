import '../models/request_timeline_event.dart';

extension RequestTimelineAuthorExtension on RequestTimelineAuthor {
  String get label {
    switch (this) {
      case RequestTimelineAuthor.admin:
        return "Amministratore";

      case RequestTimelineAuthor.employee:
        return "Operatore";

      case RequestTimelineAuthor.customer:
        return "Cliente";

      case RequestTimelineAuthor.system:
        return "Sistema";
    }
  }
}