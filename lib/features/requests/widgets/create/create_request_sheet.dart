import 'package:flutter/material.dart';

import '../../../shared/widgets/sheets/app_bottom_sheet.dart';
import '../../models/appointment_request.dart';

class CreateRequestSheet extends StatelessWidget {
  const CreateRequestSheet({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<AppointmentRequestType> onSelected;

  static Future<void> show(
      BuildContext context, {
        required ValueChanged<AppointmentRequestType> onSelected,
      }) {
    return AppBottomSheet.show(
      context,
      title: "Nuova richiesta",
      subtitle: "Scegli la modifica da proporre al cliente",
      showCloseButton: true,
      child: CreateRequestSheet(
        onSelected: (type) {
          Navigator.pop(context);
          onSelected(type);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Tile(
          icon: Icons.schedule,
          color: Colors.blue,
          title: "Cambio orario",
          subtitle: "Proponi una nuova data o un nuovo orario",
          onTap: () => onSelected(
            AppointmentRequestType.reschedule,
          ),
        ),
        const SizedBox(height: 12),
        _Tile(
          icon: Icons.badge,
          color: Colors.deepPurple,
          title: "Cambio operatore",
          subtitle: "Assegna un nuovo operatore",
          onTap: () => onSelected(
            AppointmentRequestType.changeEmployee,
          ),
        ),
        const SizedBox(height: 12),
        _Tile(
          icon: Icons.content_cut,
          color: Colors.teal,
          title: "Cambio servizi",
          subtitle: "Modifica i servizi prenotati",
          onTap: () => onSelected(
            AppointmentRequestType.changeServices,
          ),
        ),
        const SizedBox(height: 12),
        _Tile(
          icon: Icons.cancel_outlined,
          color: Colors.red,
          title: "Annullamento",
          subtitle: "Proponi l'annullamento dell'appuntamento",
          onTap: () => onSelected(
            AppointmentRequestType.cancelAppointment,
          ),
        ),
        const SizedBox(height: 12),
        _Tile(
          icon: Icons.edit_note,
          color: Colors.orange,
          title: "Richiesta personalizzata",
          subtitle: "Invia una proposta libera al cliente",
          onTap: () => onSelected(
            AppointmentRequestType.custom,
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: .12),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}