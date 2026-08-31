import 'package:flutter/foundation.dart';

import '../models/admin_appointment_model.dart';
import '../models/appointment_filter.dart';
import '../services/admin_appointments_service.dart';

class AdminAppointmentsController extends ChangeNotifier {
  AdminAppointmentsController(this._service);

  final AdminAppointmentsService _service;

  List<AdminAppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _error;
  AppointmentFilter _filter = AppointmentFilter.all;
  String? _selectedEmployeeId;
  String _searchQuery = '';
  String _salonId = '';

  List<AdminAppointmentModel> get appointments => _filteredAppointments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AppointmentFilter get filter => _filter;
  String? get selectedEmployeeId => _selectedEmployeeId;
  String get searchQuery => _searchQuery;

  Map<String, String> get employeesMap {
    final map = <String, String>{};

    for (final a in _appointments) {
      if (a.employeeId.isNotEmpty && a.employeeName.isNotEmpty) {
        map[a.employeeId] = a.employeeName;
      }
    }

    final list = map.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    return Map.fromEntries(list);
  }

  List<AdminAppointmentModel> get _filteredAppointments =>
      _appointments
          .where(
            (a) =>
        _filter.matches(a.status) &&
            (_selectedEmployeeId == null ||
                a.employeeId == _selectedEmployeeId) &&
            _matchesSearch(a),
      )
          .toList();

  bool _matchesSearch(AdminAppointmentModel a) {
    final q = _searchQuery.trim().toLowerCase();

    if (q.isEmpty) {
      return true;
    }

    return [
      a.customerName,
      a.customerPhone,
      a.employeeName,
      a.employeePhone,
      a.serviceName,
      a.status,
      a.notes,
      a.serviceDuration.toString(),
      a.price.toString(),
      a.formattedDate,
      a.formattedTime,
    ].any((v) => v.toLowerCase().contains(q));
  }

  Future<void> loadAppointments({
    required String salonId,
  }) async {
    if (salonId.isEmpty) {
      return;
    }

    _salonId = salonId;
    _error = null;
    _setLoading(true);

    try {
      _appointments =
      await _service.getAppointmentsWithDetails(salonId);
    } catch (e, s) {
      _handleError(e, s);
    } finally {
      _setLoading(false);
    }
  }

  Future<List<AdminAppointmentModel>> getAppointmentsByDate({
    required String salonId,
    required DateTime date,
  }) {
    return _service.getAppointmentsByDate(
      salonId: salonId,
      date: date,
    );
  }

  Future<void> refresh() async {
    if (_salonId.isEmpty) {
      return;
    }

    await loadAppointments(
      salonId: _salonId,
    );
  }

  void changeSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void changeFilter(AppointmentFilter value) {
    _filter = value;
    notifyListeners();
  }

  void changeEmployeeFilter(String? id) {
    _selectedEmployeeId = id;
    notifyListeners();
  }

  void clearFilters() {
    _filter = AppointmentFilter.all;
    _selectedEmployeeId = null;
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> updateStatus({
    required String appointmentId,
    required String status,
  }) async {
    if (_salonId.isEmpty) {
      return;
    }

    try {
      await _service.updateStatus(
        _salonId,
        appointmentId,
        status,
      );

      await refresh();
    } catch (e, s) {
      _handleError(e, s);
    }
  }

  Future<void> updateEmployee({
    required String appointmentId,
    required String employeeId,
    required String employeeName,
    required String employeePhone,
    required String employeeSpecialization,
    required double employeeRating,
  }) async {
    if (_salonId.isEmpty) {
      return;
    }

    try {
      await _service.updateEmployee(
        salonId: _salonId,
        appointmentId: appointmentId,
        employeeId: employeeId,
        employeeName: employeeName,
        employeePhone: employeePhone,
        employeeSpecialization: employeeSpecialization,
        employeeRating: employeeRating,
      );

      await refresh();
    } catch (e, s) {
      _handleError(e, s);
    }
  }

  Future<void> deleteAppointment({
    required String appointmentId,
  }) async {
    if (_salonId.isEmpty) {
      return;
    }

    try {
      await _service.deleteAppointment(
        _salonId,
        appointmentId,
      );

      await refresh();
    } catch (e, s) {
      _handleError(e, s);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _handleError(Object e, StackTrace s) {
    _error = e.toString();

    debugPrint('ADMIN APPOINTMENTS ERROR: $e');
    debugPrintStack(stackTrace: s);

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}