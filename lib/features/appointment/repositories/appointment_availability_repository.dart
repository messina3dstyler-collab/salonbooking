import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_availability_model.dart';
import '../models/appointment_model.dart';
import '../models/appointment_slot_key.dart';

class AppointmentAvailabilityRepository {
  AppointmentAvailabilityRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>>
  get _availability =>
      _firestore.collection('appointment_availability');

  // ==================================================
  // RIFERIMENTI AVAILABILITY
  // ==================================================

  List<DocumentReference<Map<String, dynamic>>>
  buildAvailabilityRefs(
      AppointmentModel appointment,
      ) {
    final slotStarts = AppointmentSlotKey.buildSlots(
      start: appointment.appointmentDate,
      durationMinutes: appointment.duration,
    );

    if (slotStarts.isEmpty) {
      throw StateError(
        'Nessuno slot Availability disponibile '
            'per l\'Appointment.',
      );
    }

    return slotStarts.map((slotStart) {
      final availabilityId = AppointmentSlotKey.build(
        salonId: appointment.salonId,
        employeeId: appointment.employeeId,
        start: slotStart,
      );

      return _availability.doc(availabilityId);
    }).toList();
  }

  // ==================================================
  // LETTURA DISPONIBILITÀ
  // ==================================================

  /// Restituisce gli slot occupati per un dipendente
  /// in una determinata giornata.
  ///
  /// Questo metodo legge esclusivamente la collection
  /// `appointment_availability`.
  ///
  /// Non espone né legge dati privati dell'Appointment:
  /// - userId
  /// - appointmentId
  /// - dati cliente
  /// - stato
  /// - note
  /// - prezzo
  Future<List<AppointmentAvailabilityModel>>
  getAvailabilityByEmployeeAndDate({
    required String salonId,
    required String employeeId,
    required DateTime date,
  }) async {
    _validateId(
      salonId,
      fieldName: 'salonId',
    );

    _validateId(
      employeeId,
      fieldName: 'employeeId',
    );

    final startOfDay = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final startOfNextDay = startOfDay.add(
      const Duration(days: 1),
    );

    final snapshot = await _availability
        .where(
      'salonId',
      isEqualTo: salonId,
    )
        .where(
      'employeeId',
      isEqualTo: employeeId,
    )
        .where(
      'start',
      isGreaterThanOrEqualTo:
      Timestamp.fromDate(startOfDay),
    )
        .where(
      'start',
      isLessThan:
      Timestamp.fromDate(startOfNextDay),
    )
        .orderBy('start')
        .get();

    return snapshot.docs.map((doc) {
      return AppointmentAvailabilityModel.fromMap(
        doc.id,
        doc.data(),
      );
    }).toList();
  }

  // ==================================================
  // SINCRONIZZAZIONE ATOMICA
  // ==================================================

  void syncInTransaction({
    required AppointmentModel? oldAppointment,
    required AppointmentModel? newAppointment,
    required Transaction transaction,
  }) {
    final oldRefs = oldAppointment == null
        ? <DocumentReference<Map<String, dynamic>>>[]
        : buildAvailabilityRefs(oldAppointment);

    final newRefs = _shouldCreateAvailability(
      newAppointment,
    )
        ? buildAvailabilityRefs(newAppointment!)
        : <DocumentReference<Map<String, dynamic>>>[];

    final newPaths = newRefs
        .map((ref) => ref.path)
        .toSet();

    for (final oldRef in oldRefs) {
      if (!newPaths.contains(oldRef.path)) {
        transaction.delete(oldRef);
      }
    }

    if (newAppointment == null ||
        !_shouldCreateAvailability(newAppointment)) {
      return;
    }

    final slotStarts = AppointmentSlotKey.buildSlots(
      start: newAppointment.appointmentDate,
      durationMinutes: newAppointment.duration,
    );

    for (var index = 0;
    index < newRefs.length;
    index++) {
      final slotStart = slotStarts[index];
      final ref = newRefs[index];

      final availability =
      AppointmentAvailabilityModel(
        id: ref.id,
        salonId: newAppointment.salonId,
        employeeId: newAppointment.employeeId,
        start: slotStart,
      );

      if (!availability.isStructurallyValid) {
        throw StateError(
          'La Availability generata non è valida.',
        );
      }

      transaction.set(
        ref,
        availability.toMap(),
      );
    }
  }

  // ==================================================
  // VALIDAZIONE
  // ==================================================

  bool _shouldCreateAvailability(
      AppointmentModel? appointment,
      ) {
    if (appointment == null) {
      return false;
    }

    return !appointment.isCancelled;
  }

  static void _validateId(
      String value, {
        required String fieldName,
      }) {
    if (value.trim().isEmpty) {
      throw ArgumentError(
        '$fieldName non può essere vuoto.',
      );
    }
  }
}