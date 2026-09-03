import '../models/employee_calendar_model.dart';
import '../repositories/employee_calendar_repository.dart';

class EmployeeCalendarService {
  EmployeeCalendarService(this._repository);

  final EmployeeCalendarRepository _repository;

  Future<List<EmployeeCalendarModel>> getEventsByEmployeeAndDate({
    required String salonId,
    required String employeeId,
    required DateTime date,
  }) {
    return _repository.getEventsByEmployeeAndDate(
      salonId: salonId,
      employeeId: employeeId,
      date: date,
    );
  }

  Future<List<EmployeeCalendarModel>> getEventsByEmployee({
    required String salonId,
    required String employeeId,
  }) {
    return _repository.getEventsByEmployee(
      salonId: salonId,
      employeeId: employeeId,
    );
  }

  Future<EmployeeCalendarModel?> getEvent({
    required String salonId,
    required String eventId,
  }) {
    return _repository.getEvent(
      salonId: salonId,
      eventId: eventId,
    );
  }

  Stream<List<EmployeeCalendarModel>> watchEventsByEmployee({
    required String salonId,
    required String employeeId,
  }) {
    return _repository.watchEventsByEmployee(
      salonId: salonId,
      employeeId: employeeId,
    );
  }

  Future<void> createEvent({
    required String salonId,
    required EmployeeCalendarModel event,
  }) {
    return _repository.createEvent(
      salonId: salonId,
      event: event,
    );
  }

  Future<void> updateEvent({
    required String salonId,
    required EmployeeCalendarModel event,
  }) {
    return _repository.updateEvent(
      salonId: salonId,
      event: event,
    );
  }

  Future<void> deleteEvent({
    required String salonId,
    required String eventId,
  }) {
    return _repository.deleteEvent(
      salonId: salonId,
      eventId: eventId,
    );
  }
}