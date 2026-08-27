import 'package:flutter/material.dart';

import 'appointment_request.dart';

extension AppointmentRequestTypeExtension
on AppointmentRequestType {

  String get title {
    switch (this) {
      case AppointmentRequestType.reschedule:
        return 'Proposta nuovo orario';

      case AppointmentRequestType.changeEmployee:
        return 'Cambio operatore';

      case AppointmentRequestType.changeServices:
        return 'Modifica servizi';

      case AppointmentRequestType.cancelAppointment:
        return 'Richiesta annullamento';

      case AppointmentRequestType.custom:
        return 'Richiesta';
    }
  }

  IconData get icon {
    switch (this) {
      case AppointmentRequestType.reschedule:
        return Icons.schedule;

      case AppointmentRequestType.changeEmployee:
        return Icons.person;

      case AppointmentRequestType.changeServices:
        return Icons.content_cut;

      case AppointmentRequestType.cancelAppointment:
        return Icons.event_busy;

      case AppointmentRequestType.custom:
        return Icons.chat_bubble_outline;
    }
  }

  Color get color {
    switch (this) {
      case AppointmentRequestType.reschedule:
        return Colors.blue;

      case AppointmentRequestType.changeEmployee:
        return Colors.deepPurple;

      case AppointmentRequestType.changeServices:
        return Colors.teal;

      case AppointmentRequestType.cancelAppointment:
        return Colors.red;

      case AppointmentRequestType.custom:
        return Colors.grey;
    }
  }
}

extension AppointmentRequestStatusExtension
on AppointmentRequestStatus {

  String get label {
    switch (this) {
      case AppointmentRequestStatus.draft:
        return 'Bozza';

      case AppointmentRequestStatus.pendingCustomer:
        return 'In attesa';

      case AppointmentRequestStatus.accepted:
        return 'Accettata';

      case AppointmentRequestStatus.rejected:
        return 'Rifiutata';

      case AppointmentRequestStatus.expired:
        return 'Scaduta';

      case AppointmentRequestStatus.cancelled:
        return 'Annullata';
    }
  }

  Color get color {
    switch (this) {
      case AppointmentRequestStatus.draft:
        return Colors.grey;

      case AppointmentRequestStatus.pendingCustomer:
        return Colors.orange;

      case AppointmentRequestStatus.accepted:
        return Colors.green;

      case AppointmentRequestStatus.rejected:
        return Colors.red;

      case AppointmentRequestStatus.expired:
        return Colors.blueGrey;

      case AppointmentRequestStatus.cancelled:
        return Colors.black54;
    }
  }

  IconData get icon {
    switch (this) {
      case AppointmentRequestStatus.draft:
        return Icons.edit_note;

      case AppointmentRequestStatus.pendingCustomer:
        return Icons.schedule;

      case AppointmentRequestStatus.accepted:
        return Icons.check_circle;

      case AppointmentRequestStatus.rejected:
        return Icons.cancel;

      case AppointmentRequestStatus.expired:
        return Icons.timer_off;

      case AppointmentRequestStatus.cancelled:
        return Icons.delete_outline;
    }
  }

  bool get isClosed {
    switch (this) {
      case AppointmentRequestStatus.accepted:
      case AppointmentRequestStatus.rejected:
      case AppointmentRequestStatus.expired:
      case AppointmentRequestStatus.cancelled:
        return true;

      case AppointmentRequestStatus.draft:
      case AppointmentRequestStatus.pendingCustomer:
        return false;
    }
  }

  bool get needsCustomerAction {
    return this ==
        AppointmentRequestStatus.pendingCustomer;
  }
}