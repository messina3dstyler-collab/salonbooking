import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/appointment_request.dart';
import '../models/request_display.dart';

extension AppointmentRequestDisplayExtension on AppointmentRequest {
  RequestDisplay get display {
    switch (type) {
    //--------------------------------------------------
    // RESCHEDULE
    //--------------------------------------------------

      case AppointmentRequestType.reschedule:
        final payload = reschedulePayload;

        final formatter = DateFormat("dd MMM • HH:mm");

        return RequestDisplay(
          title: "Cambio appuntamento",
          subtitle:
          "${formatter.format(payload.oldStart)} → ${formatter.format(payload.newStart)}",
          description: payload.hasMessage
              ? payload.message!
              : "Proposta di modifica dell'orario.",
          icon: Icons.schedule,
          color: Colors.green,
          highlight: isUrgentPriority,
        );

    //--------------------------------------------------
    // EMPLOYEE
    //--------------------------------------------------

      case AppointmentRequestType.changeEmployee:
        final payload = employeePayload;

        return RequestDisplay(
          title: "Cambio operatore",
          subtitle:
          "${payload.oldEmployeeName} → ${payload.newEmployeeName}",
          description: payload.hasMessage
              ? payload.message!
              : "Proposta di cambio operatore.",
          icon: Icons.badge,
          color: Colors.deepPurple,
          highlight: isUrgentPriority,
        );

    //--------------------------------------------------
    // SERVICES
    //--------------------------------------------------

      case AppointmentRequestType.changeServices:
        final payload = servicesPayload;

        return RequestDisplay(
          title: "Cambio servizi",
          subtitle: payload.newServiceNames.join(" • "),
          description: payload.hasMessage
              ? payload.message!
              : "Proposta di modifica dei servizi.",
          icon: Icons.content_cut,
          color: Colors.blue,
          highlight: isUrgentPriority,
        );

    //--------------------------------------------------
    // CANCEL
    //--------------------------------------------------

      case AppointmentRequestType.cancelAppointment:
        final payload = cancelPayload;

        return RequestDisplay(
          title: "Richiesta di annullamento",
          subtitle:
          payload.hasReason ? payload.reason! : "Nessun motivo",
          description: payload.hasMessage
              ? payload.message!
              : "Il salone propone l'annullamento dell'appuntamento.",
          icon: Icons.event_busy,
          color: Colors.red,
          highlight: true,
        );

    //--------------------------------------------------
    // CUSTOM
    //--------------------------------------------------

      case AppointmentRequestType.custom:
        final payload = customPayload;

        return RequestDisplay(
          title:
          payload.hasTitle ? payload.title! : "Richiesta",
          subtitle:
          payload.data["category"]?.toString() ??
              "Personalizzata",
          description: payload.hasMessage
              ? payload.message!
              : "Richiesta personalizzata.",
          icon: Icons.auto_awesome,
          color: Colors.indigo,
          highlight: isUrgentPriority,
        );
    }
  }
}