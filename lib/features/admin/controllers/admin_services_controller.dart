import 'package:flutter/foundation.dart';

import '../models/admin_service_model.dart';
import '../services/admin_services_service.dart';

class AdminServicesController extends ChangeNotifier {
  AdminServicesController(
      this._service,
      );

  final AdminServicesService _service;

  List<AdminServiceModel> _services = [];

  bool _isLoading = false;

  String? _error;

  String _salonId = '';

  // ==========================================
  // GETTERS
  // ==========================================

  List<AdminServiceModel> get services =>
      _services;

  bool get isLoading =>
      _isLoading;

  String? get error =>
      _error;


  // ==========================================
  // LOAD SERVIZI
  // ==========================================

  Future<void> loadServices(
      String salonId,
      ) async {

    if (salonId.isEmpty) {

      _error =
      'Salon ID mancante';

      notifyListeners();

      return;
    }


    _salonId =
        salonId;


    _setLoading(
      true,
    );


    try {

      _services =
      await _service.getAllServices(
        salonId,
      );


      _error =
      null;


    } catch (e, stack) {

      debugPrint(
        'ERRORE CARICAMENTO SERVIZI: $e',
      );


      debugPrintStack(
        stackTrace: stack,
      );


      _services =
      [];


      _error =
          e.toString();


    } finally {

      _setLoading(
        false,
      );

    }
  }



  // ==========================================
  // CREATE
  // ==========================================

  Future<void> createService(
      AdminServiceModel service,
      ) async {

    try {

      await _service.createService(
        _salonId,
        service,
      );


      await refresh();


    } catch (e) {

      _setError(
        e,
      );

    }
  }



  // ==========================================
  // UPDATE
  // ==========================================

  Future<void> updateService({
    required String serviceId,
    required Map<String, dynamic> data,
  }) async {

    try {

      await _service.updateService(
        _salonId,
        serviceId,
        data,
      );


      await refresh();


    } catch (e) {

      _setError(
        e,
      );

    }
  }



  // ==========================================
  // DELETE
  // ==========================================

  Future<void> deleteService(
      String serviceId,
      ) async {

    try {

      await _service.deleteService(
        _salonId,
        serviceId,
      );


      await refresh();


    } catch (e) {

      _setError(
        e,
      );

    }
  }



  // ==========================================
  // RESTORE
  // ==========================================

  Future<void> restoreService(
      String serviceId,
      ) async {

    try {

      await _service.restoreService(
        _salonId,
        serviceId,
      );


      await refresh();


    } catch (e) {

      _setError(
        e,
      );

    }
  }



  // ==========================================
  // GET BY ID
  // ==========================================

  AdminServiceModel? getById(
      String id,
      ) {

    for (final service in _services) {

      if (service.id == id) {

        return service;

      }
    }


    return null;
  }



  // ==========================================
  // REFRESH
  // ==========================================

  Future<void> refresh() async {

    if (_salonId.isEmpty) {

      return;

    }


    await loadServices(
      _salonId,
    );

  }



  // ==========================================
  // STATE
  // ==========================================

  void _setLoading(
      bool value,
      ) {

    _isLoading =
        value;

    notifyListeners();

  }



  void _setError(
      Object error,
      ) {

    _error =
        error.toString();

    notifyListeners();

  }
}