import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../appointment/models/appointment_model.dart';
import '../../employee/models/employee_model.dart';
import '../../requests/models/appointment_request.dart';

import '../models/dashboard_snapshot.dart';

class DashboardQueryHelper {
  DashboardQueryHelper({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _appointments =>
      _firestore.collection('appointments');

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection('appointment_requests');

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
    final results = await Future.wait([
      loadTodayAppointments(
        salonId: salonId,
      ),
      loadAllAppointments(
        salonId: salonId,
      ),
      loadEmployees(
        salonId: salonId,
      ),
      loadPendingRequestsCount(
        salonId: salonId,
      ),
    ]);

    return DashboardSnapshot(
      todayAppointments: results[0] as List<AppointmentModel>,
      allAppointments: results[1] as List<AppointmentModel>,
      employees: results[2] as List<EmployeeModel>,
      pendingRequests: results[3] as int,
    );
  }

  Stream<DashboardSnapshot> watchDashboardSnapshot({
    required String salonId,
  }) {
    late final StreamController<DashboardSnapshot> controller;

    StreamSubscription<List<AppointmentModel>>?
    appointmentsSubscription;

    StreamSubscription<List<EmployeeModel>>?
    employeesSubscription;

    StreamSubscription<int>? pendingRequestsSubscription;

    List<AppointmentModel>? allAppointments;
    List<EmployeeModel>? employees;
    int? pendingRequests;

    void emitSnapshot() {
      if (allAppointments == null ||
          employees == null ||
          pendingRequests == null) {
        return;
      }

      controller.add(
        DashboardSnapshot(
          todayAppointments: _filterTodayAppointments(
            allAppointments!,
          ),
          allAppointments: allAppointments!,
          employees: employees!,
          pendingRequests: pendingRequests!,
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

        pendingRequestsSubscription = watchPendingRequestsCount(
          salonId: salonId,
        ).listen(
              (value) {
            pendingRequests = value;
            emitSnapshot();
          },
          onError: controller.addError,
        );
      },
      onCancel: () async {
        await appointmentsSubscription?.cancel();
        await employeesSubscription?.cancel();
        await pendingRequestsSubscription?.cancel();
      },
    );

    return controller.stream;
  }

  Future<int> loadPendingRequestsCount({
    required String salonId,
  }) async {
    final results = await Future.wait([
      _requests
          .where(
        'salonId',
        isEqualTo: salonId,
      )
          .where(
        'status',
        isEqualTo:
        AppointmentRequestStatus.pendingCustomer.name,
      )
          .get(),
      _requests
          .where(
        'salonId',
        isEqualTo: salonId,
      )
          .where(
        'status',
        isEqualTo:
        AppointmentRequestStatus.pendingSalon.name,
      )
          .get(),
    ]);

    return results.fold<int>(
      0,
          (total, snapshot) => total + snapshot.size,
    );
  }

  Stream<int> watchPendingRequestsCount({
    required String salonId,
  }) {
    late final StreamController<int> controller;

    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
    pendingCustomerSubscription;

    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
    pendingSalonSubscription;

    int pendingCustomerCount = 0;
    int pendingSalonCount = 0;

    // Evita di emettere un totale parziale prima che entrambi
    // i listener abbiano ricevuto il loro primo snapshot.
    bool hasPendingCustomerSnapshot = false;
    bool hasPendingSalonSnapshot = false;

    void emitCount() {
      if (!hasPendingCustomerSnapshot ||
          !hasPendingSalonSnapshot) {
        return;
      }

      controller.add(
        pendingCustomerCount + pendingSalonCount,
      );
    }

    controller = StreamController<int>(
      onListen: () {
        pendingCustomerSubscription = _requests
            .where(
          'salonId',
          isEqualTo: salonId,
        )
            .where(
          'status',
          isEqualTo:
          AppointmentRequestStatus.pendingCustomer.name,
        )
            .snapshots()
            .listen(
              (snapshot) {
            pendingCustomerCount = snapshot.size;
            hasPendingCustomerSnapshot = true;
            emitCount();
          },
          onError: controller.addError,
        );

        pendingSalonSubscription = _requests
            .where(
          'salonId',
          isEqualTo: salonId,
        )
            .where(
          'status',
          isEqualTo:
          AppointmentRequestStatus.pendingSalon.name,
        )
            .snapshots()
            .listen(
              (snapshot) {
            pendingSalonCount = snapshot.size;
            hasPendingSalonSnapshot = true;
            emitCount();
          },
          onError: controller.addError,
        );
      },
      onCancel: () async {
        await pendingCustomerSubscription?.cancel();
        await pendingSalonSubscription?.cancel();
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