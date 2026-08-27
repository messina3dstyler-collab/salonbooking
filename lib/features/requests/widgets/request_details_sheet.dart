import 'package:flutter/material.dart';

import '../../shared/widgets/sheets/app_bottom_sheet.dart';
import '../extensions/appointment_request_display_extension.dart';
import 'payloads/request_payload_builder.dart';
import '../models/appointment_request.dart';
import '../models/request_timeline_event.dart';
import 'request_action_bar.dart';
import 'request_info_tile.dart';
import 'request_section.dart';
import 'request_status_chip.dart';
import 'request_timeline_tile.dart';
import 'request_type_chip.dart';

class RequestDetailsSheet extends StatelessWidget {
  const RequestDetailsSheet({
    super.key,
    required this.request,
    required this.timeline,
    required this.customerName,
    required this.appointmentTitle,
        this.onSend,
    this.onRemind,
    this.onCancel,
    this.onOpenAppointment,
    this.onCreateNewProposal,
  });

  final AppointmentRequest request;
  final List<RequestTimelineEvent> timeline;
  final String customerName;
  final String appointmentTitle;

  final VoidCallback? onSend;
  final VoidCallback? onRemind;
  final VoidCallback? onCancel;
  final VoidCallback? onOpenAppointment;
  final VoidCallback? onCreateNewProposal;

  static Future<void> show(
      BuildContext context, {
        required AppointmentRequest request,
        required List<RequestTimelineEvent> timeline,
        required String customerName,
        required String appointmentTitle,
                VoidCallback? onSend,
        VoidCallback? onRemind,
        VoidCallback? onCancel,
        VoidCallback? onOpenAppointment,
        VoidCallback? onCreateNewProposal,
      }) {
    final display = request.display;

    return AppBottomSheet.show(
      context,
      title: display.title,
      subtitle: display.subtitle,
      showCloseButton: true,
      footer: RequestActionBar(
        request: request,
        onSend: onSend,
        onRemind: onRemind,
        onCancel: onCancel,
        onOpenAppointment: onOpenAppointment,
        onCreateNewProposal: onCreateNewProposal,
      ),
      child: RequestDetailsSheet(
        request: request,
        timeline: timeline,
        customerName: customerName,
        appointmentTitle: appointmentTitle,
        onSend: onSend,
        onRemind: onRemind,
        onCancel: onCancel,
        onOpenAppointment:
        onOpenAppointment,
        onCreateNewProposal:
        onCreateNewProposal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final display = request.display;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RequestStatusChip(
                status: request.status,
              ),
            ),
            const SizedBox(width: 10),
            RequestTypeChip(
              type: request.type,
            ),
          ],
        ),

        const SizedBox(height: 20),

        Card(
          elevation: 0,
          color: Colors.grey.shade50,
          child: Padding(
            padding:
            const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      display.icon,
                      color: display.color,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        display.description,
                        style: TextStyle(
                          color: Colors
                              .grey.shade700,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                ListTile(
                  contentPadding:
                  EdgeInsets.zero,
                  leading:
                  const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                  title: Text(
                    customerName,
                  ),
                  subtitle: Text(
                    appointmentTitle,
                  ),
                ),

                const Divider(
                  height: 28,
                ),

                RequestInfoTile(
                  icon: Icons.store,
                  label: "Salone",
                  value:
                  request.salonName
                      .isEmpty
                      ? "-"
                      : request
                      .salonName,
                ),

                RequestInfoTile(
                  icon:
                  Icons.person_outline,
                  label: "Creata da",
                  value: request
                      .createdByName
                      .isNotEmpty
                      ? request
                      .createdByName
                      : switch (request
                      .createdBy) {
                    RequestAuthor
                        .admin =>
                    "Amministratore",
                    RequestAuthor
                        .employee =>
                    "Operatore",
                    RequestAuthor
                        .customer =>
                    "Cliente",
                    RequestAuthor
                        .system =>
                    "Sistema",
                  },
                ),

                RequestInfoTile(
                  icon:
                  Icons.flag_outlined,
                  label: "Priorità",
                  value:
                  switch (request
                      .priority) {
                    RequestPriority.low =>
                    "Bassa",
                    RequestPriority
                        .normal =>
                    "Normale",
                    RequestPriority.high =>
                    "Alta",
                    RequestPriority
                        .urgent =>
                    "Urgente",
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        RequestSection(
          title: "Dettagli proposta",
          child: RequestPayloadBuilder.build(request),
        ),

        const SizedBox(height: 28),

        RequestSection(
          title: "Cronologia",
          subtitle:
          "${timeline.length} evento${timeline.length == 1 ? "" : "i"}",
          child: timeline.isEmpty
              ? Padding(
            padding:
            const EdgeInsets
                .symmetric(
              vertical: 24,
            ),
            child: Center(
              child: Text(
                "Nessun evento disponibile.",
                style: TextStyle(
                  color: Colors
                      .grey.shade600,
                ),
              ),
            ),
          )
              : Column(
            children: timeline
                .map(
                  (event) =>
                  Padding(
                    padding:
                    const EdgeInsets
                        .only(
                      bottom: 14,
                    ),
                    child:
                    RequestTimelineTile(
                      event: event,
                    ),
                  ),
            )
                .toList(),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}