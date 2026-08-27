import 'package:flutter/foundation.dart';

import 'package:salon_booking/features/employee/models/employee_model.dart';
import '../services/employee_service.dart';

class EmployeeController extends ChangeNotifier {
  EmployeeController(this._service);

  final EmployeeService _service;

  List<EmployeeModel> _employees = [];

  bool _isLoading = false;

  String? _error;

  String _salonId = '';

  bool _showAllEmployees = false;

  List<EmployeeModel> get employees => _employees;

  bool get isLoading => _isLoading;

  String? get error => _error;

  // =====================================================
  // LOAD ACTIVE EMPLOYEES
  // =====================================================

  Future<void> loadEmployees(
      String salonId,
      ) async {
    _showAllEmployees = false;

    await _load(
      salonId,
    );
  }

  // =====================================================
  // LOAD ALL EMPLOYEES
  // =====================================================

  Future<void> loadAllEmployees(
      String salonId,
      ) async {
    _showAllEmployees = true;

    await _load(
      salonId,
    );
  }

  Future<void> _load(
      String salonId,
      ) async {
    if (salonId.isEmpty) {
      _error = 'Salon ID mancante';
      notifyListeners();
      return;
    }

    _salonId = salonId;

    _setLoading(true);

    try {
      if (_showAllEmployees) {
        _employees = await _service.getAllEmployees(
          salonId,
        );
      } else {
        _employees = await _service.getEmployees(
          salonId,
        );
      }

      _error = null;
    } catch (e, stack) {
      debugPrint(
        'EMPLOYEE ERROR: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      _employees = [];
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // =====================================================
  // CREATE
  // =====================================================

  Future<void> createEmployee(
      EmployeeModel employee,
      ) async {
    try {
      await _service.createEmployee(
        _salonId,
        employee,
      );

      await refresh();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // =====================================================
  // UPDATE
  // =====================================================

  Future<void> updateEmployee({
    required String employeeId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _service.updateEmployee(
        _salonId,
        employeeId,
        data,
      );

      await refresh();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // =====================================================
  // DELETE
  // =====================================================

  Future<void> deleteEmployee(
      String employeeId,
      ) async {
    try {
      await _service.deleteEmployee(
        _salonId,
        employeeId,
      );

      await refresh();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // =====================================================
  // RESTORE
  // =====================================================

  Future<void> restoreEmployee(
      String employeeId,
      ) async {
    try {
      await _service.restoreEmployee(
        _salonId,
        employeeId,
      );

      await refresh();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // =====================================================
  // FIND
  // =====================================================

  EmployeeModel? getById(
      String id,
      ) {
    try {
      return _employees.firstWhere(
            (employee) => employee.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  // =====================================================
  // REFRESH
  // =====================================================

  Future<void> refresh() async {
    if (_salonId.isEmpty) {
      return;
    }

    await _load(
      _salonId,
    );
  }

  // =====================================================
  // PRIVATE
  // =====================================================

  void _setLoading(
      bool value,
      ) {
    _isLoading = value;
    notifyListeners();
  }
}