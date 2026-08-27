import 'package:salon_booking/features/employee/models/employee_model.dart';
import '../repositories/employee_repository.dart';

class EmployeeService {
  EmployeeService(this._repository);

  final EmployeeRepository _repository;

  Future<List<EmployeeModel>> getEmployees(
      String salonId,
      ) {
    return _repository.getEmployees(salonId);
  }

  Future<EmployeeModel?> getEmployee({
    required String salonId,
    required String employeeId,
  }) {
    return _repository.getEmployee(
      salonId: salonId,
      employeeId: employeeId,
    );
  }

  Future<void> updateEmployee(EmployeeModel employee) {
    return _repository.updateEmployee(employee);
  }

  Future<void> updateEmployeeRating({
    required String salonId,
    required String employeeId,
    required double rating,
    required int reviewCount,
  }) {
    return _repository.updateEmployeeRating(
      salonId: salonId,
      employeeId: employeeId,
      rating: rating,
      reviewCount: reviewCount,
    );
  }
}