import 'package:flutter/material.dart';

import '../models/appointment_request.dart';

extension AppointmentRequestTypeExtension
on AppointmentRequestType {

  String get label {
    switch (this) {
      case AppointmentRequestType.reschedule:
        return "Spostamento";

      case AppointmentRequestType.changeEmployee:
        return "Cambio operatore";

      case AppointmentRequestType.changeServices:
        return "Modifica servizi";

      case AppointmentRequestType.cancelAppointment:
        return "Annullamento";

      case AppointmentRequestType.custom:
        return "Richiesta";
    }
  }

  String get description {
    switch (this) {
      case AppointmentRequestType.reschedule:
        return "Proposta di modifica della data o dell'orario.";

      case AppointmentRequestType.changeEmployee:
        return "Proposta di cambio dell'operatore.";

      case AppointmentRequestType.changeServices:
        return "Proposta di modifica dei servizi prenotati.";

      case AppointmentRequestType.cancelAppointment:
        return "Richiesta di annullamento dell'appuntamento.";

      case AppointmentRequestType.custom:
        return "Richiesta personalizzata.";
    }
  }

  IconData get icon {
    switch (this) {
      case AppointmentRequestType.reschedule:
        return Icons.schedule;

      case AppointmentRequestType.changeEmployee:
        return Icons.manage_accounts;

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
        return const Color(0xFF1976D2);

      case AppointmentRequestType.changeEmployee:
        return const Color(0xFF8E24AA);

      case AppointmentRequestType.changeServices:
        return const Color(0xFFD4AF37);

      case AppointmentRequestType.cancelAppointment:
        return const Color(0xFFE53935);

      case AppointmentRequestType.custom:
        return const Color(0xFF546E7A);
    }
  }

  bool get requiresCustomerApproval {
    switch (this) {
      case AppointmentRequestType.reschedule:
      case AppointmentRequestType.changeEmployee:
      case AppointmentRequestType.changeServices:
      case AppointmentRequestType.cancelAppointment:
        return true;

      case AppointmentRequestType.custom:
        return false;
    }
  }

  bool get isCritical {
    switch (this) {
      case AppointmentRequestType.cancelAppointment:
        return true;

      case AppointmentRequestType.reschedule:
      case AppointmentRequestType.changeEmployee:
      case AppointmentRequestType.changeServices:
      case AppointmentRequestType.custom:
        return false;
    }
  }
}