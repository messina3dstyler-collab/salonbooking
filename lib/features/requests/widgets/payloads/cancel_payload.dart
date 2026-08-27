import 'package:flutter/material.dart';

import '../../models/payloads/cancel_request_payload.dart';

import 'shared/request_payload_badge.dart';
import 'shared/request_payload_card.dart';

class CancelPayload extends StatelessWidget {
  const CancelPayload({
    super.key,
    required this.payload,
  });

  final CancelRequestPayload payload;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        //--------------------------------------------------
        // HEADER
        //--------------------------------------------------

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.red.withValues(
              alpha: .08,
            ),
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: Colors.red.withValues(
                alpha: .18,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(
                    alpha: .12,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
              ),

              const SizedBox(width: 16),

              const Expanded(
                child: Text(
                  "Il salone propone di annullare questo appuntamento.",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        //--------------------------------------------------
        // MOTIVO
        //--------------------------------------------------

        RequestPayloadCard(
          title: "Motivo dell'annullamento",
          value: payload.hasReason
              ? payload.reason!
              : "Motivo non specificato",
          icon: Icons.info_outline,
          color: Colors.red,
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
            color: Colors.orange,
          ),
        ],

        //--------------------------------------------------
        // RIMBORSO
        //--------------------------------------------------

        const SizedBox(height: 18),

        RequestPayloadBadge(
          label: payload.refund
              ? "È previsto il rimborso dell'importo pagato"
              : "Non è previsto alcun rimborso",
          icon: payload.refund
              ? Icons.payments
              : Icons.money_off,
          color: payload.refund
              ? Colors.green
              : Colors.grey,
        ),

        //--------------------------------------------------
        // STATO
        //--------------------------------------------------

        const SizedBox(height: 18),

        const RequestPayloadBadge(
          label:
          "In attesa della risposta del cliente",
          icon: Icons.hourglass_top,
          color: Colors.orange,
        ),
      ],
    );
  }
}