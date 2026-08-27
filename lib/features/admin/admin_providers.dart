import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../employee/employee_calendar_providers.dart';

import 'controllers/admin_agenda_controller.dart';
import 'controllers/admin_appointments_controller.dart';
import 'controllers/admin_controller.dart';
import 'controllers/admin_dashboard_controller.dart';
import 'controllers/admin_services_controller.dart';
import 'controllers/employee_controller.dart';

import 'datasource/admin_dashboard_datasource.dart';
import 'datasource/admin_dashboard_firestore_datasource.dart';

import 'providers/current_salon_provider.dart';

import 'repositories/admin_appointments_repository.dart';
import 'repositories/admin_dashboard_repository.dart';
import 'repositories/admin_dashboard_repository_impl.dart';
import 'repositories/admin_repository.dart';
import 'repositories/admin_services_repository.dart';
import 'repositories/employee_repository.dart';

import 'services/admin_appointments_service.dart';
import 'services/admin_dashboard_service.dart';
import 'services/admin_service.dart';
import 'services/admin_services_service.dart';
import 'services/employee_service.dart';

/// =====================================================
/// FIRESTORE
/// =====================================================

final adminFirestoreProvider = Provider<FirebaseFirestore>(
      (_) => FirebaseFirestore.instance,
);

/// =====================================================
/// SALONE CORRENTE
/// =====================================================

final adminCurrentSalonProvider = Provider<String>(
      (ref) => ref.watch(currentSalonIdProvider),
);

/// =====================================================
/// ADMIN
/// =====================================================

final adminRepositoryProvider = Provider<AdminRepository>(
      (ref) => AdminRepository(
    ref.read(adminFirestoreProvider),
  ),
);

final adminServiceProvider = Provider<AdminService>(
      (ref) => AdminService(
    ref.read(adminRepositoryProvider),
  ),
);

final adminControllerProvider =
ChangeNotifierProvider<AdminController>(
      (ref) => AdminController(
    ref.read(adminServiceProvider),
  ),
);

/// =====================================================
/// DASHBOARD
/// =====================================================

final adminDashboardDatasourceProvider =
Provider<AdminDashboardDatasource>(
      (ref) => AdminDashboardFirestoreDatasource(
    firestore: ref.read(adminFirestoreProvider),
  ),
);

final adminDashboardRepositoryProvider =
Provider<AdminDashboardRepository>(
      (ref) => AdminDashboardRepositoryImpl(
    datasource: ref.read(
      adminDashboardDatasourceProvider,
    ),
  ),
);

final adminDashboardServiceProvider =
Provider<AdminDashboardService>(
      (ref) => AdminDashboardService(
    ref.read(
      adminDashboardRepositoryProvider,
    ),
  ),
);

final adminDashboardControllerProvider =
ChangeNotifierProvider<AdminDashboardController>(
      (ref) => AdminDashboardController(
    ref.read(
      adminDashboardServiceProvider,
    ),
  ),
);

/// =====================================================
/// AGENDA
/// =====================================================

final adminAgendaControllerProvider =
ChangeNotifierProvider<AdminAgendaController>(
      (ref) => AdminAgendaController(
    ref.read(adminAppointmentsServiceProvider),
    ref.read(employeeCalendarServiceProvider),
  ),
);

/// =====================================================
/// APPUNTAMENTI
/// =====================================================

final adminAppointmentsRepositoryProvider =
Provider<AdminAppointmentsRepository>(
      (ref) => AdminAppointmentsRepository(
    ref.read(adminFirestoreProvider),
  ),
);

final adminAppointmentsServiceProvider =
Provider<AdminAppointmentsService>(
      (ref) => AdminAppointmentsService(
    ref.read(adminAppointmentsRepositoryProvider),
  ),
);

final adminAppointmentsControllerProvider =
ChangeNotifierProvider<AdminAppointmentsController>(
      (ref) => AdminAppointmentsController(
    ref.read(adminAppointmentsServiceProvider),
  ),
);

/// =====================================================
/// DIPENDENTI
/// =====================================================

final employeeRepositoryProvider =
Provider<EmployeeRepository>(
      (ref) => EmployeeRepository(
    ref.read(adminFirestoreProvider),
  ),
);

final employeeServiceProvider =
Provider<EmployeeService>(
      (ref) => EmployeeService(
    ref.read(employeeRepositoryProvider),
  ),
);

final employeeControllerProvider =
ChangeNotifierProvider<EmployeeController>(
      (ref) => EmployeeController(
    ref.read(employeeServiceProvider),
  ),
);

/// =====================================================
/// SERVIZI
/// =====================================================

final adminServicesRepositoryProvider =
Provider<AdminServicesRepository>(
      (ref) => AdminServicesRepository(
    ref.read(adminFirestoreProvider),
  ),
);

final adminServicesServiceProvider =
Provider<AdminServicesService>(
      (ref) => AdminServicesService(
    ref.read(adminServicesRepositoryProvider),
  ),
);

final adminServicesControllerProvider =
ChangeNotifierProvider<AdminServicesController>(
      (ref) => AdminServicesController(
    ref.read(adminServicesServiceProvider),
  ),
);