import 'package:flutter/material.dart';

import '../models/appointment_request.dart';


extension AppointmentRequestStatusExtension
on AppointmentRequestStatus {

  String get label {
    switch (this) {
      case AppointmentRequestStatus.draft:
        return "Bozza";

      case AppointmentRequestStatus.pendingCustomer:
        return "In attesa";

      case AppointmentRequestStatus.accepted:
        return "Accettata";

      case AppointmentRequestStatus.rejected:
        return "Rifiutata";

      case AppointmentRequestStatus.expired:
        return "Scaduta";

      case AppointmentRequestStatus.cancelled:
        return "Annullata";
    }
  }

  Color get color {
    switch (this) {
      case AppointmentRequestStatus.draft:
        return Colors.grey;

      case AppointmentRequestStatus.pendingCustomer:
        return const Color(0xFFE6A100);

      case AppointmentRequestStatus.accepted:
        return Colors.green;

      case AppointmentRequestStatus.rejected:
        return Colors.red;

      case AppointmentRequestStatus.expired:
        return Colors.deepOrange;

      case AppointmentRequestStatus.cancelled:
        return Colors.grey.shade700;
    }
  }

  IconData get icon {
    switch (this) {
      case AppointmentRequestStatus.draft:
        return Icons.edit_document;

      case AppointmentRequestStatus.pendingCustomer:
        return Icons.schedule;

      case AppointmentRequestStatus.accepted:
        return Icons.check_circle;

      case AppointmentRequestStatus.rejected:
        return Icons.cancel;

      case AppointmentRequestStatus.expired:
        return Icons.timer_off;

      case AppointmentRequestStatus.cancelled:
        return Icons.block;
    }
  }
RequestActionOwner get actionOwner {
  switch (this) {
    case AppointmentRequestStatus.draft:
      return RequestActionOwner.salon;

    case AppointmentRequestStatus.pendingCustomer:
      return RequestActionOwner.customer;

    case AppointmentRequestStatus.accepted:
      return RequestActionOwner.none;

    case AppointmentRequestStatus.rejected:
      return RequestActionOwner.none;

    case AppointmentRequestStatus.expired:
      return RequestActionOwner.system;

    case AppointmentRequestStatus.cancelled:
      return RequestActionOwner.none;
  }
 }
  bool get requiresAttention {
    switch (this) {
      case AppointmentRequestStatus.draft:
        return true;

      case AppointmentRequestStatus.pendingCustomer:
        return true;

      case AppointmentRequestStatus.accepted:
        return false;

      case AppointmentRequestStatus.rejected:
        return false;

      case AppointmentRequestStatus.expired:
        return false;

      case AppointmentRequestStatus.cancelled:
        return false;
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
}