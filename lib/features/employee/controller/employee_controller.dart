import 'package:flutter/foundation.dart';

import 'package:salon_booking/features/employee/models/employee_model.dart';
import '../services/employee_service.dart';

class EmployeeController extends ChangeNotifier {
  EmployeeController(this._service);

  final EmployeeService _service;

  bool _loading = false;
  String? _error;

  List<EmployeeModel> _employees = [];
  EmployeeModel? _selectedEmployee;

  bool get isLoading => _loading;

  String? get error => _error;

  List<EmployeeModel> get employees => _employees;

  EmployeeModel? get selectedEmployee => _selectedEmployee;

  int get employeeCount => _employees.length;

  Future<void> loadEmployees(
      String salonId,
      ) async {
    if (salonId.isEmpty) return;

    _error = null;
    _setLoading(true);

    try {
      _employees = await _service.getEmployees(salonId);
    } catch (e, s) {
      _error = e.toString();

      debugPrint('EMPLOYEE ERROR: $e');
      debugPrintStack(stackTrace: s);
    } finally {
      _setLoading(false);
    }
  }

  EmployeeModel? employeeById(String id) {
    try {
      return _employees.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void selectEmployee(EmployeeModel employee) {
    _selectedEmployee = employee;
    notifyListeners();
  }

  void clearSelection() {
    _selectedEmployee = null;
    notifyListeners();
  }

  void clearEmployees() {
    _employees = [];
    _selectedEmployee = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_loading == value) return;

    _loading = value;
    notifyListeners();
  }
}