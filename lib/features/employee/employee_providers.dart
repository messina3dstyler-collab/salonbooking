import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/employee_controller.dart';
import 'repositories/employee_repository.dart';
import 'services/employee_service.dart';

final employeeRepositoryProvider = Provider<EmployeeRepository>(
  (ref) => EmployeeRepository(FirebaseFirestore.instance),
);

final employeeServiceProvider = Provider<EmployeeService>(
  (ref) => EmployeeService(ref.read(employeeRepositoryProvider)),
);

final employeeControllerProvider = ChangeNotifierProvider<EmployeeController>(
  (ref) => EmployeeController(ref.read(employeeServiceProvider)),
);
