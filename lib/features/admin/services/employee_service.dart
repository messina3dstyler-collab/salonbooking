import 'package:salon_booking/features/employee/models/employee_model.dart';
import '../repositories/employee_repository.dart';

class EmployeeService {
  EmployeeService(this._repository);

  final EmployeeRepository _repository;

  Future<List<EmployeeModel>> getEmployees(
      String salonId,
      ) {
    return _repository.getEmployees(
      salonId,
    );
  }

  Future<List<EmployeeModel>> getAllEmployees(
      String salonId,
      ) {
    return _repository.getAllEmployees(
      salonId,
    );
  }

  Future<String> createEmployee(
      String salonId,
      EmployeeModel employee,
      ) {
    return _repository.createEmployee(
      salonId,
      employee,
    );
  }

  Future<void> updateEmployee(
      String salonId,
      String employeeId,
      Map<String, dynamic> data,
      ) {
    return _repository.updateEmployee(
      salonId,
      employeeId,
      data,
    );
  }

  Future<void> deleteEmployee(
      String salonId,
      String employeeId,
      ) {
    return _repository.deleteEmployee(
      salonId,
      employeeId,
    );
  }

  Future<void> restoreEmployee(
      String salonId,
      String employeeId,
      ) {
    return _repository.restoreEmployee(
      salonId,
      employeeId,
    );
  }
}