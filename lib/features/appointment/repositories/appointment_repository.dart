import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_model.dart';

class AppointmentRepository {
  AppointmentRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection('appointments');

  DocumentReference<Map<String, dynamic>> appointmentDocument(
      String appointmentId,
      ) {
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
  // CRUD
  // ==================================================

  Future<void> createAppointment({
    required AppointmentModel appointment,
  }) {
    return _appointments.doc(appointment.id).set(
      appointment.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<void> updateAppointment({
    required AppointmentModel appointment,
  }) {
    return _appointments.doc(appointment.id).set(
      appointment.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<void> patchAppointment({
    required String appointmentId,
    required Map<String, dynamic> changes,
    Transaction? transaction,
  }) async {
    final data = {
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
    if (transaction != null) {
      return transaction.get(
        appointmentDocument(appointmentId),
      );
    }

    return appointmentDocument(appointmentId).get();
  }

  Future<void> deleteAppointment({
    required String appointmentId,
    Transaction? transaction,
  }) async {
    if (transaction != null) {
      transaction.delete(
        appointmentDocument(appointmentId),
      );
      return;
    }

    await appointmentDocument(appointmentId).delete();
  }

  Future<AppointmentModel?> getAppointment({
    required String appointmentId,
  }) async {
    final doc = await _appointments.doc(appointmentId).get();

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
    final start = Timestamp.fromDate(
      DateTime(
        date.year,
        date.month,
        date.day,
      ),
    );

    final end = Timestamp.fromDate(
      DateTime(
        date.year,
        date.month,
        date.day + 1,
      ),
    );

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

  Future<List<AppointmentModel>> getCompletedAppointmentsByUser({
    required String userId,
  }) async {
    final snap = await _appointments
        .where(
      'userId',
      isEqualTo: userId,
    )
        .where(
      'status',
      isEqualTo: 'Completata',
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

  Future<void> updateStatus({
    required String appointmentId,
    required String status,
  }) {
    return _appointments.doc(appointmentId).update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> cancelAppointment({
    required String appointmentId,
  }) {
    return updateStatus(
      appointmentId: appointmentId,
      status: 'Annullata',
    );
  }

  // ==================================================
  // SALONE + DATA
  // ==================================================

  Future<List<AppointmentModel>> getAppointmentsBySalonAndDate({
    required String salonId,
    required DateTime date,
  }) async {
    final start = Timestamp.fromDate(
      DateTime(
        date.year,
        date.month,
        date.day,
      ),
    );

    final end = Timestamp.fromDate(
      DateTime(
        date.year,
        date.month,
        date.day + 1,
      ),
    );

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

  Future<List<AppointmentModel>> getAppointmentsByUserAndDate({
    required String userId,
    required DateTime date,
  }) async {
    final start = Timestamp.fromDate(
      DateTime(
        date.year,
        date.month,
        date.day,
      ),
    );

    final end = Timestamp.fromDate(
      DateTime(
        date.year,
        date.month,
        date.day + 1,
      ),
    );

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
}