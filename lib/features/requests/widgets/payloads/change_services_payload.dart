import 'package:flutter/material.dart';

import '../../models/payloads/services_request_payload.dart';

import 'shared/request_payload_arrow.dart';
import 'shared/request_payload_badge.dart';
import 'shared/request_payload_card.dart';

class ChangeServicesPayload extends StatelessWidget {
  const ChangeServicesPayload({
    super.key,
    required this.payload,
  });

  final ServicesRequestPayload payload;

  @override
  Widget build(BuildContext context) {
    final added = payload.newServiceNames
        .where(
          (service) =>
      !payload.oldServiceNames.contains(service),
    )
        .toList();

    final removed = payload.oldServiceNames
        .where(
          (service) =>
      !payload.newServiceNames.contains(service),
    )
        .toList();

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        //--------------------------------------------------
        // SERVIZI ATTUALI
        //--------------------------------------------------

        RequestPayloadCard(
          title: "Servizi attuali",
          value: payload.oldServiceNames.isEmpty
              ? "Nessun servizio"
              : "${payload.oldServiceNames.length} servizi",
          subtitle: payload.oldServiceNames.join(" • "),
          icon: Icons.content_cut,
          color: Colors.grey,
        ),

        const RequestPayloadArrow(),

        //--------------------------------------------------
        // NUOVI SERVIZI
        //--------------------------------------------------

        RequestPayloadCard(
          title: "Nuovi servizi",
          value: payload.newServiceNames.isEmpty
              ? "Nessun servizio"
              : "${payload.newServiceNames.length} servizi",
          subtitle: payload.newServiceNames.join(" • "),
          icon: Icons.auto_awesome,
          color: Colors.blue,
        ),

        //--------------------------------------------------
        // PREZZO
        //--------------------------------------------------

        const SizedBox(height: 18),

        RequestPayloadCard(
          title: "Prezzo",
          value:
          "€ ${payload.oldTotalPrice.toStringAsFixed(2)} → € ${payload.newTotalPrice.toStringAsFixed(2)}",
          icon: Icons.euro,
          color: Colors.green,
        ),

        //--------------------------------------------------
        // DURATA
        //--------------------------------------------------

        const SizedBox(height: 18),

        RequestPayloadCard(
          title: "Durata",
          value:
          "${payload.oldDuration} min → ${payload.newDuration} min",
          icon: Icons.timelapse,
          color: Colors.orange,
        ),

        //--------------------------------------------------
        // OPERATORE
        //--------------------------------------------------

        if (payload.employeeName.isNotEmpty) ...[
          const SizedBox(height: 18),

          RequestPayloadCard(
            title: "Operatore",
            value: payload.employeeName,
            icon: Icons.badge,
            color: Colors.deepPurple,
          ),
        ],

        //--------------------------------------------------
        // SERVIZI AGGIUNTI
        //--------------------------------------------------

        if (added.isNotEmpty) ...[
          const SizedBox(height: 18),

          RequestPayloadCard(
            title: "Servizi aggiunti",
            value:
            "${added.length} servizio${added.length == 1 ? "" : "i"}",
            subtitle: added.join(" • "),
            icon: Icons.add_circle_outline,
            color: Colors.green,
          ),
        ],

        //--------------------------------------------------
        // SERVIZI RIMOSSI
        //--------------------------------------------------

        if (removed.isNotEmpty) ...[
          const SizedBox(height: 18),

          RequestPayloadCard(
            title: "Servizi rimossi",
            value:
            "${removed.length} servizio${removed.length == 1 ? "" : "i"}",
            subtitle: removed.join(" • "),
            icon: Icons.remove_circle_outline,
            color: Colors.red,
          ),
        ],

        //--------------------------------------------------
        // NESSUNA DIFFERENZA
        //--------------------------------------------------

        if (added.isEmpty &&
            removed.isEmpty) ...[
          const SizedBox(height: 18),

          const RequestPayloadBadge(
            label:
            "Nessuna variazione ai servizi",
            icon: Icons.check_circle,
            color: Colors.green,
          ),
        ],

        //--------------------------------------------------
        // MESSAGGIO
        //--------------------------------------------------

        if (payload.hasMessage) ...[
          const SizedBox(height: 18),

          RequestPayloadCard(
            title: "Messaggio del salone",
            value: payload.message!,
            icon: Icons.chat_bubble_outline,
            color: Colors.blueGrey,
          ),
        ],
      ],
    );
  }
}