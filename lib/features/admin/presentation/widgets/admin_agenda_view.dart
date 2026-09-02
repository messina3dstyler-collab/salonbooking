import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../admin_providers.dart';
import 'admin_agenda_header.dart';
import 'admin_agenda_timeline.dart';
import 'admin_appointment_sheet.dart';

class AdminAgendaView extends ConsumerStatefulWidget {
  const AdminAgendaView({
    super.key,
  });

  @override
  ConsumerState<AdminAgendaView> createState() =>
      _AdminAgendaViewState();
}

class _AdminAgendaViewState
    extends ConsumerState<AdminAgendaView>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDay = DateTime.now();

  final ScrollController _verticalController =
  ScrollController();

  final ScrollController _horizontalController =
  ScrollController();

  bool _initialScrollDone = false;
  Timer? _clockTimer;
  late final AnimationController _pulseController;
  late final Animation<double> pulseAnimation;

  void _startClock() {
    _clockTimer?.cancel();

    _clockTimer = Timer.periodic(
      const Duration(minutes: 1),
          (_) {
        if (!mounted) return;

        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    pulseAnimation = Tween<double>(
      begin: .94,
      end: 1.06,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    Future.microtask(() async {
      final salonId =
      ref.read(adminCurrentSalonProvider);

      if (salonId.isEmpty) return;

      final employeeController =
      ref.read(employeeControllerProvider);

      await employeeController.loadAllEmployees(
        salonId,
      );

      await ref
          .read(adminAgendaControllerProvider)
          .start(
        salonId: salonId,
        day: _selectedDay,
        employeeNames: {
          for (final employee
          in employeeController.employees)
            employee.id: employee.name,
        },
      );

      _scrollToCurrentTime();
      _startClock();
    });
  }

  void _scrollToCurrentTime() {
    if (_initialScrollDone) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // aspetta che la timeline sia realmente costruita
      await Future.delayed(
        const Duration(milliseconds: 80),
      );

      if (!_verticalController.hasClients) return;

      final now = DateTime.now();

      final offset =
          (((now.hour * 60) + now.minute) *
              AdminAgendaTimeline.hourHeight /
              60) -
              220;

      final max =
          _verticalController.position.maxScrollExtent;

      _verticalController.jumpTo(
        offset.clamp(0.0, max),
      );

      _initialScrollDone = true;
    });
  }

  Future<void> _changeDay(DateTime day) async {
    setState(() {
      _selectedDay = day;
      _initialScrollDone = false;
    });

    final salonId =
    ref.read(adminCurrentSalonProvider);

    if (salonId.isEmpty) return;

    final employeeController =
    ref.read(employeeControllerProvider);

    final agendaController =
    ref.read(adminAgendaControllerProvider);

    await agendaController.stop();

    await agendaController.start(
      salonId: salonId,
      day: day,
      employeeNames: {
        for (final employee
        in employeeController.employees)
          employee.id: employee.name,
      },
    );

    _scrollToCurrentTime();
  }

  void _showAppointmentSheet(
      BuildContext context,
      dynamic item,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdminAppointmentSheet(
        item: item,

        onEdit: () {
          Navigator.pop(context);

          // TODO modifica appuntamento
        },

        onMove: () {
          Navigator.pop(context);

          // TODO sposta appuntamento
        },

        onCheckIn: () {
          Navigator.pop(context);

          // TODO check-in cliente
        },

        onDelete: () async {
          Navigator.pop(context);

          if (!item.isAppointment) return;

          await ref
              .read(
            adminAppointmentsControllerProvider,
          )
              .deleteAppointment(
            appointmentId: item.id,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _clockTimer?.cancel();

    _pulseController.dispose();

    ref
        .read(adminAgendaControllerProvider)
        .stop();

    _verticalController.dispose();
    _horizontalController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeController =
    ref.watch(employeeControllerProvider);

    final agendaController =
    ref.watch(adminAgendaControllerProvider);

    final employees =
        employeeController.employees;

    final now = DateTime.now();

    final activeEmployees = <String, bool>{};

    for (final employee in employees) {
      activeEmployees[employee.id] =
          agendaController.items.any(
                (item) =>
            item.employeeName == employee.name &&
                now.isAfter(item.start) &&
                now.isBefore(item.end),
          );
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat(
                  'EEEE d MMMM yyyy',
                  'it_IT',
                ).format(_selectedDay),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: () =>
                  _changeDay(DateTime.now()),
              icon: const Icon(Icons.today),
              label: const Text('Oggi'),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _changeDay(
                _selectedDay.subtract(
                  const Duration(days: 1),
                ),
              ),
              icon: const Icon(
                Icons.chevron_left,
              ),
            ),
            IconButton(
              onPressed: () => _changeDay(
                _selectedDay.add(
                  const Duration(days: 1),
                ),
              ),
              icon: const Icon(
                Icons.chevron_right,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          'Visione completa di appuntamenti e calendario dipendenti',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 20),

        Expanded(
          child: employeeController.isLoading ||
              agendaController.loading
              ? const Center(
            child:
            CircularProgressIndicator(),
          )
              : Card(
            elevation: 2,
            shadowColor:
            Colors.black12,
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                24,
              ),
            ),
            clipBehavior:
            Clip.antiAlias,
            child: Column(
              children: [
                Material(
                  elevation: 3,
                  shadowColor:
                  Colors.black12,
                  color: Colors.white,
                  child: Column(
                    children: [
                      AdminAgendaHeader(
                        employees: employees,
                        items:
                        agendaController.items,
                        horizontalController:
                        _horizontalController,
                        activeEmployees:
                        activeEmployees,
                      ),
                      Container(
                        height: 2,
                        color: const Color(
                          0xFFD4AF37,
                        ).withValues(
                          alpha: .45,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                  AdminAgendaTimeline(
                    verticalController:
                    _verticalController,
                    horizontalController:
                    _horizontalController,
                    employees: employees,
                    items:
                    agendaController.items,
                    activeEmployees:
                    activeEmployees,
                    pulseAnimation:
                    pulseAnimation,
                    onAppointmentTap:
                        (item) {
                      _showAppointmentSheet(
                        context,
                        item,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}