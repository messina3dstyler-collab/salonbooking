import 'package:flutter/material.dart';

import '../../models/payloads/custom_request_payload.dart';

import 'shared/request_payload_badge.dart';
import 'shared/request_payload_card.dart';

class CustomPayload extends StatelessWidget {
  const CustomPayload({
    super.key,
    required this.payload,
  });

  final CustomRequestPayload payload;

  @override
  Widget build(BuildContext context) {
    final category =
    payload.data["category"]?.toString();

    final note =
    payload.data["note"]?.toString();

    final extraEntries = payload.data.entries
        .where(
          (entry) =>
      entry.key != "category" &&
          entry.key != "note",
    )
        .toList()
      ..sort(
            (a, b) => a.key
            .toLowerCase()
            .compareTo(
          b.key.toLowerCase(),
        ),
      );

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        //--------------------------------------------------
        // CONTENUTO PRINCIPALE
        //--------------------------------------------------

        RequestPayloadCard(
          title: payload.hasTitle
              ? payload.title!
              : "Richiesta personalizzata",
          value: payload.hasMessage
              ? payload.message!
              : "Nessuna descrizione disponibile.",
          icon: Icons.auto_awesome,
          color: Colors.indigo,
        ),

        //--------------------------------------------------
        // CATEGORIA
        //--------------------------------------------------

        if (category != null &&
            category.trim().isNotEmpty) ...[
          const SizedBox(height: 18),

          RequestPayloadBadge(
            label: category,
            icon: Icons.category,
            color: Colors.indigo,
          ),
        ],

        //--------------------------------------------------
        // NOTE
        //--------------------------------------------------

        if (note != null &&
            note.trim().isNotEmpty) ...[
          const SizedBox(height: 18),

          RequestPayloadCard(
            title: "Note",
            value: note,
            icon: Icons.notes,
            color: Colors.orange,
          ),
        ],

        //--------------------------------------------------
        // DATI AGGIUNTIVI
        //--------------------------------------------------

        if (extraEntries.isNotEmpty) ...[
          const SizedBox(height: 28),

          const Divider(),

          const SizedBox(height: 20),

          const Text(
            "Informazioni aggiuntive",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          ...extraEntries.map(
                (entry) => Padding(
              padding:
              const EdgeInsets.only(
                bottom: 12,
              ),
              child: RequestPayloadCard(
                title: entry.key,
                value: entry.value.toString(),
                icon: Icons.info_outline,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ],
    );
  }
}