import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';
import '../models/appointment_slot_key.dart';

class AppointmentRepository {
  AppointmentRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection('appointments');

  CollectionReference<Map<String, dynamic>> get _appointmentSlots =>
      _firestore.collection('appointment_slots');

  DocumentReference<Map<String, dynamic>> appointmentDocument(
      String appointmentId,
      ) {
    _validateId(
      appointmentId,
      fieldName: 'appointmentId',
    );

    return _appointments.doc(appointmentId);
  }

  AppointmentModel _map(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    return AppointmentModel.fromMap(
      doc.id,
      doc.data() ?? {},
    );
  }

  List<AppointmentModel> _list(
      QuerySnapshot<Map<String, dynamic>> snap,
      ) {
    return snap.docs.map(_map).toList();
  }

  // ==================================================
  // SLOT
  // ==================================================

  /// Costruisce i riferimenti Firestore di tutti gli slot
  /// occupati da un Appointment.
  ///
  /// La granularità è quella definita da AppointmentSlotKey.
  List<DocumentReference<Map<String, dynamic>>> _buildSlotRefs(
      AppointmentModel appointment,
      ) {
    final slotStarts = AppointmentSlotKey.buildSlots(
      start: appointment.appointmentDate,
      durationMinutes: appointment.duration,
    );

    if (slotStarts.isEmpty) {
      throw StateError(
        'Nessuno slot disponibile per l\'Appointment.',
      );
    }

    return slotStarts.map((slotStart) {
      final slotId = AppointmentSlotKey.build(
        salonId: appointment.salonId,
        employeeId: appointment.employeeId,
        start: slotStart,
      );

      return _appointmentSlots.doc(slotId);
    }).toList();
  }

  /// Rimuove eventuali riferimenti duplicati mantenendo
  /// l'ordine originale.
  List<DocumentReference<Map<String, dynamic>>> _uniqueSlotRefs(
      Iterable<DocumentReference<Map<String, dynamic>>> refs,
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
  // CREAZIONE ATOMICA
  // ==================================================

  /// Crea un Appointment e riserva atomicamente tutti gli slot
  /// temporali occupati dal servizio.
  ///
  /// La prenotazione viene considerata riuscita solo se:
  ///
  /// 1. l'Appointment non esiste già;
  /// 2. tutti gli slot necessari sono liberi;
  /// 3. tutti i documenti degli slot vengono creati;
  /// 4. l'Appointment viene creato nella stessa transazione.
  ///
  /// Se anche un solo slot è già occupato, l'intera operazione
  /// fallisce e non viene creato alcun Appointment.
  Future<void> createAppointmentAtomically({
    required AppointmentModel appointment,
  }) async {
    _validateAppointment(appointment);

    final appointmentRef = appointmentDocument(
      appointment.id,
    );

    final slotRefs = _buildSlotRefs(appointment);

    await _firestore.runTransaction<void>(
          (transaction) async {
        // ==================================================
        // READ
        // ==================================================

        final appointmentSnapshot =
        await transaction.get(appointmentRef);

        if (appointmentSnapshot.exists) {
          throw StateError(
            'L\'Appointment "${appointment.id}" esiste già.',
          );
        }

        for (final slotRef in slotRefs) {
          final snapshot =
          await transaction.get(slotRef);

          if (snapshot.exists) {
            throw StateError(
              'L\'orario richiesto non è più disponibile.',
            );
          }
        }

        // ==================================================
        // WRITE
        // ==================================================

        transaction.set(
          appointmentRef,
          appointment.toMap(),
        );

        final createdAt = Timestamp.now();

        final slotStarts = AppointmentSlotKey.buildSlots(
          start: appointment.appointmentDate,
          durationMinutes: appointment.duration,
        );

        for (var index = 0;
        index < slotRefs.length;
        index++) {
          final slotStart = slotStarts[index];
          final slotRef = slotRefs[index];

          transaction.set(
            slotRef,
            {
              'appointmentId': appointment.id,
              'userId': appointment.userId,
              'salonId': appointment.salonId,
              'employeeId': appointment.employeeId,
              'start': Timestamp.fromDate(slotStart),
              'createdAt': createdAt,
            },
          );
        }
      },
    );
  }

  // ==================================================
  // AGGIORNAMENTO ATOMICO
  // ==================================================

  /// Aggiorna atomicamente un Appointment e la relativa
  /// prenotazione degli slot.
  ///
  /// Questa versione apre una nuova Firestore Transaction.
  Future<void> updateAppointmentAtomically({
    required AppointmentModel appointment,
  }) async {
    _validateAppointment(appointment);

    final appointmentRef = appointmentDocument(
      appointment.id,
    );

    await _firestore.runTransaction<void>(
          (transaction) async {
        await _updateAppointmentAtomicallyInTransaction(
          appointment: appointment,
          transaction: transaction,
          appointmentRef: appointmentRef,
        );
      },
    );
  }

  /// Aggiorna atomicamente un Appointment utilizzando una
  /// Transaction già aperta dal chiamante.
  ///
  /// Questo metodo è pensato per i workflow composti, come:
  ///
  /// Request → Appointment → Timeline
  ///
  /// Non apre una nuova Transaction.
  ///
  /// La patch viene applicata al documento corrente e gli
  /// appointment_slots vengono riallocati in base al nuovo
  /// Appointment risultante.
  Future<void> patchAppointmentAtomically({
    required String appointmentId,
    required Map<String, dynamic> changes,
    required Transaction transaction,
  }) async {
    _validateId(
      appointmentId,
      fieldName: 'appointmentId',
    );

    if (changes.isEmpty) {
      throw ArgumentError(
        'Non è possibile eseguire una patch vuota '
            'su un Appointment.',
      );
    }

    final appointmentRef = appointmentDocument(
      appointmentId,
    );

    await _updateAppointmentPatchInTransaction(
      appointmentId: appointmentId,
      appointmentRef: appointmentRef,
      changes: changes,
      transaction: transaction,
    );
  }

  /// Implementazione comune dell'aggiornamento atomico completo.
  ///
  /// Tutte le letture vengono eseguite prima delle scritture.
  Future<void> _updateAppointmentAtomicallyInTransaction({
    required AppointmentModel appointment,
    required Transaction transaction,
    required DocumentReference<Map<String, dynamic>> appointmentRef,
  }) async {
    // ==================================================
    // READ APPOINTMENT
    // ==================================================

    final appointmentSnapshot =
    await transaction.get(appointmentRef);

    if (!appointmentSnapshot.exists) {
      throw StateError(
        'L\'Appointment "${appointment.id}" non esiste.',
      );
    }

    final currentAppointment =
    _map(appointmentSnapshot);

    // ==================================================
    // VALIDAZIONE IDENTITÀ
    // ==================================================

    if (currentAppointment.userId != appointment.userId) {
      throw StateError(
        'Non è possibile cambiare il proprietario '
            'di un Appointment.',
      );
    }

    if (currentAppointment.salonId != appointment.salonId) {
      throw StateError(
        'Non è possibile cambiare il salone '
            'di un Appointment.',
      );
    }

    // ==================================================
    // VECCHI SLOT
    // ==================================================

    final oldSlotRefs = _uniqueSlotRefs(
      _buildSlotRefs(currentAppointment),
    );

    // ==================================================
    // NUOVI SLOT
    // ==================================================

    final isCancelled =
        appointment.status == AppointmentStatus.cancelled;

    final newSlotRefs = isCancelled
        ? <DocumentReference<Map<String, dynamic>>>[]
        : _uniqueSlotRefs(
      _buildSlotRefs(appointment),
    );

    // ==================================================
    // READ SLOT
    // ==================================================

    final allSlotRefs = _uniqueSlotRefs([
      ...oldSlotRefs,
      ...newSlotRefs,
    ]);

    final slotSnapshots =
    <String, DocumentSnapshot<Map<String, dynamic>>>{};

    for (final slotRef in allSlotRefs) {
      slotSnapshots[slotRef.path] =
      await transaction.get(slotRef);
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
      data?['appointmentId'];

      if (ownerAppointmentId != appointment.id) {
        throw StateError(
          'Uno degli orari richiesti '
              'non è più disponibile.',
        );
      }
    }

    // ==================================================
    // WRITE APPOINTMENT
    // ==================================================

    transaction.set(
      appointmentRef,
      appointment.toMap(),
    );

    // ==================================================
    // DELETE VECCHI SLOT
    // ==================================================

    final newSlotPaths =
    newSlotRefs.map((ref) => ref.path).toSet();

    for (final oldSlotRef in oldSlotRefs) {
      if (!newSlotPaths.contains(oldSlotRef.path)) {
        transaction.delete(oldSlotRef);
      }
    }

    // ==================================================
    // CREATE / UPDATE NUOVI SLOT
    // ==================================================

    if (!isCancelled) {
      final slotStarts =
      AppointmentSlotKey.buildSlots(
        start: appointment.appointmentDate,
        durationMinutes: appointment.duration,
      );

      final createdAt = Timestamp.now();

      for (var index = 0;
      index < newSlotRefs.length;
      index++) {
        final slotRef = newSlotRefs[index];

        final snapshot =
        slotSnapshots[slotRef.path]!;

        if (snapshot.exists) {
          final data = snapshot.data();

          final ownerAppointmentId =
          data?['appointmentId'];

          if (ownerAppointmentId == appointment.id) {
            transaction.set(
              slotRef,
              {
                'appointmentId': appointment.id,
                'userId': appointment.userId,
                'salonId': appointment.salonId,
                'employeeId': appointment.employeeId,
                'start': Timestamp.fromDate(
                  slotStarts[index],
                ),
                'createdAt':
                data?['createdAt'] ??
                    createdAt,
              },
            );

            continue;
          }
        }

        transaction.set(
          slotRef,
          {
            'appointmentId': appointment.id,
            'userId': appointment.userId,
            'salonId': appointment.salonId,
            'employeeId': appointment.employeeId,
            'start': Timestamp.fromDate(
              slotStarts[index],
            ),
            'createdAt': createdAt,
          },
        );
      }
    }
  }

  /// Applica una patch all'interno di una Transaction già aperta,
  /// ricostruendo l'Appointment risultante e riallocando gli slot.
  ///
  /// Questo è il punto di integrazione utilizzato dal workflow
  /// Request → Appointment.
  Future<void> _updateAppointmentPatchInTransaction({
    required String appointmentId,
    required DocumentReference<Map<String, dynamic>> appointmentRef,
    required Map<String, dynamic> changes,
    required Transaction transaction,
  }) async {
    // ==================================================
    // READ APPOINTMENT
    // ==================================================

    final appointmentSnapshot =
    await transaction.get(appointmentRef);

    if (!appointmentSnapshot.exists) {
      throw StateError(
        'L\'Appointment "$appointmentId" non esiste.',
      );
    }

    final currentAppointment =
    _map(appointmentSnapshot);

    // ==================================================
    // BUILD UPDATED APPOINTMENT
    // ==================================================

    final updatedData = <String, dynamic>{
      ...appointmentSnapshot.data() ?? <String, dynamic>{},
      ...changes,
      'updatedAt': Timestamp.now(),
    };

    final updatedAppointment =
    AppointmentModel.fromMap(
      appointmentSnapshot.id,
      updatedData,
    );

    _validateAppointment(updatedAppointment);

    // ==================================================
    // IMMUTABLE IDENTITY
    // ==================================================

    if (currentAppointment.userId !=
        updatedAppointment.userId) {
      throw StateError(
        'Non è possibile cambiare il proprietario '
            'di un Appointment.',
      );
    }

    if (currentAppointment.salonId !=
        updatedAppointment.salonId) {
      throw StateError(
        'Non è possibile cambiare il salone '
            'di un Appointment.',
      );
    }

    // ==================================================
    // VECCHI SLOT
    // ==================================================

    final oldSlotRefs = _uniqueSlotRefs(
      _buildSlotRefs(currentAppointment),
    );

    // ==================================================
    // NUOVI SLOT
    // ==================================================

    final isCancelled =
        updatedAppointment.status ==
            AppointmentStatus.cancelled;

    final newSlotRefs = isCancelled
        ? <DocumentReference<Map<String, dynamic>>>[]
        : _uniqueSlotRefs(
      _buildSlotRefs(updatedAppointment),
    );

    // ==================================================
    // READ SLOT
    // ==================================================

    final allSlotRefs = _uniqueSlotRefs([
      ...oldSlotRefs,
      ...newSlotRefs,
    ]);

    final slotSnapshots =
    <String, DocumentSnapshot<Map<String, dynamic>>>{};

    for (final slotRef in allSlotRefs) {
      slotSnapshots[slotRef.path] =
      await transaction.get(slotRef);
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
      data?['appointmentId'];

      if (ownerAppointmentId != appointmentId) {
        throw StateError(
          'Uno degli orari richiesti '
              'non è più disponibile.',
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
    newSlotRefs.map((ref) => ref.path).toSet();

    for (final oldSlotRef in oldSlotRefs) {
      if (!newSlotPaths.contains(oldSlotRef.path)) {
        transaction.delete(oldSlotRef);
      }
    }

    // ==================================================
    // CREATE / UPDATE NUOVI SLOT
    // ==================================================

    if (!isCancelled) {
      final slotStarts =
      AppointmentSlotKey.buildSlots(
        start: updatedAppointment.appointmentDate,
        durationMinutes: updatedAppointment.duration,
      );

      final createdAt = Timestamp.now();

      for (var index = 0;
      index < newSlotRefs.length;
      index++) {
        final slotRef = newSlotRefs[index];

        final snapshot =
        slotSnapshots[slotRef.path]!;

        if (snapshot.exists) {
          final data = snapshot.data();

          final ownerAppointmentId =
          data?['appointmentId'];

          if (ownerAppointmentId == appointmentId) {
            transaction.set(
              slotRef,
              {
                'appointmentId': appointmentId,
                'userId': updatedAppointment.userId,
                'salonId': updatedAppointment.salonId,
                'employeeId':
                updatedAppointment.employeeId,
                'start': Timestamp.fromDate(
                  slotStarts[index],
                ),
                'createdAt':
                data?['createdAt'] ??
                    createdAt,
              },
            );

            continue;
          }
        }

        transaction.set(
          slotRef,
          {
            'appointmentId': appointmentId,
            'userId': updatedAppointment.userId,
            'salonId': updatedAppointment.salonId,
            'employeeId': updatedAppointment.employeeId,
            'start': Timestamp.fromDate(
              slotStarts[index],
            ),
            'createdAt': createdAt,
          },
        );
      }
    }
  }

  // ==================================================
  // CRUD
  // ==================================================

  Future<void> createAppointment({
    required AppointmentModel appointment,
  }) {
    _validateAppointment(appointment);

    return _appointments.doc(appointment.id).set(
      appointment.toMap(),
    );
  }

  Future<void> updateAppointment({
    required AppointmentModel appointment,
  }) {
    _validateAppointment(appointment);

    return _appointments.doc(appointment.id).set(
      appointment.toMap(),
    );
  }

  /// Aggiorna parzialmente un Appointment.
  ///
  /// Se viene fornita una Transaction, la patch viene inserita
  /// nella transaction chiamante.
  Future<void> patchAppointment({
    required String appointmentId,
    required Map<String, dynamic> changes,
    Transaction? transaction,
  }) async {
    _validateId(
      appointmentId,
      fieldName: 'appointmentId',
    );

    if (changes.isEmpty) {
      throw ArgumentError(
        'Non è possibile eseguire una patch vuota '
            'su un Appointment.',
      );
    }

    final data = <String, dynamic>{
      ...changes,
      'updatedAt': Timestamp.now(),
    };

    if (transaction != null) {
      transaction.update(
        appointmentDocument(appointmentId),
        data,
      );
      return;
    }

    await appointmentDocument(appointmentId).update(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> loadAppointment({
    required String appointmentId,
    Transaction? transaction,
  }) {
    _validateId(
      appointmentId,
      fieldName: 'appointmentId',
    );

    if (transaction != null) {
      return transaction.get(
        appointmentDocument(appointmentId),
      );
    }

    return appointmentDocument(appointmentId).get();
  }

  /// Elimina un Appointment e tutti i relativi slot
  /// nella stessa Transaction.
  ///
  /// Questo evita di lasciare reservation orfane in
  /// `appointment_slots`.
  Future<void> deleteAppointment({
    required String appointmentId,
    Transaction? transaction,
  }) async {
    _validateId(
      appointmentId,
      fieldName: 'appointmentId',
    );

    final appointmentRef = appointmentDocument(
      appointmentId,
    );

    if (transaction != null) {
      final appointmentSnapshot =
      await transaction.get(appointmentRef);

      if (!appointmentSnapshot.exists) {
        return;
      }

      final appointment =
      _map(appointmentSnapshot);

      final slotRefs =
      _buildSlotRefs(appointment);

      // Tutte le letture devono precedere le scritture.
      for (final slotRef in slotRefs) {
        await transaction.get(slotRef);
      }

      transaction.delete(appointmentRef);

      for (final slotRef in slotRefs) {
        transaction.delete(slotRef);
      }

      return;
    }

    await _firestore.runTransaction<void>(
          (transaction) async {
        final appointmentSnapshot =
        await transaction.get(appointmentRef);

        if (!appointmentSnapshot.exists) {
          return;
        }

        final appointment =
        _map(appointmentSnapshot);

        final slotRefs =
        _buildSlotRefs(appointment);

        // ==================================================
        // READ
        // ==================================================

        for (final slotRef in slotRefs) {
          await transaction.get(slotRef);
        }

        // ==================================================
        // WRITE
        // ==================================================

        transaction.delete(appointmentRef);

        for (final slotRef in slotRefs) {
          transaction.delete(slotRef);
        }
      },
    );
  }

  Future<AppointmentModel?> getAppointment({
    required String appointmentId,
  }) async {
    _validateId(
      appointmentId,
      fieldName: 'appointmentId',
    );

    final doc = await appointmentDocument(
      appointmentId,
    ).get();

    if (!doc.exists) {
      return null;
    }

    return _map(doc);
  }

  // ==================================================
  // CLIENTE
  // ==================================================

  Future<List<AppointmentModel>> getAppointmentsByUser({
    required String userId,
  }) async {
    _validateId(
      userId,
      fieldName: 'userId',
    );

    final snap = await _appointments
        .where(
      'userId',
      isEqualTo: userId,
    )
        .orderBy(
      'date',
      descending: true,
    )
        .get();

    return _list(snap);
  }

  Stream<List<AppointmentModel>> watchAppointmentsByUser({
    required String userId,
  }) {
    _validateId(
      userId,
      fieldName: 'userId',
    );

    return _appointments
        .where(
      'userId',
      isEqualTo: userId,
    )
        .orderBy(
      'date',
      descending: true,
    )
        .snapshots()
        .map(_list);
  }

  // ==================================================
  // SALONE
  // ==================================================

  Future<List<AppointmentModel>> getAppointmentsBySalon({
    required String salonId,
  }) async {
    _validateId(
      salonId,
      fieldName: 'salonId',
    );

    final snap = await _appointments
        .where(
      'salonId',
      isEqualTo: salonId,
    )
        .orderBy(
      'date',
      descending: true,
    )
        .get();

    return _list(snap);
  }

  Stream<List<AppointmentModel>> watchAppointmentsBySalon({
    required String salonId,
  }) {
    _validateId(
      salonId,
      fieldName: 'salonId',
    );

    return _appointments
        .where(
      'salonId',
      isEqualTo: salonId,
    )
        .orderBy(
      'date',
      descending: true,
    )
        .snapshots()
        .map(_list);
  }

  // ==================================================
  // DIPENDENTE
  // ==================================================

  Future<List<AppointmentModel>> getAppointmentsByEmployee({
    required String employeeId,
  }) async {
    _validateId(
      employeeId,
      fieldName: 'employeeId',
    );

    final snap = await _appointments
        .where(
      'employeeId',
      isEqualTo: employeeId,
    )
        .orderBy(
      'date',
      descending: true,
    )
        .get();

    return _list(snap);
  }

  // ==================================================
  // DIPENDENTE + DATA
  // ==================================================

  Future<List<AppointmentModel>> getEmployeeAppointmentsByDate({
    required String employeeId,
    required DateTime date,
  }) async {
    _validateId(
      employeeId,
      fieldName: 'employeeId',
    );

    final start = _startOfDay(date);
    final end = _startOfNextDay(date);

    final snap = await _appointments
        .where(
      'employeeId',
      isEqualTo: employeeId,
    )
        .where(
      'date',
      isGreaterThanOrEqualTo: start,
    )
        .where(
      'date',
      isLessThan: end,
    )
        .orderBy('date')
        .get();

    return _list(snap);
  }

  // ==================================================
  // COMPLETATE CLIENTE
  // ==================================================

  Future<List<AppointmentModel>>
  getCompletedAppointmentsByUser({
    required String userId,
  }) async {
    _validateId(
      userId,
      fieldName: 'userId',
    );

    final snap = await _appointments
        .where(
      'userId',
      isEqualTo: userId,
    )
        .where(
      'status',
      isEqualTo: AppointmentStatus.completed,
    )
        .orderBy(
      'date',
      descending: true,
    )
        .get();

    return _list(snap);
  }

  // ==================================================
  // STATUS
  // ==================================================

  /// Aggiorna lo stato dell'Appointment.
  ///
  /// Quando lo stato diventa `Annullata`, viene utilizzato
  /// il flusso atomico di cancellazione, che aggiorna lo stato
  /// e libera gli slot nella stessa Transaction.
  Future<void> updateStatus({
    required String appointmentId,
    required String status,
  }) {
    _validateId(
      appointmentId,
      fieldName: 'appointmentId',
    );

    _validateStatus(status);

    if (status == AppointmentStatus.cancelled) {
      return cancelAppointment(
        appointmentId: appointmentId,
      );
    }

    return appointmentDocument(appointmentId).update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  /// Cancella atomicamente un Appointment.
  ///
  /// L'Appointment viene impostato come `Annullata` e tutti
  /// gli slot precedentemente riservati vengono eliminati
  /// nella stessa Transaction.
  Future<void> cancelAppointment({
    required String appointmentId,
  }) async {
    _validateId(
      appointmentId,
      fieldName: 'appointmentId',
    );

    final appointmentRef = appointmentDocument(
      appointmentId,
    );

    await _firestore.runTransaction<void>(
          (transaction) async {
        // ==================================================
        // READ
        // ==================================================

        final appointmentSnapshot =
        await transaction.get(appointmentRef);

        if (!appointmentSnapshot.exists) {
          throw StateError(
            'L\'Appointment "$appointmentId" non esiste.',
          );
        }

        final appointment =
        _map(appointmentSnapshot);

        final slotRefs =
        _buildSlotRefs(appointment);

        // Tutte le letture devono essere completate
        // prima delle scritture.
        for (final slotRef in slotRefs) {
          await transaction.get(slotRef);
        }

        // ==================================================
        // WRITE
        // ==================================================

        transaction.update(
          appointmentRef,
          {
            'status': AppointmentStatus.cancelled,
            'updatedAt': Timestamp.now(),
          },
        );

        for (final slotRef in slotRefs) {
          transaction.delete(slotRef);
        }
      },
    );
  }

  // ==================================================
  // SALONE + DATA
  // ==================================================

  Future<List<AppointmentModel>>
  getAppointmentsBySalonAndDate({
    required String salonId,
    required DateTime date,
  }) async {
    _validateId(
      salonId,
      fieldName: 'salonId',
    );

    final start = _startOfDay(date);
    final end = _startOfNextDay(date);

    final snap = await _appointments
        .where(
      'salonId',
      isEqualTo: salonId,
    )
        .where(
      'date',
      isGreaterThanOrEqualTo: start,
    )
        .where(
      'date',
      isLessThan: end,
    )
        .orderBy('date')
        .get();

    return _list(snap);
  }

  // ==================================================
  // CLIENTE + DATA
  // ==================================================

  Future<List<AppointmentModel>>
  getAppointmentsByUserAndDate({
    required String userId,
    required DateTime date,
  }) async {
    _validateId(
      userId,
      fieldName: 'userId',
    );

    final start = _startOfDay(date);
    final end = _startOfNextDay(date);

    final snap = await _appointments
        .where(
      'userId',
      isEqualTo: userId,
    )
        .where(
      'date',
      isGreaterThanOrEqualTo: start,
    )
        .where(
      'date',
      isLessThan: end,
    )
        .orderBy('date')
        .get();

    return _list(snap);
  }

  // ==================================================
  // VALIDAZIONE
  // ==================================================

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

  static void _validateAppointment(
      AppointmentModel appointment,
      ) {
    _validateId(
      appointment.id,
      fieldName: 'appointmentId',
    );

    _validateId(
      appointment.userId,
      fieldName: 'userId',
    );

    _validateId(
      appointment.salonId,
      fieldName: 'salonId',
    );

    _validateId(
      appointment.employeeId,
      fieldName: 'employeeId',
    );

    _validateId(
      appointment.serviceId,
      fieldName: 'serviceId',
    );

    if (appointment.duration <= 0) {
      throw ArgumentError(
        'La durata dell\'Appointment deve essere '
            'maggiore di zero.',
      );
    }

    if (!appointment.hasValidSchedule) {
      throw ArgumentError(
        'La pianificazione dell\'Appointment '
            'non è valida.',
      );
    }

    _validateStatus(appointment.status);
  }

  static void _validateStatus(String status) {
    if (!AppointmentStatus.isKnown(status)) {
      throw ArgumentError(
        "Stato Appointment non riconosciuto: '$status'.",
      );
    }
  }

  // ==================================================
  // DATE
  // ==================================================

  static Timestamp _startOfDay(DateTime date) {
    return Timestamp.fromDate(
      DateTime(
        date.year,
        date.month,
        date.day,
      ),
    );
  }

  static Timestamp _startOfNextDay(DateTime date) {
    return Timestamp.fromDate(
      DateTime(
        date.year,
        date.month,
        date.day + 1,
      ),
    );
  }
}