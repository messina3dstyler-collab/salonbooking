import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';
import '../repositories/appointment_repository.dart';

class AppointmentService {
  AppointmentService(this._repository);

  final AppointmentRepository _repository;

  // ==================================================
  // CREAZIONE
  // ==================================================

  /// Crea un Appointment con prenotazione atomica degli slot.
  ///
  /// Questa è l'operazione da utilizzare per una nuova
  /// prenotazione proveniente dal flusso cliente → Booking.
  ///
  /// Appointment + appointment_slots vengono scritti
  /// nella stessa Firestore Transaction.
  Future<void> createAppointmentAtomically({
    required AppointmentModel appointment,
  }) {
    return _repository.createAppointmentAtomically(
      appointment: appointment,
    );
  }

  /// Creazione semplice dell'Appointment.
  ///
  /// Rimane disponibile per i flussi che non richiedono
  /// la reservation degli slot.
  Future<void> createAppointment({
    required AppointmentModel appointment,
  }) {
    return _repository.createAppointment(
      appointment: appointment,
    );
  }

  // ==================================================
  // AGGIORNAMENTO ATOMICO
  // ==================================================

  /// Aggiorna atomicamente un Appointment e la relativa
  /// prenotazione degli slot.
  ///
  /// Gestisce:
  ///
  /// - cambio data/ora;
  /// - cambio dipendente;
  /// - cambio servizio;
  /// - cambio durata;
  /// - cambio stato;
  /// - liberazione dei vecchi slot;
  /// - prenotazione dei nuovi slot.
  ///
  /// L'operazione viene eseguita in una singola Firestore
  /// Transaction.
  Future<void> updateAppointmentAtomically({
    required AppointmentModel appointment,
  }) {
    return _repository.updateAppointmentAtomically(
      appointment: appointment,
    );
  }

  // ==================================================
  // REQUEST → APPOINTMENT
  // ==================================================

  /// Applica una modifica parziale a un Appointment.
  ///
  /// Viene utilizzato dal workflow Request → Appointment e
  /// può essere eseguito all'interno di una Firestore
  /// Transaction chiamante.
  ///
  /// Rimane disponibile per le modifiche che non richiedono
  /// la riallocazione degli appointment_slots.
  Future<void> patchAppointment({
    required String appointmentId,
    required Map<String, dynamic> changes,
    Transaction? transaction,
  }) {
    return _repository.patchAppointment(
      appointmentId: appointmentId,
      changes: changes,
      transaction: transaction,
    );
  }

  // ==================================================
  // CLIENTE
  // ==================================================

  /// Cancella un Appointment liberando atomicamente
  /// gli appointment_slots associati.
  Future<void> cancelAppointment({
    required String appointmentId,
  }) {
    return _repository.cancelAppointment(
      appointmentId: appointmentId,
    );
  }

  // ==================================================
  // READ
  // ==================================================

  Future<AppointmentModel?> getAppointment({
    required String appointmentId,
  }) {
    return _repository.getAppointment(
      appointmentId: appointmentId,
    );
  }

  Future<List<AppointmentModel>> getAppointmentsByUser({
    required String userId,
  }) {
    return _repository.getAppointmentsByUser(
      userId: userId,
    );
  }

  Future<List<AppointmentModel>> getAppointmentsBySalon({
    required String salonId,
  }) {
    return _repository.getAppointmentsBySalon(
      salonId: salonId,
    );
  }

  Future<List<AppointmentModel>> getAppointmentsByEmployee({
    required String employeeId,
  }) {
    return _repository.getAppointmentsByEmployee(
      employeeId: employeeId,
    );
  }

  Future<List<AppointmentModel>> getEmployeeAppointmentsByDate({
    required String employeeId,
    required DateTime date,
  }) {
    return _repository.getEmployeeAppointmentsByDate(
      employeeId: employeeId,
      date: date,
    );
  }

  Future<List<AppointmentModel>> getCompletedAppointmentsByUser({
    required String userId,
  }) {
    return _repository.getCompletedAppointmentsByUser(
      userId: userId,
    );
  }

  Future<List<AppointmentModel>> getAppointmentsBySalonAndDate({
    required String salonId,
    required DateTime date,
  }) {
    return _repository.getAppointmentsBySalonAndDate(
      salonId: salonId,
      date: date,
    );
  }

  Future<List<AppointmentModel>> getAppointmentsByUserAndDate({
    required String userId,
    required DateTime date,
  }) {
    return _repository.getAppointmentsByUserAndDate(
      userId: userId,
      date: date,
    );
  }
}