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

  String? get salonId => _salonId;

  // ==================================================
  // CONTESTO SALONE
  // ==================================================

  void setSalonId(String? salonId) {
    final normalizedSalonId = salonId?.trim();

    if (_salonId == normalizedSalonId) {
      return;
    }

    _salonId = normalizedSalonId;

    notifyListeners();

    if (_salonId != null && _salonId!.isNotEmpty) {
      loadAppointmentsBySalon(
        _salonId!,
      );
    }
  }

  void clearSalon() {
    if (_salonId == null) {
      return;
    }

    _salonId = null;
    notifyListeners();
  }

  // ==================================================
  // REFRESH
  // ==================================================

  Future<void> refresh() {
    return loadAppointments();
  }

  // ==================================================
  // CLIENTE
  // ==================================================

  Future<void> loadAppointments() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _appointments = [];
      _error = null;
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

    if (user == null) {
      _appointments = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    _error = null;

    try {
      _appointments =
      await _service.getAppointmentsByUserAndDate(
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

  // ==================================================
  // CREAZIONE
  // ==================================================

  /// Crea un Appointment usando la reservation atomica
  /// degli slot temporali.
  ///
  /// Questa è l'operazione da utilizzare per il normale
  /// flusso di prenotazione cliente.
  Future<void> createAppointmentAtomically(
      AppointmentModel appointment,
      ) async {
    _setLoading(true);
    _error = null;

    try {
      await _service.createAppointmentAtomically(
        appointment: appointment,
      );

      await _reloadCurrentUserAppointments();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Creazione semplice dell'Appointment.
  ///
  /// Rimane disponibile per i flussi esistenti che non
  /// utilizzano la reservation atomica.
  Future<void> createAppointment(
      AppointmentModel appointment,
      ) async {
    _setLoading(true);
    _error = null;

    try {
      await _service.createAppointment(
        appointment: appointment,
      );

      await _reloadCurrentUserAppointments();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ==================================================
  // AGGIORNAMENTO ATOMICO
  // ==================================================

  /// Aggiorna un Appointment e i relativi slot
  /// in modo atomico.
  ///
  /// Viene utilizzato per:
  ///
  /// - cambio data/ora;
  /// - cambio dipendente;
  /// - cambio servizio;
  /// - cambio durata;
  /// - cambio stato;
  /// - liberazione dei vecchi slot;
  /// - prenotazione dei nuovi slot.
  Future<void> updateAppointmentAtomically(
      AppointmentModel appointment,
      ) async {
    _setLoading(true);
    _error = null;

    try {
      await _service.updateAppointmentAtomically(
        appointment: appointment,
      );

      await _reloadCurrentUserAppointments();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ==================================================
  // CANCELLAZIONE
  // ==================================================

  Future<void> cancelAppointment(
      String id,
      ) async {
    if (id.trim().isEmpty) {
      _error = 'ID appuntamento non valido.';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _error = null;

    try {
      await _service.cancelAppointment(
        appointmentId: id,
      );

      await _reloadCurrentUserAppointments();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ==================================================
  // READ
  // ==================================================

  Future<AppointmentModel?> getAppointment(
      String id,
      ) {
    return _service.getAppointment(
      appointmentId: id,
    );
  }

  // ==================================================
  // SALONE
  // ==================================================

  Future<List<AppointmentModel>> getAppointmentsBySalon(
      String salonId,
      ) {
    return _service.getAppointmentsBySalon(
      salonId: salonId,
    );
  }

  Future<void> loadAppointmentsBySalon(
      String salonId,
      ) async {
    if (salonId.trim().isEmpty) {
      _appointments = [];
      _error = 'ID salone non valido.';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _error = null;

    try {
      _appointments = await _service.getAppointmentsBySalon(
        salonId: salonId,
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ==================================================
  // DIPENDENTE
  // ==================================================

  Future<List<AppointmentModel>> getAppointmentsByEmployee(
      String employeeId,
      ) {
    return _service.getAppointmentsByEmployee(
      employeeId: employeeId,
    );
  }

  Future<List<AppointmentModel>>
  getEmployeeAppointmentsByDate({
    required String employeeId,
    required DateTime date,
  }) {
    return _service.getEmployeeAppointmentsByDate(
      employeeId: employeeId,
      date: date,
    );
  }

  // ==================================================
  // SALONE + DATA
  // ==================================================

  Future<List<AppointmentModel>>
  getAppointmentsBySalonAndDate(
      String salonId,
      DateTime date,
      ) {
    return _service.getAppointmentsBySalonAndDate(
      salonId: salonId,
      date: date,
    );
  }

  // ==================================================
  // CLIENTE + DATA
  // ==================================================

  Future<List<AppointmentModel>>
  getAppointmentsByUserAndDate(
      String userId,
      DateTime date,
      ) {
    return _service.getAppointmentsByUserAndDate(
      userId: userId,
      date: date,
    );
  }

  // ==================================================
  // STATO LOCALE
  // ==================================================

  void setAppointments(
      List<AppointmentModel> value,
      ) {
    _appointments = List<AppointmentModel>.from(value);
    notifyListeners();
  }

  void clearError() {
    if (_error == null) {
      return;
    }

    _error = null;
    notifyListeners();
  }

  // ==================================================
  // INTERNAL
  // ==================================================

  Future<void> _reloadCurrentUserAppointments() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _appointments = [];
      notifyListeners();
      return;
    }

    _appointments = await _service.getAppointmentsByUser(
      userId: user.uid,
    );

    notifyListeners();
  }

  void _setLoading(
      bool value,
      ) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;
    notifyListeners();
  }
}