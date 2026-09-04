import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../employee/models/employee_calendar_model.dart';
import '../../employee/services/employee_calendar_service.dart';
import '../extensions/appointment_to_admin_agenda.dart';
import '../extensions/calendar_to_admin_agenda.dart';
import '../models/admin_agenda_item.dart';
import '../models/admin_appointment_model.dart';
import '../services/admin_appointments_service.dart';

class AdminAgendaController extends ChangeNotifier {
  AdminAgendaController(
      this._appointmentsService,
      this._calendarService,
      );

  final AdminAppointmentsService _appointmentsService;
  final EmployeeCalendarService _calendarService;

  final List<AdminAgendaItem> _items = [];

  final List<AdminAppointmentModel> _appointments = [];

  final Map<String, List<EmployeeCalendarModel>> _employeeEvents = {};

  StreamSubscription<List<AdminAppointmentModel>>?
  _appointmentsSubscription;

  final Map<String, StreamSubscription<List<EmployeeCalendarModel>>>
  _calendarSubscriptions = {};

  bool _loading = false;

  bool _started = false;

  String? _error;

  List<AdminAgendaItem> get items => List.unmodifiable(_items);

  bool get loading => _loading;

  bool get started => _started;

  String? get error => _error;

  Future<void> start({
    required String salonId,
    required DateTime day,
    required Map<String, String> employeeNames,
  }) async {
    await stop();

    _loading = true;
    _started = true;
    _error = null;

    notifyListeners();

    _appointmentsSubscription = _appointmentsService
        .watchAppointmentsByDate(
      salonId: salonId,
      date: day,
    )
        .listen(
          (appointments) {
        _appointments
          ..clear()
          ..addAll(appointments);

        _rebuildAgenda(employeeNames);
      },
      onError: (e, st) {
        debugPrint(
          'ADMIN AGENDA APPOINTMENTS ERROR: $e',
        );

        debugPrintStack(
          stackTrace: st,
        );

        _error = e.toString();

        notifyListeners();
      },
    );

    for (final employee in employeeNames.entries) {
      _calendarSubscriptions[employee.key] = _calendarService
          .watchEventsByEmployee(
        salonId: salonId,
        employeeId: employee.key,
      )
          .listen(
            (events) {
          _employeeEvents[employee.key] = events.where((event) {
            return event.startDate.year == day.year &&
                event.startDate.month == day.month &&
                event.startDate.day == day.day;
          }).toList();

          _rebuildAgenda(employeeNames);
        },
        onError: (e, st) {
          debugPrint(
            'ADMIN CALENDAR ERROR: $e',
          );

          debugPrintStack(
            stackTrace: st,
          );

          _error = e.toString();

          notifyListeners();
        },
      );
    }

    _loading = false;

    notifyListeners();
  }

  Future<void> stop() async {
    await _appointmentsSubscription?.cancel();

    _appointmentsSubscription = null;

    for (final subscription in _calendarSubscriptions.values) {
      await subscription.cancel();
    }

    _calendarSubscriptions.clear();

    _appointments.clear();

    _employeeEvents.clear();

    _items.clear();

    _started = false;
  }

  void _rebuildAgenda(
      Map<String, String> employeeNames,
      ) {
    _items.clear();

    _items.addAll(
      _appointments.map(
            (e) => e.toAdminAgendaItem(),
      ),
    );

    for (final employee in employeeNames.entries) {
      final events = _employeeEvents[employee.key] ?? const [];

      _items.addAll(
        events.map(
              (e) => e.toAdminAgendaItem(
            employeeName: employee.value,
          ),
        ),
      );
    }

    _items.sort(
          (a, b) => a.start.compareTo(b.start),
    );

    notifyListeners();
  }

  void clear() {
    _appointments.clear();

    _employeeEvents.clear();

    _items.clear();

    _loading = false;

    _error = null;

    notifyListeners();
  }

  List<AdminAgendaItem> itemsForEmployee(
      String employeeId,
      ) {
    return _items
        .where(
          (e) => e.employeeId == employeeId,
    )
        .toList();
  }

  List<AdminAgendaItem> itemsForDay(
      DateTime day,
      ) {
    return _items.where(
          (e) {
        return e.start.year == day.year &&
            e.start.month == day.month &&
            e.start.day == day.day;
      },
    ).toList();
  }

  List<AdminAgendaItem> itemsForEmployeeAndDay({
    required String employeeId,
    required DateTime day,
  }) {
    return _items.where(
          (e) {
        return e.employeeId == employeeId &&
            e.start.year == day.year &&
            e.start.month == day.month &&
            e.start.day == day.day;
      },
    ).toList();
  }

  List<AdminAgendaItem> between({
    required DateTime start,
    required DateTime end,
  }) {
    return _items.where(
          (e) {
        return e.start.isBefore(end) &&
            e.end.isAfter(start);
      },
    ).toList();
  }

  bool hasItemsForEmployee(
      String employeeId,
      ) {
    return _items.any(
          (e) => e.employeeId == employeeId,
    );
  }

  AdminAgendaItem? byId(
      String id,
      ) {
    try {
      return _items.firstWhere(
            (e) => e.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _appointmentsSubscription?.cancel();

    for (final subscription in _calendarSubscriptions.values) {
      subscription.cancel();
    }

    _calendarSubscriptions.clear();

    _appointments.clear();

    _employeeEvents.clear();

    _items.clear();

    super.dispose();
  }
}