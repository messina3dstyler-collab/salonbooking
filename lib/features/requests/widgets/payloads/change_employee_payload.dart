import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/payloads/employee_request_payload.dart';

import 'shared/request_payload_arrow.dart';
import 'shared/request_payload_badge.dart';
import 'shared/request_payload_card.dart';

class ChangeEmployeePayload extends StatelessWidget {
  const ChangeEmployeePayload({
    super.key,
    required this.payload,
  });

  final EmployeeRequestPayload payload;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat(
      "dd MMM yyyy • HH:mm",
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //--------------------------------------------------
        // OPERATORE ATTUALE
        //--------------------------------------------------

        RequestPayloadCard(
          title: "Operatore attuale",
          value: payload.oldEmployeeName.isEmpty
              ? "—"
              : payload.oldEmployeeName,
          icon: Icons.person_outline,
          color: Colors.grey,
        ),

        const RequestPayloadArrow(),

        //--------------------------------------------------
        // NUOVO OPERATORE
        //--------------------------------------------------

        RequestPayloadCard(
          title: "Nuovo operatore",
          value: payload.newEmployeeName.isEmpty
              ? "—"
              : payload.newEmployeeName,
          icon: Icons.badge,
          color: Colors.deepPurple,
        ),

        //--------------------------------------------------
        // APPUNTAMENTO
        //--------------------------------------------------

        const SizedBox(height: 18),

        RequestPayloadCard(
          title: "Appuntamento",
          value:
          "${formatter.format(payload.appointmentStart)} → ${DateFormat("HH:mm").format(payload.appointmentEnd)}",
          icon: Icons.schedule,
          color: Colors.blue,
        ),

        //--------------------------------------------------
        // SERVIZIO
        //--------------------------------------------------

        if (payload.serviceName.isNotEmpty) ...[
          const SizedBox(height: 18),

          RequestPayloadCard(
            title: "Servizio",
            value: payload.serviceName,
            icon: Icons.content_cut,
            color: Colors.teal,
          ),
        ],

        //--------------------------------------------------
        // DISPONIBILITÀ
        //--------------------------------------------------

        const SizedBox(height: 18),

        RequestPayloadBadge(
          label: payload.employeeAvailable
              ? "Operatore disponibile"
              : "Disponibilità da verificare",
          icon: payload.employeeAvailable
              ? Icons.check_circle
              : Icons.schedule,
          color: payload.employeeAvailable
              ? Colors.green
              : Colors.orange,
        ),

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