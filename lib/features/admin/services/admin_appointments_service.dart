import '../models/admin_appointment_model.dart';
import '../repositories/admin_appointments_repository.dart';

class AdminAppointmentsService {
  AdminAppointmentsService(this._repository);

  final AdminAppointmentsRepository _repository;

  Future<List<AdminAppointmentModel>> getAppointmentsWithDetails(
      String salonId,
      ) =>
      _repository.getAppointmentsWithDetails(salonId);

  Future<List<AdminAppointmentModel>> getAppointments(
      String salonId,
      ) =>
      _repository.getAppointments(salonId);

  Future<List<AdminAppointmentModel>> getAppointmentsByDate({
    required String salonId,
    required DateTime date,
  }) =>
      _repository.getAppointmentsByDate(
        salonId: salonId,
        date: date,
      );

  Stream<List<AdminAppointmentModel>> watchAppointmentsByDate({
    required String salonId,
    required DateTime date,
  }) =>
      _repository.watchAppointmentsByDate(
        salonId: salonId,
        date: date,
      );

  Future<void> updateStatus(
      String salonId,
      String appointmentId,
      String status,
      ) =>
      _repository.updateStatus(
        salonId,
        appointmentId,
        status,
      );

  Future<void> updateEmployee({
    required String salonId,
    required String appointmentId,
    required String employeeId,
    required String employeeName,
    required String employeePhone,
    required String employeeSpecialization,
    required double employeeRating,
  }) =>
      _repository.updateEmployee(
        salonId: salonId,
        appointmentId: appointmentId,
        employeeId: employeeId,
        employeeName: employeeName,
        employeePhone: employeePhone,
        employeeSpecialization: employeeSpecialization,
        employeeRating: employeeRating,
      );

  Future<void> deleteAppointment(
      String salonId,
      String appointmentId,
      ) =>
      _repository.deleteAppointment(
        salonId,
        appointmentId,
      );
}