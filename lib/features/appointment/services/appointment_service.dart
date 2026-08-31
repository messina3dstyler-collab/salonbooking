import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';
import '../repositories/appointment_repository.dart';

class AppointmentService {
  AppointmentService(this._repository);

  final AppointmentRepository _repository;

  //--------------------------------------------------
  // CREATION
  //--------------------------------------------------

  Future<void> createAppointment({
    required AppointmentModel appointment,
  }) =>
      _repository.createAppointment(
        appointment: appointment,
      );

  //--------------------------------------------------
  // REQUEST APPLICATION SUPPORT
  //--------------------------------------------------

  Future<void> patchAppointment({
    required String appointmentId,
    required Map<String, dynamic> changes,
    Transaction? transaction,
  }) =>
      _repository.patchAppointment(
        appointmentId: appointmentId,
        changes: changes,
        transaction: transaction,
      );

  //--------------------------------------------------
  // CLIENTE
  //--------------------------------------------------

  Future<void> cancelAppointment({
    required String appointmentId,
  }) =>
      _repository.cancelAppointment(
        appointmentId: appointmentId,
      );

  //--------------------------------------------------
  // READ
  //--------------------------------------------------

  Future<AppointmentModel?> getAppointment({
    required String appointmentId,
  }) =>
      _repository.getAppointment(
        appointmentId: appointmentId,
      );

  Future<List<AppointmentModel>> getAppointmentsByUser({
    required String userId,
  }) =>
      _repository.getAppointmentsByUser(
        userId: userId,
      );

  Future<List<AppointmentModel>> getAppointmentsBySalon({
    required String salonId,
  }) =>
      _repository.getAppointmentsBySalon(
        salonId: salonId,
      );

  Future<List<AppointmentModel>> getAppointmentsByEmployee({
    required String employeeId,
  }) =>
      _repository.getAppointmentsByEmployee(
        employeeId: employeeId,
      );

  Future<List<AppointmentModel>> getEmployeeAppointmentsByDate({
    required String employeeId,
    required DateTime date,
  }) =>
      _repository.getEmployeeAppointmentsByDate(
        employeeId: employeeId,
        date: date,
      );

  Future<List<AppointmentModel>> getCompletedAppointmentsByUser({
    required String userId,
  }) =>
      _repository.getCompletedAppointmentsByUser(
        userId: userId,
      );

  Future<List<AppointmentModel>> getAppointmentsBySalonAndDate({
    required String salonId,
    required DateTime date,
  }) =>
      _repository.getAppointmentsBySalonAndDate(
        salonId: salonId,
        date: date,
      );

  Future<List<AppointmentModel>> getAppointmentsByUserAndDate({
    required String userId,
    required DateTime date,
  }) =>
      _repository.getAppointmentsByUserAndDate(
        userId: userId,
        date: date,
      );
}