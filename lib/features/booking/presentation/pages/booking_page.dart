import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/routes.dart';

import '../../../appointment/appointment_providers.dart';
import '../../../appointment/models/appointment_model.dart';

import 'package:salon_booking/features/employee/models/employee_model.dart';
import '../../../employee/employee_calendar_providers.dart';

import '../../../salon/models/salon_model.dart';

import '../../../service/models/service_model.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({
    super.key,
    required this.salon,
    required this.service,
    required this.employee,
  });

  final SalonModel salon;
  final ServiceModel service;
  final EmployeeModel employee;

  @override
  ConsumerState<BookingPage> createState() =>
      _BookingPageState();
}

class _BookingPageState
    extends ConsumerState<BookingPage> {

  DateTime? date;
  TimeOfDay? time;

  bool saving = false;
  bool loadingTimes = false;

  static const int slotInterval = 30;

  List<TimeOfDay> availableTimes = [];

  bool get canBook =>
      date != null &&
      time != null &&
      !saving;

  String format(TimeOfDay t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  String formatDate(DateTime d) {
    return DateFormat(
      'EEEE d MMMM yyyy',
      'it_IT',
    ).format(d);
  }

  bool _overlap(
    DateTime start1,
    DateTime end1,
    DateTime start2,
    DateTime end2,
  ) {
    return start1.isBefore(end2) &&
        end1.isAfter(start2);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickDate() async {

    DateTime firstAvailable = DateTime.now();

    while (!widget.employee.workingDays.contains(firstAvailable.weekday)) {
      firstAvailable = firstAvailable.add(const Duration(days: 1));
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: firstAvailable,
      firstDate: firstAvailable,
      lastDate: firstAvailable.add(
        const Duration(days: 90),
      ),
      locale: const Locale('it', 'IT'),
      selectableDayPredicate: (day) {

        return widget.employee.workingDays.contains(day.weekday);

      },
    );

    if (picked == null) return;

    setState(() {
      date = picked;
      time = null;
    });

    await _generateAvailableSlots();
  }

  Future<void> _generateAvailableSlots() async {

    if (date == null) {
      return;
    }
    print("STEP 0 - inizio _generateAvailableSlots");

    setState(() {
      loadingTimes = true;
      availableTimes = [];
    });

    final appointmentController =
        ref.read(
      appointmentControllerProvider,
    );

    final calendarController =
        ref.read(
      employeeCalendarControllerProvider,
    );
    print("STEP 1 - carico appuntamenti");

    final appointments =
        await appointmentController
            .getEmployeeAppointmentsByDate(
      employeeId: widget.employee.id,
      date: date!,
    );
    print("STEP 2 - appuntamenti caricati: ${appointments.length}");

    print("STEP 3 - carico calendario");

    await calendarController.loadEvents(
      employeeId: widget.employee.id,
      date: date!,
    );

    print("STEP 4 - calendario caricato");
    print("STEP 5 - eventi: ${calendarController.events.length}");

    final slots = <TimeOfDay>[];
    final firstHour = widget.employee.startHour;
    final lastHour = widget.employee.endHour;

    for (
    int hour = firstHour;
    hour < lastHour;
    hour++
    ) {

      for (
        int minute = 0;
        minute < 60;
        minute += slotInterval
      ) {

        final slotStart = DateTime(
          date!.year,
          date!.month,
          date!.day,
          hour,
          minute,
        );

        final slotEnd = slotStart.add(
          Duration(
            minutes: widget.service.duration,
          ),
        );

        final closing = DateTime(
          date!.year,
          date!.month,
          date!.day,
          widget.employee.endHour,
        );

        if (slotEnd.isAfter(closing)) {
          continue;
        }
        final slotMinutes =
            slotStart.hour * 60 + slotStart.minute;

        final slotEndMinutes =
            slotEnd.hour * 60 + slotEnd.minute;

        if (widget.employee.hasBreak) {
          if (slotMinutes < widget.employee.breakEnd &&
              slotEndMinutes > widget.employee.breakStart) {
            continue;
          }
        }

        bool busy = false;

        // ===========================
        // Controllo appuntamenti
        // ===========================

        for (final appointment in appointments) {

          if (appointment.isCancelled) {
            continue;
          }

          final bookingStart =
              appointment.appointmentDate;

          final bookingEnd =
              bookingStart.add(
            Duration(
              minutes: appointment.duration,
            ),
          );

          if (_overlap(
            slotStart,
            slotEnd,
            bookingStart,
            bookingEnd,
          )) {

            busy = true;
            break;

          }

        }

        if (busy) {
          continue;
        }

        // ===========================
        // Controllo calendario dipendenti
        // ===========================

        busy = calendarController.hasConflict(
          start: slotStart,
          end: slotEnd,
        );

        if (busy) {
          continue;
        }

        if (!busy) {

          slots.add(

            TimeOfDay(
              hour: hour,
              minute: minute,
            ),

          );

        }

      }

    }

    if (!mounted) {
      return;
    }

    setState(() {
      print("STEP 6 - slot disponibili: ${slots.length}");

      availableTimes = slots;
      loadingTimes = false;

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Conferma prenotazione',
        ),
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          Card(

            elevation: 1,

            child: Padding(

              padding: const EdgeInsets.all(18),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(

                    children: [

                      CircleAvatar(

                        radius: 28,

                        backgroundImage:
                            widget.employee.photoUrl.isEmpty
                                ? null
                                : NetworkImage(
                                    widget.employee.photoUrl,
                                  ),

                        child:
                            widget.employee.photoUrl.isEmpty
                                ? Text(
                                    widget.employee.name[0]
                                        .toUpperCase(),
                                  )
                                : null,

                      ),

                      const SizedBox(width: 14),

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(

                              widget.employee.name,

                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),

                            ),

                            Text(

                              widget.employee.specialization,

                              style: const TextStyle(
                                color: Colors.grey,
                              ),

                            ),

                          ],

                        ),

                      ),

                    ],

                  ),

                  const Divider(height: 32),
                  _row(
                    Icons.store,
                    widget.salon.name,
                  ),

                  _row(
                    Icons.content_cut,
                    widget.service.name,
                  ),

                  _row(
                    Icons.schedule,
                    '${widget.service.duration} min',
                  ),

                  _row(
                    Icons.euro,
                    '€ ${widget.service.price.toStringAsFixed(2)}',
                  ),

                ],

              ),

            ),

          ),

          const SizedBox(height: 24),

          Card(

            child: ListTile(

              leading: const Icon(
                Icons.calendar_month,
              ),

              title: const Text(
                'Data',
              ),

              subtitle: Text(

                date == null
                    ? 'Seleziona una data'
                    : formatDate(date!),

              ),

              trailing: const Icon(
                Icons.chevron_right,
              ),

              onTap: saving
                  ? null
                  : pickDate,

            ),

          ),

          const SizedBox(height: 24),

          const Text(

            'Orari disponibili',

            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),

          ),

          const SizedBox(height: 12),

          if (date == null)

            const Card(

              child: Padding(

                padding: EdgeInsets.all(16),

                child: Text(
                  'Seleziona prima una data.',
                ),

              ),

            )

          else if (loadingTimes)

            const Padding(

              padding: EdgeInsets.symmetric(
                vertical: 24,
              ),

              child: Center(
                child: CircularProgressIndicator(),
              ),

            )

          else if (availableTimes.isEmpty)

            Card(

              color: Colors.orange.shade50,

              child: const Padding(

                padding: EdgeInsets.all(16),

                child: Text(
                  'Nessun orario disponibile per questa giornata.',
                ),

              ),

            )

          else

            Wrap(

              spacing: 8,

              runSpacing: 8,

              children: availableTimes.map(

                (slot) {

                  return ChoiceChip(

                    label: Text(
                      format(slot),
                    ),

                    selected: time == slot,

                    onSelected: saving
                        ? null
                        : (_) {

                            setState(() {
                              time = slot;
                            });

                          },

                  );

                },

              ).toList(),

            ),

          const SizedBox(height: 28),

          Card(

            color: Colors.blue.shade50,

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(

                    'Riepilogo',

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),

                  ),

                  const SizedBox(height: 10),

                  Text(widget.salon.name),

                  Text(widget.employee.name),

                  Text(widget.service.name),

                  Text(
                    'Durata ${widget.service.duration} min',
                  ),

                  if (date != null)
                    Text(
                      formatDate(date!),
                    ),

                  if (time != null)
                    Text(
                      format(time!),
                    ),

                  const SizedBox(height: 8),

                  Text(

                    'Totale € ${widget.service.price.toStringAsFixed(2)}',

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),

                  ),

                ],

              ),

            ),

          ),

          const SizedBox(height: 30),

          SizedBox(

            height: 54,

            child: ElevatedButton.icon(

              onPressed: canBook
                  ? save
                  : null,

              icon: saving

                  ? const SizedBox(

                      width: 18,
                      height: 18,

                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),

                    )

                  : const Icon(
                      Icons.check_circle,
                    ),

              label: Text(

                saving
                    ? 'Salvataggio...'
                    : 'Conferma prenotazione',

              ),

            ),

          ),

          const SizedBox(height: 30),

        ],

      ),

    );

  }
  Future<void> save() async {

    if (!canBook) {
      msg('Seleziona data e orario');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      msg('Login richiesto');
      return;
    }

    setState(() {
      saving = true;
    });

    try {

      // Ricontrollo disponibilità
      await _generateAvailableSlots();

      final stillAvailable = availableTimes.any(
        (slot) =>
            slot.hour == time!.hour &&
            slot.minute == time!.minute,
      );

      if (!stillAvailable) {

        msg(
          'Questo orario non è più disponibile.',
        );

        setState(() {
          saving = false;
          time = null;
        });

        return;
      }

      final id = FirebaseFirestore.instance
          .collection('appointments')
          .doc()
          .id;

      final appointment = AppointmentModel(
        id: id,

        userId: user.uid,

        salonId: widget.salon.id,
        salonName: widget.salon.name,
        salonAddress: widget.salon.address,

        customerName: user.displayName ?? '',
        customerPhone: user.phoneNumber ?? '',

        employeeId: widget.employee.id,
        employeeName: widget.employee.name,
        employeePhone: widget.employee.phone,
        employeeSpecialization: widget.employee.specialization,
        employeeRating: widget.employee.rating,

        serviceId: widget.service.id,
        serviceName: widget.service.name,
        serviceDuration: widget.service.duration,
        duration: widget.service.duration,
        price: widget.service.price,

        date: Timestamp.fromDate(
          DateTime(
            date!.year,
            date!.month,
            date!.day,
            time!.hour,
            time!.minute,
          ),
        ),

        status: 'Prenotata',

        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),

        notes: '',
      );

      await ref
          .read(
            appointmentControllerProvider,
          )
          .createAppointment(
            appointment,
          );

      if (!mounted) return;

      _successDialog();

    } catch (e, s) {

      print("===== SAVE ERROR =====");
      print(e);
      print(s);

      msg("Errore: $e");

    } finally {

      if (mounted) {

        setState(() {
          saving = false;
        });

      }

    }

  }

  void _successDialog() {

    showDialog(

      context: context,

      barrierDismissible: false,

      builder: (_) => AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        title: const Text(
          'Prenotazione confermata 🎉',
        ),

        content: Column(

          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(widget.salon.name),

            Text(widget.employee.name),

            Text(widget.service.name),

            const SizedBox(height: 10),

            Text(
              formatDate(date!),
            ),

            Text(
              format(time!),
            ),

          ],

        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.of(context)
                  .popUntil(
                (r) => r.isFirst,
              );

            },

            child: const Text('Home'),

          ),

          FilledButton(

            onPressed: () {

              Navigator.pop(context);

              context.go(
                AppRoutes.appointments,
              );

            },

            child: const Text(
              'I miei appuntamenti',
            ),

          ),

        ],

      ),

    );

  }

  Widget _row(
    IconData icon,
    String text,
  ) {

    return Padding(

      padding: const EdgeInsets.only(
        bottom: 10,
      ),

      child: Row(

        children: [

          Icon(
            icon,
            size: 18,
            color: Colors.grey,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(text),
          ),

        ],

      ),

    );

  }

  void msg(String text) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content: Text(text),
      ),

    );

  }

}