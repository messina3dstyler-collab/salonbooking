import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/employee_calendar_model.dart';

class EmployeeCalendarRepository {
  EmployeeCalendarRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _calendar =>
      _firestore.collection('employee_calendar');

  List<EmployeeCalendarModel> _map(
      QuerySnapshot<Map<String, dynamic>> snap,
      ) {
    return snap.docs
        .map(
          (doc) => EmployeeCalendarModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }

  Future<List<EmployeeCalendarModel>> getEventsByEmployeeAndDate({
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

    final snap = await _calendar
        .where(
      'employeeId',
      isEqualTo: employeeId,
    )
        .where(
      'start',
      isLessThan: end,
    )
        .where(
      'end',
      isGreaterThanOrEqualTo: start,
    )
        .orderBy('start')
        .get();

    return _map(snap);
  }

  Future<List<EmployeeCalendarModel>> getEventsByEmployee({
    required String employeeId,
  }) async {
    final snap = await _calendar
        .where(
      'employeeId',
      isEqualTo: employeeId,
    )
        .orderBy(
      'start',
    )
        .get();

    return _map(snap);
  }

  Stream<List<EmployeeCalendarModel>> watchEventsByEmployee({
    required String employeeId,
  }) {
    return _calendar
        .where(
      'employeeId',
      isEqualTo: employeeId,
    )
        .orderBy(
      'start',
    )
        .snapshots()
        .map(_map);
  }

  Future<EmployeeCalendarModel?> getEvent({
    required String eventId,
  }) async {
    final doc = await _calendar.doc(eventId).get();

    if (!doc.exists) {
      return null;
    }

    return EmployeeCalendarModel.fromMap(
      doc.id,
      doc.data()!,
    );
  }

  Future<void> createEvent({
    required EmployeeCalendarModel event,
  }) {
    return _calendar.doc(event.id).set(event.toMap());
  }

  Future<void> updateEvent({
    required EmployeeCalendarModel event,
  }) {
    return _calendar.doc(event.id).update(event.toMap());
  }

  Future<void> deleteEvent({
    required String eventId,
  }) {
    return _calendar.doc(eventId).delete();
  }
}