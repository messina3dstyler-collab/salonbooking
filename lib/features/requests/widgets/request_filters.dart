import 'package:flutter/material.dart';

import '../models/appointment_request.dart';
import 'request_filter_chip.dart';

class RequestFilters extends StatelessWidget {
  const RequestFilters({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    this.selectedType,
    this.onTypeChanged,
  });

  final AppointmentRequestStatus? selectedStatus;
  final ValueChanged<AppointmentRequestStatus?> onStatusChanged;

  final AppointmentRequestType? selectedType;
  final ValueChanged<AppointmentRequestType?>? onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          RequestFilterChip(
            label: "Tutte",
            selected: selectedStatus == null,
            icon: Icons.list,
            onTap: () => onStatusChanged(null),
          ),
          const SizedBox(width: 8),

          ...AppointmentRequestStatus.values.map(
                (status) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: RequestFilterChip(
                label: _statusLabel(status),
                selected: selectedStatus == status,
                onTap: () => onStatusChanged(status),
              ),
            ),
          ),

          if (onTypeChanged != null) ...[
            const SizedBox(width: 20),

            RequestFilterChip(
              label: "Tipi",
              selected: selectedType == null,
              icon: Icons.category,
              onTap: () => onTypeChanged!(null),
            ),

            const SizedBox(width: 8),

            ...AppointmentRequestType.values.map(
                  (type) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: RequestFilterChip(
                  label: _typeLabel(type),
                  selected: selectedType == type,
                  onTap: () => onTypeChanged!(type),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _statusLabel(AppointmentRequestStatus status) {
    switch (status) {
      case AppointmentRequestStatus.draft:
        return "Bozza";
      case AppointmentRequestStatus.pendingCustomer:
        return "In attesa";
      case AppointmentRequestStatus.accepted:
        return "Accettate";
      case AppointmentRequestStatus.rejected:
        return "Rifiutate";
      case AppointmentRequestStatus.expired:
        return "Scadute";
      case AppointmentRequestStatus.cancelled:
        return "Annullate";
    }
  }

  String _typeLabel(AppointmentRequestType type) {
    switch (type) {
      case AppointmentRequestType.reschedule:
        return "Orario";
      case AppointmentRequestType.changeEmployee:
        return "Operatore";
      case AppointmentRequestType.changeServices:
        return "Servizi";
      case AppointmentRequestType.cancelAppointment:
        return "Annullamento";
      case AppointmentRequestType.custom:
        return "Altro";
    }
  }
}