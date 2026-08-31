import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/appointment_model.dart';
import '../services/appointment_service.dart';

class AppointmentController extends ChangeNotifier {
  AppointmentController(this._service);

  final AppointmentService _service;

  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _error;
  String? _salonId;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasAppointments => _appointments.isNotEmpty;

  void setSalonId(String? salonId) {
    if (_salonId == salonId) return;

    _salonId = salonId;
    notifyListeners();
    loadAppointments();
  }

  void clearSalon() {
    _salonId = null;
    notifyListeners();
  }

  Future<void> refresh() => loadAppointments();

  Future<void> loadAppointments() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _appointments = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    _error = null;

    try {
      _appointments = await _service.getAppointmentsByUser(
        userId: user.uid,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadAppointmentsByDate({
    required DateTime date,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    _setLoading(true);
    _error = null;

    try {
      _appointments = await _service.getAppointmentsByUserAndDate(
        userId: user.uid,
        date: date,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createAppointment(AppointmentModel appointment) async {
    try {
      await _service.createAppointment(
        appointment: appointment,
      );

      _appointments = [..._appointments, appointment];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> cancelAppointment(String id) async {
    try {
      await _service.cancelAppointment(
        appointmentId: id,
      );

      final index = _appointments.indexWhere(
            (a) => a.id == id,
      );

      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(
          status: 'Annullata',
          updatedAt: Timestamp.now(),
        );
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<AppointmentModel?> getAppointment(String id) {
    return _service.getAppointment(
      appointmentId: id,
    );
  }

  Future<List<AppointmentModel>> getAppointmentsBySalon(
      String salonId,
      ) {
    return _service.getAppointmentsBySalon(
      salonId: salonId,
    );
  }

  Future<List<AppointmentModel>> getAppointmentsByEmployee(
      String employeeId,
      ) {
    return _service.getAppointmentsByEmployee(
      employeeId: employeeId,
    );
  }

  Future<List<AppointmentModel>> getEmployeeAppointmentsByDate({
    required String employeeId,
    required DateTime date,
  }) {
    return _service.getEmployeeAppointmentsByDate(
      employeeId: employeeId,
      date: date,
    );
  }

  Future<List<AppointmentModel>> getAppointmentsBySalonAndDate(
      String salonId,
      DateTime date,
      ) {
    return _service.getAppointmentsBySalonAndDate(
      salonId: salonId,
      date: date,
    );
  }

  Future<List<AppointmentModel>> getAppointmentsByUserAndDate(
      String userId,
      DateTime date,
      ) {
    return _service.getAppointmentsByUserAndDate(
      userId: userId,
      date: date,
    );
  }

  void setAppointments(List<AppointmentModel> value) {
    _appointments = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;

    _isLoading = value;
    notifyListeners();
  }
}