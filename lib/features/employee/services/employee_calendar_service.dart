import '../models/employee_calendar_model.dart';
import '../repositories/employee_calendar_repository.dart';

class EmployeeCalendarService {
  EmployeeCalendarService(this._repository);

  final EmployeeCalendarRepository _repository;

  Future<List<EmployeeCalendarModel>> getEventsByEmployeeAndDate({
    required String employeeId,
    required DateTime date,
  }) =>
      _repository.getEventsByEmployeeAndDate(
        employeeId: employeeId,
        date: date,
      );

  Future<List<EmployeeCalendarModel>> getEventsByEmployee({
    required String employeeId,
  }) =>
      _repository.getEventsByEmployee(
        employeeId: employeeId,
      );

  Future<EmployeeCalendarModel?> getEvent({
    required String eventId,
  }) =>
      _repository.getEvent(
        eventId: eventId,
      );

  Stream<List<EmployeeCalendarModel>> watchEventsByEmployee({
    required String employeeId,
  }) =>
      _repository.watchEventsByEmployee(
        employeeId: employeeId,
      );

  Future<void> createEvent({
    required EmployeeCalendarModel event,
  }) =>
      _repository.createEvent(
        event: event,
      );

  Future<void> updateEvent({
    required EmployeeCalendarModel event,
  }) =>
      _repository.updateEvent(
        event: event,
      );

  Future<void> deleteEvent({
    required String eventId,
  }) =>
      _repository.deleteEvent(
        eventId: eventId,
      );
}