import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';
import '../repositories/appointment_repository.dart';

class AppointmentService {
  AppointmentService(this._repository);

  final AppointmentRepository _repository;

  //--------------------------------------------------
  // CRUD
  //--------------------------------------------------

  Future<void> createAppointment({
    required AppointmentModel appointment,
  }) =>
      _repository.createAppointment(
        appointment: appointment,
      );

  Future<void> updateAppointment({
    required AppointmentModel appointment,
  }) =>
      _repository.updateAppointment(
        appointment: appointment,
      );

  Future<void> patchAppointment({
    required String appointmentId,
    required Map<String, dynamic> changes,
  }) =>
      _repository.patchAppointment(
        appointmentId: appointmentId,
        changes: changes,
      );

  Future<void> deleteAppointment({
    required String appointmentId,
  }) =>
      _repository.deleteAppointment(
        appointmentId: appointmentId,
      );

  //--------------------------------------------------
  // BUSINESS
  //--------------------------------------------------

  Future<void> rescheduleAppointment({
    required String appointmentId,
    required DateTime newStart,
    required int duration,
    String? employeeId,
  }) async {
    final changes = <String, dynamic>{
      "date": Timestamp.fromDate(newStart),
      "duration": duration,
    };

    if (employeeId != null &&
        employeeId.isNotEmpty) {
      changes["employeeId"] = employeeId;
    }

    await patchAppointment(
      appointmentId: appointmentId,
      changes: changes,
    );
  }

  Future<void> changeEmployee({
    required String appointmentId,
    required String employeeId,
  }) async {
    await patchAppointment(
      appointmentId: appointmentId,
      changes: {
        "employeeId": employeeId,
      },
    );
  }

  Future<void> changeService({
    required String appointmentId,
    required Map<String, dynamic> serviceData,
  }) async {
    await patchAppointment(
      appointmentId: appointmentId,
      changes: serviceData,
    );
  }

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

  Future<List<AppointmentModel>>
  getAppointmentsByUser({
    required String userId,
  }) =>
      _repository.getAppointmentsByUser(
        userId: userId,
      );

  Future<List<AppointmentModel>>
  getAppointmentsBySalon({
    required String salonId,
  }) =>
      _repository.getAppointmentsBySalon(
        salonId: salonId,
      );

  Future<List<AppointmentModel>>
  getAppointmentsByEmployee({
    required String employeeId,
  }) =>
      _repository.getAppointmentsByEmployee(
        employeeId: employeeId,
      );

  Future<List<AppointmentModel>>
  getEmployeeAppointmentsByDate({
    required String employeeId,
    required DateTime date,
  }) =>
      _repository.getEmployeeAppointmentsByDate(
        employeeId: employeeId,
        date: date,
      );

  Future<List<AppointmentModel>>
  getCompletedAppointmentsByUser({
    required String userId,
  }) =>
      _repository
          .getCompletedAppointmentsByUser(
        userId: userId,
      );

  Future<List<AppointmentModel>>
  getAppointmentsBySalonAndDate({
    required String salonId,
    required DateTime date,
  }) =>
      _repository
          .getAppointmentsBySalonAndDate(
        salonId: salonId,
        date: date,
      );

  Future<List<AppointmentModel>>
  getAppointmentsByUserAndDate({
    required String userId,
    required DateTime date,
  }) =>
      _repository
          .getAppointmentsByUserAndDate(
        userId: userId,
        date: date,
      );

  //--------------------------------------------------
  // STATUS
  //--------------------------------------------------

  Future<void> updateStatus({
    required String appointmentId,
    required String status,
  }) =>
      _repository.updateStatus(
        appointmentId: appointmentId,
        status: status,
      );
}