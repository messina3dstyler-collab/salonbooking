import 'package:flutter/material.dart';
import '../../../../app/theme/theme.dart';
import '../../models/admin_appointment_model.dart';

class AppointmentAdminCard extends StatelessWidget {
  const AppointmentAdminCard({
    super.key,
    required this.appointment,
    required this.onStatusChanged,
  });

  final AdminAppointmentModel appointment;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(appointment: appointment),
            const SizedBox(height: AppSpacing.md),

            _InfoRow(
              icon: Icons.schedule,
              text:
              '${appointment.formattedDate} - ${appointment.formattedTime}',
            ),

            const Divider(),

            const _SectionTitle('Cliente'),

            if (appointment.customerPhone.isNotEmpty)
              _InfoRow(
                icon: Icons.phone,
                text: appointment.customerPhone,
              ),

            if (appointment.customerEmail.isNotEmpty)
              _InfoRow(
                icon: Icons.email,
                text: appointment.customerEmail,
              ),

            const Divider(),

            const _SectionTitle('Dipendente'),

            if (appointment.employeeName.isNotEmpty)
              _InfoRow(
                icon: Icons.person,
                text: appointment.employeeName,
              ),

            if (appointment.employeeSpecialization.isNotEmpty)
              _InfoRow(
                icon: Icons.work,
                text: appointment.employeeSpecialization,
              ),

            if (appointment.employeePhone.isNotEmpty)
              _InfoRow(
                icon: Icons.phone,
                text: appointment.employeePhone,
              ),

            if (appointment.employeeRating > 0)
              _InfoRow(
                icon: Icons.star,
                text:
                '${appointment.employeeRating.toStringAsFixed(1)} / 5',
              ),

            const Divider(),

            const _SectionTitle('Servizio'),

            _InfoRow(
              icon: Icons.content_cut,
              text: appointment.serviceName.isEmpty
                  ? 'Servizio'
                  : appointment.serviceName,
            ),

            if (appointment.serviceDuration > 0)
              _InfoRow(
                icon: Icons.timer,
                text: '${appointment.serviceDuration} minuti',
              ),

            if (appointment.price > 0)
              _InfoRow(
                icon: Icons.euro,
                text: '€ ${appointment.price.toStringAsFixed(2)}',
              ),

            if (appointment.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  appointment.notes,
                  style: AppTextStyles.bodySmall,
                ),
              ),

            const SizedBox(height: AppSpacing.md),

            Wrap(
              spacing: AppSpacing.sm,
              children: [
                if (appointment.isPending)
                  _ActionButton(
                    label: 'Conferma',
                    color: Colors.green,
                    onTap: () => onStatusChanged('Confermata'),
                  ),

                if (appointment.isConfirmed)
                  _ActionButton(
                    label: 'Completa',
                    color: Colors.blue,
                    onTap: () => onStatusChanged('Completata'),
                  ),

                if (appointment.isPending || appointment.isConfirmed)
                  _ActionButton(
                    label: 'Annulla',
                    color: Colors.red,
                    onTap: () => onStatusChanged('Annullata'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.appointment});

  final AdminAppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: .15),
          child: Icon(Icons.calendar_month, color: color),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.customerName.isEmpty
                    ? 'Cliente'
                    : appointment.customerName,
                style: AppTextStyles.titleMedium,
              ),
              Text(
                appointment.serviceName.isEmpty
                    ? 'Servizio'
                    : appointment.serviceName,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        _StatusBadge(appointment: appointment),
      ],
    );
  }

  Color get _statusColor {
    switch (appointment.normalizedStatus) {
      case 'prenotata':
        return Colors.orange;
      case 'confermata':
        return Colors.green;
      case 'completata':
        return Colors.blue;
      case 'annullata':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: AppTextStyles.titleSmall,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.appointment});

  final AdminAppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        appointment.displayStatus,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color get _color {
    switch (appointment.normalizedStatus) {
      case 'prenotata':
        return Colors.orange;
      case 'confermata':
        return Colors.green;
      case 'completata':
        return Colors.blue;
      case 'annullata':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
      ),
      child: Text(label),
    );
  }
}