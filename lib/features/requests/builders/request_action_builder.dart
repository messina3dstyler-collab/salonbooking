import 'package:flutter/material.dart';

import '../models/appointment_request.dart';
import '../models/request_action.dart';
import '../models/request_action_type.dart';

class RequestActionBuilder {
  const RequestActionBuilder._();

  static RequestActions build(
      AppointmentRequest request,
      ) {
    switch (request.status) {
    //----------------------------------------------------------
    // BOZZA
    //----------------------------------------------------------

      case AppointmentRequestStatus.draft:
        return const RequestActions(
          primary: RequestAction(
            icon: Icons.send,
            label: "Invia richiesta",
            subtitle:
            "Il cliente riceverà una notifica per confermare la proposta.",
          ),
        );

    //----------------------------------------------------------
    // IN ATTESA
    //----------------------------------------------------------

      case AppointmentRequestStatus.pendingCustomer:
        return const RequestActions(
          primary: RequestAction(
            icon: Icons.hourglass_top,
            label: "In attesa del cliente",
            subtitle:
            "La richiesta è stata inviata ed è in attesa di risposta.",
            enabled: false,
          ),
          secondary: [
            RequestActionButton(
              icon: Icons.notifications_active,
              label: "Sollecita",
              color: Colors.orange,
              action: RequestActionType.remind,
            ),
            RequestActionButton(
              icon: Icons.close,
              label: "Annulla",
              color: Colors.red,
              action: RequestActionType.cancel,
            ),
          ],
        );

    //----------------------------------------------------------
    // ACCETTATA
    //----------------------------------------------------------

      case AppointmentRequestStatus.accepted:
        return const RequestActions(
          primary: RequestAction(
            icon: Icons.event_available,
            label: "Apri appuntamento",
            subtitle:
            "Il cliente ha accettato la proposta.",
            color: Colors.green,
          ),
        );

    //----------------------------------------------------------
    // RIFIUTATA
    //----------------------------------------------------------

      case AppointmentRequestStatus.rejected:
        return const RequestActions(
          primary: RequestAction(
            icon: Icons.refresh,
            label: "Nuova proposta",
            subtitle:
            "Prepara una nuova proposta da inviare al cliente.",
            color: Colors.orange,
          ),
        );

    //----------------------------------------------------------
    // SCADUTA
    //----------------------------------------------------------

      case AppointmentRequestStatus.expired:
        return const RequestActions(
          primary: RequestAction(
            icon: Icons.schedule_send,
            label: "Reinvia proposta",
            subtitle:
            "La richiesta è scaduta senza risposta.",
            color: Colors.deepOrange,
          ),
        );

    //----------------------------------------------------------
    // ANNULLATA
    //----------------------------------------------------------

      case AppointmentRequestStatus.cancelled:
        return const RequestActions(
          primary: RequestAction(
            icon: Icons.block,
            label: "Richiesta annullata",
            subtitle:
            "Non sono disponibili ulteriori azioni.",
            color: Colors.grey,
            enabled: false,
          ),
        );
    }
  }
}