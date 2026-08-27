import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/payloads/reschedule_request_payload.dart';

import 'shared/request_payload_arrow.dart';
import 'shared/request_payload_badge.dart';
import 'shared/request_payload_card.dart';

class ReschedulePayload extends StatelessWidget {
  const ReschedulePayload({
    super.key,
    required this.payload,
  });

  final RescheduleRequestPayload payload;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat(
      "dd MMM yyyy • HH:mm",
    );

    final oldDuration = payload.oldEnd
        .difference(payload.oldStart)
        .inMinutes;

    final newDuration = payload.newEnd
        .difference(payload.newStart)
        .inMinutes;

    final shift = payload.newStart
        .difference(payload.oldStart)
        .inMinutes;

    String? shiftLabel;

    if (shift != 0) {
      final sign = shift > 0 ? "+" : "";
      shiftLabel = "$sign$shift minuti";
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        //--------------------------------------------------
        // ORARIO ATTUALE
        //--------------------------------------------------

        RequestPayloadCard(
          title: "Orario attuale",
          value: formatter.format(
            payload.oldStart,
          ),
          icon: Icons.schedule,
          color: Colors.grey,
        ),

        const RequestPayloadArrow(),

        //--------------------------------------------------
        // NUOVO ORARIO
        //--------------------------------------------------

        RequestPayloadCard(
          title: "Nuovo orario proposto",
          value: formatter.format(
            payload.newStart,
          ),
          icon: Icons.event_available,
          color: Colors.green,
        ),

        //--------------------------------------------------
        // SPOSTAMENTO
        //--------------------------------------------------

        if (shiftLabel != null) ...[
          const SizedBox(height: 18),

          RequestPayloadBadge(
            label: "Spostamento $shiftLabel",
            icon: Icons.schedule,
            color: Colors.green,
          ),
        ],

        //--------------------------------------------------
        // DURATA
        //--------------------------------------------------

        if (payload.durationChanged) ...[
          const SizedBox(height: 18),

          RequestPayloadCard(
            title: "Durata",
            value:
            "$oldDuration min → $newDuration min",
            icon: Icons.timelapse,
            color: Colors.orange,
          ),
        ],

        //--------------------------------------------------
        // OPERATORE
        //--------------------------------------------------

        if (payload.hasEmployeeChange) ...[
          const SizedBox(height: 18),

          RequestPayloadCard(
            title: "Operatore",
            value:
            "${payload.oldEmployeeName} → ${payload.newEmployeeName}",
            icon: Icons.badge,
            color: Colors.deepPurple,
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