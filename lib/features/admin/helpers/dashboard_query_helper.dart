import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../appointment/models/appointment_model.dart';
import '../../employee/models/employee_model.dart';

import '../models/dashboard_snapshot.dart';

class DashboardQueryHelper {
  DashboardQueryHelper({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection('appointments');

  CollectionReference<Map<String, dynamic>> _employees(
      String salonId,
      ) {
    return _firestore
        .collection('salons')
        .doc(salonId)
        .collection('employees');
  }

  Future<DashboardSnapshot> loadDashboardSnapshot({
    required String salonId,
  }) async {
    final todayAppointments = await loadTodayAppointments(
      salonId: salonId,
    );

    final allAppointments = await loadAllAppointments(
      salonId: salonId,
    );

    final employees = await loadEmployees(
      salonId: salonId,
    );

    return DashboardSnapshot(
      todayAppointments: todayAppointments,
      allAppointments: allAppointments,
      employees: employees,
    );
  }

  Stream<DashboardSnapshot> watchDashboardSnapshot({
    required String salonId,
  }) {
    late final StreamController<DashboardSnapshot> controller;

    StreamSubscription<List<AppointmentModel>>? appointmentsSubscription;
    StreamSubscription<List<EmployeeModel>>? employeesSubscription;

    List<AppointmentModel>? allAppointments;
    List<EmployeeModel>? employees;

    void emitSnapshot() {
      if (allAppointments == null || employees == null) {
        return;
      }

      controller.add(
        DashboardSnapshot(
          todayAppointments: _filterTodayAppointments(allAppointments!),
          allAppointments: allAppointments!,
          employees: employees!,
        ),
      );
    }

    controller = StreamController<DashboardSnapshot>(
      onListen: () {
        appointmentsSubscription = watchAllAppointments(
          salonId: salonId,
        ).listen(
              (appointments) {
            allAppointments = appointments;
            emitSnapshot();
          },
          onError: controller.addError,
        );

        employeesSubscription = watchEmployees(
          salonId: salonId,
        ).listen(
              (value) {
            employees = value;
            emitSnapshot();
          },
          onError: controller.addError,
        );
      },
      onCancel: () async {
        await appointmentsSubscription?.cancel();
        await employeesSubscription?.cancel();
      },
    );

    return controller.stream;
  }

  Future<List<AppointmentModel>> loadAllAppointments({
    required String salonId,
  }) async {
    final snapshot = await _appointments
        .where(
      'salonId',
      isEqualTo: salonId,
    )
        .orderBy('date')
        .get();

    return snapshot.docs
        .map(
          (document) => AppointmentModel.fromMap(
        document.id,
        document.data(),
      ),
    )
        .toList();
  }

  Stream<List<AppointmentModel>> watchAllAppointments({
    required String salonId,
  }) {
    return _appointments
        .where(
      'salonId',
      isEqualTo: salonId,
    )
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (document) => AppointmentModel.fromMap(
          document.id,
          document.data(),
        ),
      )
          .toList(),
    );
  }

  Future<List<AppointmentModel>> loadTodayAppointments({
    required String salonId,
  }) async {
    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final end = start.add(
      const Duration(days: 1),
    );

    final snapshot = await _appointments
        .where(
      'salonId',
      isEqualTo: salonId,
    )
        .where(
      'date',
      isGreaterThanOrEqualTo: Timestamp.fromDate(start),
    )
        .where(
      'date',
      isLessThan: Timestamp.fromDate(end),
    )
        .orderBy('date')
        .get();

    return snapshot.docs
        .map(
          (document) => AppointmentModel.fromMap(
        document.id,
        document.data(),
      ),
    )
        .toList();
  }

  Future<List<EmployeeModel>> loadEmployees({
    required String salonId,
  }) async {
    final snapshot = await _employees(salonId)
        .where(
      'active',
      isEqualTo: true,
    )
        .orderBy('name')
        .get();

    return snapshot.docs
        .map(
          (document) => EmployeeModel.fromMap(
        document.id,
        document.data(),
      ),
    )
        .toList();
  }

  Stream<List<EmployeeModel>> watchEmployees({
    required String salonId,
  }) {
    return _employees(salonId)
        .where(
      'active',
      isEqualTo: true,
    )
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (document) => EmployeeModel.fromMap(
          document.id,
          document.data(),
        ),
      )
          .toList(),
    );
  }

  List<AppointmentModel> _filterTodayAppointments(
      List<AppointmentModel> appointments,
      ) {
    final now = DateTime.now();

    return appointments.where((appointment) {
      final date = appointment.appointmentStart;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();
  }
}