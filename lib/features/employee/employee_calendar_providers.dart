import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/employee_calendar_controller.dart';
import 'repositories/employee_calendar_repository.dart';
import 'services/employee_calendar_service.dart';

final employeeCalendarRepositoryProvider =
Provider<EmployeeCalendarRepository>((ref) {
  return EmployeeCalendarRepository(
    FirebaseFirestore.instance,
  );
});

final employeeCalendarServiceProvider =
Provider<EmployeeCalendarService>((ref) {
  return EmployeeCalendarService(
    ref.watch(employeeCalendarRepositoryProvider),
  );
});

final employeeCalendarControllerProvider =
ChangeNotifierProvider<EmployeeCalendarController>((ref) {
  return EmployeeCalendarController(
    ref.watch(employeeCalendarServiceProvider),
  );
});