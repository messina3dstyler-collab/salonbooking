import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_dashboard_model.dart';
import '../models/today_overview_model.dart';

class AdminRepository {
  AdminRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _appointments(
      String salonId,
      ) =>
      _firestore
          .collection('salons')
          .doc(salonId)
          .collection('appointments');

  CollectionReference<Map<String, dynamic>> _employees(
      String salonId,
      ) =>
      _firestore
          .collection('salons')
          .doc(salonId)
          .collection('employees');

  Future<AdminDashboardModel> getDashboard(
      String salonId,
      ) async {
    final appointmentsSnapshot =
    await _appointments(salonId).get();

    final employeesSnapshot =
    await _employees(salonId).get();

    int completedAppointments = 0;
    int cancelledAppointments = 0;

    final serviceCounter = <String, int>{};
    final employeeCounter = <String, int>{};
    final customers = <String>{};

    for (final doc in appointmentsSnapshot.docs) {
      final data = doc.data();

      final status =
          data['status']?.toString() ?? '';

      if (status == 'Completata') {
        completedAppointments++;
      }

      if (status == 'Annullata') {
        cancelledAppointments++;
      }

      final userId =
          data['userId']?.toString() ?? '';

      if (userId.isNotEmpty) {
        customers.add(userId);
      }

      final serviceId =
          data['serviceId']?.toString() ?? '';

      if (serviceId.isNotEmpty) {
        serviceCounter[serviceId] =
            (serviceCounter[serviceId] ?? 0) + 1;
      }

      final employeeId =
          data['employeeId']?.toString() ?? '';

      if (employeeId.isNotEmpty) {
        employeeCounter[employeeId] =
            (employeeCounter[employeeId] ?? 0) + 1;
      }
    }

    return AdminDashboardModel(
      todayOverview: TodayOverviewModel.empty(),
      totalAppointments: appointmentsSnapshot.size,
      totalCustomers: customers.length,
      totalEmployees: employeesSnapshot.size,
      completedAppointments: completedAppointments,
      cancelledAppointments: cancelledAppointments,
      topService: _getTopValue(serviceCounter),
      topEmployee: _getTopValue(employeeCounter),
    );
  }

  String _getTopValue(
      Map<String, int> values,
      ) {
    if (values.isEmpty) {
      return '';
    }

    final sorted = values.entries.toList()
      ..sort(
            (a, b) => b.value.compareTo(a.value),
      );

    return sorted.first.key;
  }
}