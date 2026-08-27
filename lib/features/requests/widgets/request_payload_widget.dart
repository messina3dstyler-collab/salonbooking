import 'package:flutter/material.dart';

import '../models/appointment_request.dart';

class RequestPayloadWidget extends StatelessWidget {
  const RequestPayloadWidget({
    super.key,
    required this.request,
  });

  final AppointmentRequest request;

  @override
  Widget build(BuildContext context) {
    switch (request.type) {
      case AppointmentRequestType.reschedule:
        return _ReschedulePayload(
          payload: request.payload,
        );

      case AppointmentRequestType.changeEmployee:
        return _EmployeePayload(
          payload: request.payload,
        );

      case AppointmentRequestType.changeServices:
        return _ServicesPayload(
          payload: request.payload,
        );

      case AppointmentRequestType.cancelAppointment:
        return _CancellationPayload(
          payload: request.payload,
        );

      case AppointmentRequestType.custom:
        return _CustomPayload(
          payload: request.payload,
        );
    }
  }
}

class _ReschedulePayload extends StatelessWidget {
  const _ReschedulePayload({
    required this.payload,
  });

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PayloadTile(
          icon: Icons.schedule,
          title: "Vecchio appuntamento",
          value: payload["oldStart"]?.toString() ?? "-",
        ),
        _PayloadTile(
          icon: Icons.update,
          title: "Nuovo appuntamento",
          value: payload["newStart"]?.toString() ?? "-",
        ),
        if (payload["oldEmployeeName"] != null)
          _PayloadTile(
            icon: Icons.person_outline,
            title: "Operatore attuale",
            value: payload["oldEmployeeName"].toString(),
          ),
        if (payload["newEmployeeName"] != null)
          _PayloadTile(
            icon: Icons.person,
            title: "Nuovo operatore",
            value: payload["newEmployeeName"].toString(),
          ),
        if ((payload["message"] ?? "").toString().isNotEmpty)
          _PayloadTile(
            icon: Icons.message_outlined,
            title: "Messaggio",
            value: payload["message"].toString(),
          ),
      ],
    );
  }
}

class _EmployeePayload extends StatelessWidget {
  const _EmployeePayload({
    required this.payload,
  });

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PayloadTile(
          icon: Icons.person_outline,
          title: "Operatore attuale",
          value: payload["oldEmployeeName"]?.toString() ?? "-",
        ),
        _PayloadTile(
          icon: Icons.person,
          title: "Nuovo operatore",
          value: payload["newEmployeeName"]?.toString() ??
              payload["newEmployee"]?.toString() ??
              "-",
        ),
      ],
    );
  }
}

class _ServicesPayload extends StatelessWidget {
  const _ServicesPayload({
    required this.payload,
  });

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: payload.entries.map((entry) {
        return _PayloadTile(
          icon: Icons.content_cut,
          title: entry.key,
          value: entry.value.toString(),
        );
      }).toList(),
    );
  }
}

class _CancellationPayload extends StatelessWidget {
  const _CancellationPayload({
    required this.payload,
  });

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PayloadTile(
          icon: Icons.cancel_outlined,
          title: "Motivazione",
          value: payload["reason"]?.toString() ??
              payload["message"]?.toString() ??
              "-",
        ),
      ],
    );
  }
}

class _CustomPayload extends StatelessWidget {
  const _CustomPayload({
    required this.payload,
  });

  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: payload.entries.map((entry) {
        return _PayloadTile(
          icon: Icons.info_outline,
          title: entry.key,
          value: entry.value.toString(),
        );
      }).toList(),
    );
  }
}

class _PayloadTile extends StatelessWidget {
  const _PayloadTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: .35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}