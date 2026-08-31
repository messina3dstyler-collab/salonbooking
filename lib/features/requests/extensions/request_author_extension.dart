import '../models/appointment_request.dart';
import '../models/request_timeline_event.dart';

extension RequestAuthorExtension on RequestAuthor {
  RequestTimelineAuthor get timelineAuthor {
    switch (this) {
      case RequestAuthor.admin:
        return RequestTimelineAuthor.admin;

      case RequestAuthor.employee:
        return RequestTimelineAuthor.employee;

      case RequestAuthor.customer:
        return RequestTimelineAuthor.customer;

      case RequestAuthor.system:
        return RequestTimelineAuthor.system;
    }
  }

  String get label {
    switch (this) {
      case RequestAuthor.admin:
        return 'Salone';

      case RequestAuthor.employee:
        return 'Dipendente';

      case RequestAuthor.customer:
        return 'Cliente';

      case RequestAuthor.system:
        return 'Sistema';
    }
  }
}