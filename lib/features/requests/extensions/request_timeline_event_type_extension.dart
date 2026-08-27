import 'package:flutter/material.dart';

import '../models/request_timeline_event.dart';

extension RequestTimelineEventTypeExtension
on RequestTimelineEventType {

  String get label {
    switch (this) {
      case RequestTimelineEventType.created:
        return "Richiesta creata";

      case RequestTimelineEventType.updated:
        return "Richiesta aggiornata";

      case RequestTimelineEventType.notificationSent:
        return "Notifica inviata";

      case RequestTimelineEventType.viewed:
        return "Visualizzata";

      case RequestTimelineEventType.accepted:
        return "Richiesta accettata";

      case RequestTimelineEventType.rejected:
        return "Richiesta rifiutata";

      case RequestTimelineEventType.expired:
        return "Richiesta scaduta";

      case RequestTimelineEventType.cancelled:
        return "Richiesta annullata";

      case RequestTimelineEventType.appointmentUpdated:
        return "Appuntamento aggiornato";

      case RequestTimelineEventType.employeeUpdated:
        return "Operatore aggiornato";

      case RequestTimelineEventType.servicesUpdated:
        return "Servizi aggiornati";

      case RequestTimelineEventType.system:
        return "Evento di sistema";
    }
  }

  IconData get icon {
    switch (this) {
      case RequestTimelineEventType.created:
        return Icons.add_circle;

      case RequestTimelineEventType.updated:
        return Icons.edit;

      case RequestTimelineEventType.notificationSent:
        return Icons.notifications;

      case RequestTimelineEventType.viewed:
        return Icons.visibility;

      case RequestTimelineEventType.accepted:
        return Icons.check_circle;

      case RequestTimelineEventType.rejected:
        return Icons.cancel;

      case RequestTimelineEventType.expired:
        return Icons.timer_off;

      case RequestTimelineEventType.cancelled:
        return Icons.block;

      case RequestTimelineEventType.appointmentUpdated:
        return Icons.event;

      case RequestTimelineEventType.employeeUpdated:
        return Icons.badge;

      case RequestTimelineEventType.servicesUpdated:
        return Icons.content_cut;

      case RequestTimelineEventType.system:
        return Icons.settings;
    }
  }

  Color get color {
    switch (this) {
      case RequestTimelineEventType.created:
        return Colors.blue;

      case RequestTimelineEventType.updated:
        return Colors.orange;

      case RequestTimelineEventType.notificationSent:
        return Colors.indigo;

      case RequestTimelineEventType.viewed:
        return Colors.teal;

      case RequestTimelineEventType.accepted:
        return Colors.green;

      case RequestTimelineEventType.rejected:
        return Colors.red;

      case RequestTimelineEventType.expired:
        return Colors.deepOrange;

      case RequestTimelineEventType.cancelled:
        return Colors.grey;

      case RequestTimelineEventType.appointmentUpdated:
        return Colors.green;

      case RequestTimelineEventType.employeeUpdated:
        return Colors.blue;

      case RequestTimelineEventType.servicesUpdated:
        return Colors.purple;

      case RequestTimelineEventType.system:
        return Colors.grey;
    }
  }

}