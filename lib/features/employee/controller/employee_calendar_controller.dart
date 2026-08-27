import 'package:flutter/material.dart';

import '../models/employee_calendar_model.dart';
import '../services/employee_calendar_service.dart';

class EmployeeCalendarController extends ChangeNotifier {
  EmployeeCalendarController(this._service);

  final EmployeeCalendarService _service;

  List<EmployeeCalendarModel> _events = [];

  bool _loading = false;

  String? _error;

  List<EmployeeCalendarModel> get events => _events;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> loadEvents({
    required String employeeId,
    required DateTime date,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _service.getEventsByEmployeeAndDate(
        employeeId: employeeId,
        date: date,
      );
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
  Future<List<EmployeeCalendarModel>> getEventsByEmployeeAndDate({
    required String employeeId,
    required DateTime date,
  }) {
    return _service.getEventsByEmployeeAndDate(
      employeeId: employeeId,
      date: date,
    );
  }

  Future<void> loadEmployeeEvents({
    required String employeeId,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _service.getEventsByEmployee(
        employeeId: employeeId,
      );
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<EmployeeCalendarModel?> getEvent({
    required String eventId,
  }) {
    return _service.getEvent(
      eventId: eventId,
    );
  }

  Future<void> createEvent({
    required EmployeeCalendarModel event,
  }) async {
    await _service.createEvent(
      event: event,
    );

    _events.add(event);

    _events.sort(
          (a, b) => a.start.compareTo(b.start),
    );

    notifyListeners();
  }

  Future<void> updateEvent({
    required EmployeeCalendarModel event,
  }) async {
    await _service.updateEvent(
      event: event,
    );

    final index = _events.indexWhere(
          (e) => e.id == event.id,
    );

    if (index != -1) {
      _events[index] = event;
    }

    _events.sort(
          (a, b) => a.start.compareTo(b.start),
    );

    notifyListeners();
  }

  Future<void> deleteEvent({
    required String eventId,
  }) async {
    await _service.deleteEvent(
      eventId: eventId,
    );

    _events.removeWhere(
          (e) => e.id == eventId,
    );

    notifyListeners();
  }

  Stream<List<EmployeeCalendarModel>> watchEvents({
    required String employeeId,
  }) {
    return _service.watchEventsByEmployee(
      employeeId: employeeId,
    );
  }

  void clear() {
    _events = [];
    _loading = false;
    _error = null;
    notifyListeners();
  }

  List<EmployeeCalendarModel> eventsForDay(
      DateTime day,
      ) {
    return _events.where(
          (event) {
        final start = DateTime(
          event.startDate.year,
          event.startDate.month,
          event.startDate.day,
        );

        final end = DateTime(
          event.endDate.year,
          event.endDate.month,
          event.endDate.day,
        );

        final current = DateTime(
          day.year,
          day.month,
          day.day,
        );

        return !current.isBefore(start) &&
            !current.isAfter(end);
      },
    ).toList();
  }

  bool overlaps({
    required DateTime start,
    required DateTime end,
    required DateTime otherStart,
    required DateTime otherEnd,
  }) {
    return start.isBefore(otherEnd) &&
        end.isAfter(otherStart);
  }

  bool hasConflict({
    required DateTime start,
    required DateTime end,
    String? ignoreEventId,
  }) {
    return _events.any(
          (event) {
        if (ignoreEventId != null &&
            event.id == ignoreEventId) {
          return false;
        }

        return overlaps(
          start: start,
          end: end,
          otherStart: event.startDate,
          otherEnd: event.endDate,
        );
      },
    );
  }

  List<EmployeeCalendarModel> conflicts({
    required DateTime start,
    required DateTime end,
    String? ignoreEventId,
  }) {
    return _events.where(
          (event) {
        if (ignoreEventId != null &&
            event.id == ignoreEventId) {
          return false;
        }

        return overlaps(
          start: start,
          end: end,
          otherStart: event.startDate,
          otherEnd: event.endDate,
        );
      },
    ).toList();
  }
}