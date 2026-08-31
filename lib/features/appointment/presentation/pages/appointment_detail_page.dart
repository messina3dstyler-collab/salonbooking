import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/theme.dart';
import '../../../employee/models/employee_model.dart';
import '../../../review/models/review_model.dart';
import '../../../review/review_providers.dart';
import '../../../review/widgets/review_form_dialog.dart';
import '../../../service/models/service_model.dart';
import '../../models/appointment_model.dart';

class AppointmentDetailPage extends ConsumerStatefulWidget {
  const AppointmentDetailPage({
    super.key,
    required this.appointment,
  });

  final AppointmentModel appointment;

  @override
  ConsumerState<AppointmentDetailPage> createState() =>
      _AppointmentDetailPageState();
}

class _AppointmentDetailPageState
    extends ConsumerState<AppointmentDetailPage> {
  late AppointmentModel appointment;

  ReviewModel? review;
  EmployeeModel? employee;
  ServiceModel? service;
  Map<String, dynamic>? customer;

  bool loading = true;
  bool checkingReview = true;

  @override
  void initState() {
    super.initState();

    appointment = widget.appointment;

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(appointment.userId)
          .get();

      final employeeFuture = FirebaseFirestore.instance
          .collection('employees')
          .doc(appointment.employeeId)
          .get();

      final serviceFuture = FirebaseFirestore.instance
          .collection('services')
          .doc(appointment.serviceId)
          .get();

      final results = await Future.wait([
        userFuture,
        employeeFuture,
        serviceFuture,
      ]);

      final userDoc = results[0];
      final employeeDoc = results[1];
      final serviceDoc = results[2];

      if (userDoc.exists) {
        customer = userDoc.data();
      }

      if (employeeDoc.exists) {
        employee = EmployeeModel.fromMap(
          employeeDoc.id,
          employeeDoc.data()!,
        );
      }

      if (serviceDoc.exists) {
        service = ServiceModel.fromMap(
          serviceDoc.id,
          serviceDoc.data()!,
        );
      }

      await _checkReview();
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _checkReview() async {
    try {
      review = await ref
          .read(reviewControllerProvider)
          .getAppointmentReview(
        salonId: appointment.salonId,
        appointmentId: appointment.id,
      );

      if (review != null) {
        appointment = appointment.copyWith(
          reviewId: review!.id,
          hasReview: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          checkingReview = false;
        });
      }
    }
  }

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

  Widget item(
      IconData icon,
      String title,
      String value,
      ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        value.isEmpty ? '--' : value,
      ),
    );
  }

  Future<void> openReview() async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => ReviewFormDialog(
        appointment: appointment,
      ),
    );

    if (saved == true) {
      setState(() {
        checkingReview = true;
      });

      await _checkReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final date = appointment.appointmentDate;
    final statusColor = _statusColor();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dettaglio appuntamento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppRadius.xl,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informazioni prenotazione',
                  style: AppTextStyles.titleLarge,
                ),

                const SizedBox(height: 16),

                item(
                  Icons.person,
                  'Cliente',
                  customer?['name']?.toString() ?? '',
                ),

                item(
                  Icons.phone,
                  'Telefono',
                  customer?['phone']?.toString() ?? '',
                ),

                const Divider(),

                item(
                  Icons.store,
                  'Salone',
                  appointment.salonName,
                ),

                item(
                  Icons.location_on,
                  'Indirizzo',
                  appointment.salonAddress,
                ),

                const Divider(),

                item(
                  Icons.badge,
                  'Operatore',
                  employee?.name ?? '',
                ),

                if ((employee?.phone ?? '').isNotEmpty)
                  item(
                    Icons.phone,
                    'Telefono operatore',
                    employee!.phone,
                  ),

                if ((employee?.specialization ?? '').isNotEmpty)
                  item(
                    Icons.work,
                    'Specializzazione',
                    employee!.specialization,
                  ),

                if ((employee?.rating ?? 0) > 0)
                  item(
                    Icons.star,
                    'Valutazione',
                    '${employee!.rating.toStringAsFixed(1)} / 5',
                  ),

                const Divider(),

                item(
                  Icons.design_services,
                  'Servizio',
                  service?.name ?? '',
                ),

                if (service != null)
                  item(
                    Icons.timer,
                    'Durata',
                    '${service!.duration} minuti',
                  ),

                if (service != null)
                  item(
                    Icons.euro,
                    'Prezzo',
                    '${service!.price.toStringAsFixed(2)} €',
                  ),

                const Divider(),

                item(
                  Icons.calendar_today,
                  'Data',
                  DateFormat('dd/MM/yyyy').format(date),
                ),

                item(
                  Icons.access_time,
                  'Ora',
                  DateFormat('HH:mm').format(date),
                ),

                const Divider(),

                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: statusColor,
                  ),
                  title: const Text('Stato'),
                  subtitle: Text(
                    appointment.displayStatus,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (appointment.notes.isNotEmpty) ...[
                  const Divider(),

                  item(
                    Icons.notes,
                    'Note',
                    appointment.notes,
                  ),
                ],

                if (appointment.isCompleted) ...[
                  const Divider(),

                  if (checkingReview)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (review != null)
                    ListTile(
                      leading: const Icon(
                        Icons.rate_review,
                        color: Colors.amber,
                      ),
                      title: const Text(
                        'Recensione inviata',
                      ),
                      subtitle: Text(
                        '${review!.rating.toStringAsFixed(1)} ⭐',
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.rate_review,
                        ),
                        label: const Text(
                          'Lascia recensione',
                        ),
                        onPressed: openReview,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}