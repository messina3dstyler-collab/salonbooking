import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/theme.dart';
import '../../appointment_providers.dart';
import '../../models/appointment_model.dart';
import '../pages/appointment_detail_page.dart';

class AppointmentCard extends ConsumerWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  final AppointmentModel appointment;

  Color _statusColor() {
    switch (appointment.normalizedStatus) {
      case 'confermata':
        return Colors.green;
      case 'annullata':
        return Colors.red;
      case 'completata':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Future<void> _cancel(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Annullare appuntamento?'),
        content: const Text(
          'Vuoi davvero cancellare questo appuntamento?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sì'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ref
          .read(appointmentControllerProvider)
          .cancelAppointment(
        appointment.id,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appuntamento annullato'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore: $e'),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final date = appointment.appointmentDate;
    final color = _statusColor();

    final canCancel =
        !appointment.isCancelled &&
            !appointment.isCompleted;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(
        bottom: AppSpacing.lg,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat(
                    'dd/MM/yyyy',
                  ).format(date),
                  style:
                  AppTextStyles.titleMedium,
                ),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(
                      alpha: .2,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    appointment.displayStatus,
                    style: TextStyle(
                      color: color,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            _row(
              Icons.store,
              appointment.salonName.isEmpty
                  ? 'Salone non disponibile'
                  : appointment.salonName,
            ),
            _row(
              Icons.location_on,
              appointment.salonAddress.isEmpty
                  ? 'Indirizzo non disponibile'
                  : appointment.salonAddress,
            ),
            _row(
              Icons.access_time,
              DateFormat('HH:mm').format(date),
            ),
            _row(
              Icons.design_services,
              appointment.serviceName.isEmpty
                  ? appointment.serviceId
                  : appointment.serviceName,
            ),
            _row(
              Icons.person,
              appointment.employeeName.isEmpty
                  ? appointment.employeeId
                  : appointment.employeeName,
            ),
            if (appointment
                .employeeSpecialization
                .isNotEmpty)
              _row(
                Icons.work,
                appointment
                    .employeeSpecialization,
              ),
            if (appointment.employeeRating > 0)
              _row(
                Icons.star,
                '${appointment.employeeRating.toStringAsFixed(1)} / 5',
              ),
            if (appointment.price > 0)
              _row(
                Icons.euro,
                '€ ${appointment.price.toStringAsFixed(2)}',
              ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                if (canCancel)
                  TextButton.icon(
                    onPressed: () =>
                        _cancel(context, ref),
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'Annulla',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AppointmentDetailPage(
                              appointment:
                              appointment,
                            ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.visibility,
                  ),
                  label: const Text(
                    'Dettagli',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
      IconData icon,
      String text,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}