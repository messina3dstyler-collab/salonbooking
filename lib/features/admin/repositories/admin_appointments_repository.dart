import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/admin_appointment_model.dart';
import '../models/admin_service_model.dart';
import 'package:salon_booking/features/employee/models/employee_model.dart';
import '../../appointment/models/appointment_model.dart';
import '../../appointment/models/appointment_slot_key.dart';
import '../../appointment/repositories/appointment_availability_repository.dart';

class AdminAppointmentsRepository {
  AdminAppointmentsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  late final AppointmentAvailabilityRepository _availabilityRepository =
      AppointmentAvailabilityRepository(_firestore);

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection('appointments');

  CollectionReference<Map<String, dynamic>> get _appointmentSlots =>
      _firestore.collection('appointment_slots');

  // ==================================================
  // LETTURA
  // ==================================================

  Future<List<AdminAppointmentModel>> getAppointments(
      String salonId,
      ) async {
    final normalizedSalonId = salonId.trim();

    if (normalizedSalonId.isEmpty) {
      throw ArgumentError(
        'salonId non può essere vuoto.',
      );
    }

    try {
      final results = await Future.wait([
        _appointments
            .where(
          'salonId',
          isEqualTo: normalizedSalonId,
        )
            .orderBy('date')
            .get(),
        _firestore.collection('users').get(),
        _firestore
            .collection('salons')
            .doc(normalizedSalonId)
            .collection('employees')
            .get(),
        _firestore
            .collection('salons')
            .doc(normalizedSalonId)
            .collection('services')
            .get(),
      ]);

      final appointmentsSnap = results[0];
      final usersSnap = results[1];
      final employeesSnap = results[2];
      final servicesSnap = results[3];

      final users = {
        for (final document in usersSnap.docs)
          document.id: document.data(),
      };

      final employees = {
        for (final document in employeesSnap.docs)
          document.id: EmployeeModel.fromMap(
            document.id,
            document.data(),
          ),
      };

      final services = {
        for (final document in servicesSnap.docs)
          document.id: AdminServiceModel.fromMap(
            document.id,
            document.data(),
          ),
      };

      return appointmentsSnap.docs.map((doc) {
        final data = Map<String, dynamic>.from(
          doc.data(),
        );

        final user = users[data['userId']] ?? {};
        final employee = employees[data['employeeId']];
        final service = services[data['serviceId']];

        // ==================================================
        // SNAPSHOT CLIENTE
        // ==================================================
        //
        // Se l'Appointment possiede già questi dati,
        // manteniamo lo snapshot storico.
        // Il documento users viene usato solo come fallback.
        //
        data['customerName'] =
            _stringOrFallback(
              data['customerName'],
              user['name'],
            );

        data['customerPhone'] =
            _stringOrFallback(
              data['customerPhone'],
              user['phone'],
            );

        data['customerEmail'] =
            _stringOrFallback(
              data['customerEmail'],
              user['email'],
            );

        // ==================================================
        // SNAPSHOT DIPENDENTE
        // ==================================================
        //
        // Manteniamo i dati salvati sull'Appointment.
        // Il dipendente corrente viene usato come fallback.
        //
        data['employeeName'] =
            _stringOrFallback(
              data['employeeName'],
              employee?.name,
            );

        data['employeePhone'] =
            _stringOrFallback(
              data['employeePhone'],
              employee?.phone,
            );

        data['employeeSpecialization'] =
            _stringOrFallback(
              data['employeeSpecialization'],
              employee?.specialization,
            );

        data['employeeRating'] =
            _numberOrFallback(
              data['employeeRating'],
              employee?.rating,
            );

        // ==================================================
        // SNAPSHOT SERVIZIO
        // ==================================================
        //
        // Anche qui lo snapshot dell'Appointment ha priorità.
        //
        data['serviceName'] =
            _stringOrFallback(
              data['serviceName'],
              service?.name,
            );

        data['serviceDuration'] =
            _numberOrFallback(
              data['serviceDuration'],
              service?.duration,
            );

        data['price'] =
            _numberOrFallback(
              data['price'],
              service?.price,
            );

        return AdminAppointmentModel.fromMap(
          doc.id,
          data,
        );
      }).toList();
    } catch (e, s) {
      _logError(
        'GET APPOINTMENTS',
        e,
        s,
      );
      rethrow;
    }
  }

  Stream<List<AdminAppointmentModel>> watchAppointments(
      String salonId,
      ) {
    final normalizedSalonId = salonId.trim();

    if (normalizedSalonId.isEmpty) {
      return Stream.error(
        ArgumentError(
          'salonId non può essere vuoto.',
        ),
      );
    }

    return _appointments
        .where(
      'salonId',
      isEqualTo: normalizedSalonId,
    )
        .orderBy('date')
        .snapshots()
        .asyncMap(
          (_) => getAppointments(
        normalizedSalonId,
      ),
    );
  }

  Stream<List<AdminAppointmentModel>> watchAppointmentsByDate({
    required String salonId,
    required DateTime date,
  }) {
    return watchAppointments(salonId).map(
          (appointments) => appointments.where(
            (appointment) {
          final appointmentDate =
              appointment.appointmentDate;

          return appointmentDate.year == date.year &&
              appointmentDate.month == date.month &&
              appointmentDate.day == date.day;
        },
      ).toList(),
    );
  }

  Future<List<AdminAppointmentModel>> getAppointmentsWithDetails(
      String salonId,
      ) {
    return getAppointments(salonId);
  }

  Future<List<AdminAppointmentModel>> getAppointmentsByDate({
    required String salonId,
    required DateTime date,
  }) async {
    final appointments = await getAppointments(
      salonId,
    );

    return appointments.where(
          (appointment) {
        final appointmentDate =
            appointment.appointmentDate;

        return appointmentDate.year == date.year &&
            appointmentDate.month == date.month &&
            appointmentDate.day == date.day;
      },
    ).toList();
  }

  // ==================================================
  // STATUS
  // ==================================================

  /// Aggiorna lo stato di un Appointment dal flusso Admin.
  ///
  /// L'operazione è atomica.
  ///
  /// In caso di annullamento:
  ///
  /// Appointment → Annullata
  /// appointment_slots → eliminati
  /// appointment_availability → eliminati
  ///
  /// Il salonId viene verificato contro il documento reale.
  Future<void> updateStatus(
      String salonId,
      String appointmentId,
      String status,
      ) async {
    final normalizedSalonId = salonId.trim();
    final normalizedAppointmentId =
    appointmentId.trim();
    final normalizedStatus = status.trim();

    _validateRequiredId(
      normalizedSalonId,
      'salonId',
    );

    _validateRequiredId(
      normalizedAppointmentId,
      'appointmentId',
    );

    _validateAppointmentStatus(
      normalizedStatus,
    );

    final appointmentRef =
    _appointments.doc(
      normalizedAppointmentId,
    );

    await _firestore.runTransaction<void>(
          (transaction) async {
        // ==================================================
        // READ
        // ==================================================

        final appointmentSnapshot =
        await transaction.get(
          appointmentRef,
        );

        if (!appointmentSnapshot.exists) {
          throw StateError(
            'L\'Appointment '
                '"$normalizedAppointmentId" '
                'non esiste.',
          );
        }

        final appointment =
        AppointmentModel.fromMap(
          appointmentSnapshot.id,
          appointmentSnapshot.data() ?? {},
        );

        _validateSalonOwnership(
          appointment,
          normalizedSalonId,
        );

        _validateAdminStatusTransition(
          currentStatus: appointment.status,
          newStatus: normalizedStatus,
        );

        // Per la cancellazione dobbiamo leggere tutti
        // gli slot prima di qualsiasi write.
        final oldSlotRefs =
        _buildSlotRefs(
          appointment,
        );

        final slotSnapshots =
        <String,
            DocumentSnapshot<Map<String, dynamic>>>{};

        for (final slotRef in oldSlotRefs) {
          slotSnapshots[slotRef.path] =
          await transaction.get(
            slotRef,
          );
        }

        // ==================================================
        // WRITE
        // ==================================================

        transaction.update(
          appointmentRef,
          {
            'status': normalizedStatus,
            'updatedAt': Timestamp.now(),
          },
        );

        if (normalizedStatus ==
            AppointmentStatus.cancelled) {
          for (final slotRef in oldSlotRefs) {
            final snapshot =
            slotSnapshots[slotRef.path]!;

            if (!snapshot.exists) {
              continue;
            }

            final data = snapshot.data();

            final ownerAppointmentId =
            data?['appointmentId']?.toString();

            if (ownerAppointmentId !=
                appointment.id) {
              throw StateError(
                'Lo slot "${slotRef.id}" '
                    'non appartiene all\'Appointment '
                    '"${appointment.id}".',
              );
            }

            transaction.delete(
              slotRef,
            );
          }
        }

        _availabilityRepository.syncInTransaction(
          oldAppointment: appointment,
          newAppointment: appointment.copyWith(
            status: normalizedStatus,
          ),
          transaction: transaction,
        );
      },
    );
  }

  // ==================================================
  // CAMBIO DIPENDENTE
  // ==================================================

  /// Cambia il dipendente di un Appointment dal flusso Admin.
  ///
  /// L'operazione è atomica:
  ///
  /// 1. verifica Appointment;
  /// 2. verifica salonId;
  /// 3. verifica stato;
  /// 4. verifica dipendente nel salone;
  /// 5. legge vecchi e nuovi slot;
  /// 6. controlla collisioni;
  /// 7. aggiorna Appointment;
  /// 8. rialloca appointment_slots;
  /// 9. rialloca appointment_availability.
  Future<void> updateEmployee({
    required String salonId,
    required String appointmentId,
    required String employeeId,
    required String employeeName,
    required String employeePhone,
    required String employeeSpecialization,
    required double employeeRating,
  }) async {
    final normalizedSalonId = salonId.trim();
    final normalizedAppointmentId =
    appointmentId.trim();
    final normalizedEmployeeId =
    employeeId.trim();

    _validateRequiredId(
      normalizedSalonId,
      'salonId',
    );

    _validateRequiredId(
      normalizedAppointmentId,
      'appointmentId',
    );

    _validateRequiredId(
      normalizedEmployeeId,
      'employeeId',
    );

    final appointmentRef =
    _appointments.doc(
      normalizedAppointmentId,
    );

    final employeeRef = _firestore
        .collection('salons')
        .doc(normalizedSalonId)
        .collection('employees')
        .doc(normalizedEmployeeId);

    await _firestore.runTransaction<void>(
          (transaction) async {
        // ==================================================
        // READ APPOINTMENT
        // ==================================================

        final appointmentSnapshot =
        await transaction.get(
          appointmentRef,
        );

        if (!appointmentSnapshot.exists) {
          throw StateError(
            'L\'Appointment '
                '"$normalizedAppointmentId" '
                'non esiste.',
          );
        }

        final appointment =
        AppointmentModel.fromMap(
          appointmentSnapshot.id,
          appointmentSnapshot.data() ?? {},
        );

        _validateSalonOwnership(
          appointment,
          normalizedSalonId,
        );

        if (appointment.isCompleted) {
          throw StateError(
            'Non è possibile cambiare il dipendente '
                'di un Appointment completato.',
          );
        }

        if (appointment.isCancelled) {
          throw StateError(
            'Non è possibile cambiare il dipendente '
                'di un Appointment annullato.',
          );
        }

        // ==================================================
        // READ EMPLOYEE
        // ==================================================

        final employeeSnapshot =
        await transaction.get(
          employeeRef,
        );

        if (!employeeSnapshot.exists) {
          throw StateError(
            'Il dipendente '
                '"$normalizedEmployeeId" '
                'non appartiene al salone '
                '"$normalizedSalonId".',
          );
        }

        final employee =
        EmployeeModel.fromMap(
          employeeSnapshot.id,
          employeeSnapshot.data() ?? {},
        );

        if (employee.id.trim() !=
            normalizedEmployeeId) {
          throw StateError(
            'Il dipendente selezionato '
                'non è valido.',
          );
        }

        // Se il dipendente è già quello corrente,
        // aggiorniamo comunque lo snapshot dei dati.
        final oldSlotRefs =
        _buildSlotRefs(
          appointment,
        );

        final updatedAppointment =
        appointment.copyWith(
          employeeId: normalizedEmployeeId,
          employeeName: employee.name,
          employeePhone: employee.phone,
          employeeSpecialization:
          employee.specialization,
          employeeRating: employee.rating,
          updatedAt: Timestamp.now(),
        );

        final newSlotRefs =
        _buildSlotRefs(
          updatedAppointment,
        );

        // ==================================================
        // READ SLOT
        // ==================================================

        final allSlotRefs =
        _uniqueSlotRefs([
          ...oldSlotRefs,
          ...newSlotRefs,
        ]);

        final slotSnapshots =
        <String,
            DocumentSnapshot<Map<String, dynamic>>>{};

        for (final slotRef in allSlotRefs) {
          slotSnapshots[slotRef.path] =
          await transaction.get(
            slotRef,
          );
        }

        // ==================================================
        // CONTROLLO NUOVI SLOT
        // ==================================================

        for (final slotRef in newSlotRefs) {
          final snapshot =
          slotSnapshots[slotRef.path]!;

          if (!snapshot.exists) {
            continue;
          }

          final data = snapshot.data();

          final ownerAppointmentId =
          data?['appointmentId']?.toString();

          if (ownerAppointmentId !=
              appointment.id) {
            throw StateError(
              'Il nuovo dipendente ha già '
                  'l\'orario richiesto occupato.',
            );
          }
        }

        // ==================================================
        // WRITE APPOINTMENT
        // ==================================================

        transaction.set(
          appointmentRef,
          updatedAppointment.toMap(),
        );

        // ==================================================
        // DELETE VECCHI SLOT
        // ==================================================

        final newSlotPaths =
        newSlotRefs
            .map(
              (ref) => ref.path,
        )
            .toSet();

        for (final oldSlotRef in oldSlotRefs) {
          if (newSlotPaths.contains(
            oldSlotRef.path,
          )) {
            continue;
          }

          final snapshot =
          slotSnapshots[oldSlotRef.path]!;

          if (!snapshot.exists) {
            continue;
          }

          final data = snapshot.data();

          final ownerAppointmentId =
          data?['appointmentId']?.toString();

          if (ownerAppointmentId !=
              appointment.id) {
            throw StateError(
              'Uno degli slot esistenti '
                  'non appartiene all\'Appointment '
                  '"${appointment.id}".',
            );
          }

          transaction.delete(
            oldSlotRef,
          );
        }

        // ==================================================
        // CREATE / UPDATE NUOVI SLOT
        // ==================================================

        final slotStarts =
        AppointmentSlotKey.buildSlots(
          start: updatedAppointment.appointmentDate,
          durationMinutes:
          updatedAppointment.duration,
        );

        final createdAt = Timestamp.now();

        for (var index = 0;
        index < newSlotRefs.length;
        index++) {
          final slotRef =
          newSlotRefs[index];

          final snapshot =
          slotSnapshots[slotRef.path]!;

          final existingData =
          snapshot.data();

          transaction.set(
            slotRef,
            {
              'appointmentId':
              updatedAppointment.id,
              'userId':
              updatedAppointment.userId,
              'salonId':
              updatedAppointment.salonId,
              'employeeId':
              updatedAppointment.employeeId,
              'start':
              Timestamp.fromDate(
                slotStarts[index],
              ),
              'createdAt':
              existingData?['createdAt'] ??
                  createdAt,
            },
          );
        }

        _availabilityRepository.syncInTransaction(
          oldAppointment: appointment,
          newAppointment: updatedAppointment,
          transaction: transaction,
        );
      },
    );
  }

  // ==================================================
  // DELETE
  // ==================================================

  /// Elimina un Appointment dal flusso Admin.
  ///
  /// Appointment, appointment_slots e
  /// appointment_availability vengono eliminati
  /// nella stessa Transaction.
  Future<void> deleteAppointment(
      String salonId,
      String appointmentId,
      ) async {
    final normalizedSalonId = salonId.trim();
    final normalizedAppointmentId =
    appointmentId.trim();

    _validateRequiredId(
      normalizedSalonId,
      'salonId',
    );

    _validateRequiredId(
      normalizedAppointmentId,
      'appointmentId',
    );

    final appointmentRef =
    _appointments.doc(
      normalizedAppointmentId,
    );

    await _firestore.runTransaction<void>(
          (transaction) async {
        // ==================================================
        // READ
        // ==================================================

        final appointmentSnapshot =
        await transaction.get(
          appointmentRef,
        );

        if (!appointmentSnapshot.exists) {
          throw StateError(
            'L\'Appointment '
                '"$normalizedAppointmentId" '
                'non esiste.',
          );
        }

        final appointment =
        AppointmentModel.fromMap(
          appointmentSnapshot.id,
          appointmentSnapshot.data() ?? {},
        );

        _validateSalonOwnership(
          appointment,
          normalizedSalonId,
        );

        final slotRefs =
        _buildSlotRefs(
          appointment,
        );

        final slotSnapshots =
        <String,
            DocumentSnapshot<Map<String, dynamic>>>{};

        for (final slotRef in slotRefs) {
          slotSnapshots[slotRef.path] =
          await transaction.get(
            slotRef,
          );
        }

        // ==================================================
        // VALIDAZIONE SLOT
        // ==================================================

        for (final slotRef in slotRefs) {
          final snapshot =
          slotSnapshots[slotRef.path]!;

          if (!snapshot.exists) {
            continue;
          }

          final data = snapshot.data();

          final ownerAppointmentId =
          data?['appointmentId']?.toString();

          if (ownerAppointmentId !=
              appointment.id) {
            throw StateError(
              'Uno degli slot associati '
                  'non appartiene all\'Appointment '
                  '"${appointment.id}".',
            );
          }
        }

        // ==================================================
        // WRITE
        // ==================================================

        transaction.delete(
          appointmentRef,
        );

        for (final slotRef in slotRefs) {
          final snapshot =
          slotSnapshots[slotRef.path]!;

          if (snapshot.exists) {
            transaction.delete(
              slotRef,
            );
          }
        }

        _availabilityRepository.syncInTransaction(
          oldAppointment: appointment,
          newAppointment: null,
          transaction: transaction,
        );
      },
    );
  }

  // ==================================================
  // SLOT HELPERS
  // ==================================================

  List<DocumentReference<Map<String, dynamic>>>
  _buildSlotRefs(
      AppointmentModel appointment,
      ) {
    final slotStarts =
    AppointmentSlotKey.buildSlots(
      start: appointment.appointmentDate,
      durationMinutes: appointment.duration,
    );

    if (slotStarts.isEmpty) {
      throw StateError(
        'Nessuno slot disponibile '
            'per l\'Appointment.',
      );
    }

    return slotStarts.map(
          (slotStart) {
        final slotId =
        AppointmentSlotKey.build(
          salonId: appointment.salonId,
          employeeId: appointment.employeeId,
          start: slotStart,
        );

        return _appointmentSlots.doc(
          slotId,
        );
      },
    ).toList();
  }

  List<DocumentReference<Map<String, dynamic>>>
  _uniqueSlotRefs(
      Iterable<
          DocumentReference<Map<String, dynamic>>>
      refs,
      ) {
    final result =
    <DocumentReference<Map<String, dynamic>>>[];

    final seen = <String>{};

    for (final ref in refs) {
      if (seen.add(ref.path)) {
        result.add(ref);
      }
    }

    return result;
  }

  // ==================================================
  // VALIDAZIONI
  // ==================================================

  void _validateRequiredId(
      String value,
      String fieldName,
      ) {
    if (value.isEmpty) {
      throw ArgumentError(
        '$fieldName non può essere vuoto.',
      );
    }
  }

  void _validateSalonOwnership(
      AppointmentModel appointment,
      String salonId,
      ) {
    if (appointment.salonId.trim() !=
        salonId.trim()) {
      throw StateError(
        'L\'Appointment "${appointment.id}" '
            'non appartiene al salone "$salonId".',
      );
    }
  }

  void _validateAppointmentStatus(
      String status,
      ) {
    if (!AppointmentStatus.isKnown(status)) {
      throw ArgumentError(
        'Stato Appointment non valido: "$status".',
      );
    }
  }

  void _validateAdminStatusTransition({
    required String currentStatus,
    required String newStatus,
  }) {
    final current =
    _normalizeStatus(currentStatus);

    final next =
    _normalizeStatus(newStatus);

    if (current == next) {
      throw StateError(
        'L\'Appointment è già nello stato '
            '"$newStatus".',
      );
    }

    switch (current) {
      case 'prenotata':
        if (next == 'confermata' ||
            next == 'annullata') {
          return;
        }
        break;

      case 'confermata':
        if (next == 'completata' ||
            next == 'annullata') {
          return;
        }
        break;

      case 'completata':
        break;

      case 'annullata':
        break;
    }

    throw StateError(
      'Transizione stato non consentita: '
          '"$currentStatus" → "$newStatus".',
    );
  }

  String _normalizeStatus(String status) {
    return status.trim().toLowerCase();
  }

  // ==================================================
  // SNAPSHOT HELPERS
  // ==================================================

  String _stringOrFallback(
      dynamic current,
      dynamic fallback,
      ) {
    final currentValue =
        current?.toString().trim() ?? '';

    if (currentValue.isNotEmpty) {
      return currentValue;
    }

    return fallback?.toString() ?? '';
  }

  num _numberOrFallback(
      dynamic current,
      dynamic fallback,
      ) {
    if (current is num) {
      return current;
    }

    final parsedCurrent =
    num.tryParse(
      current?.toString().replaceAll(',', '.') ?? '',
    );

    if (parsedCurrent != null) {
      return parsedCurrent;
    }

    if (fallback is num) {
      return fallback;
    }

    return num.tryParse(
      fallback
          ?.toString()
          .replaceAll(',', '.') ??
          '',
    ) ??
        0;
  }

  // ==================================================
  // LOG
  // ==================================================

  void _logError(
      String action,
      Object error,
      StackTrace stack,
      ) {
    debugPrint(
      '$action ERROR: $error',
    );

    debugPrintStack(
      stackTrace: stack,
    );
  }
}
