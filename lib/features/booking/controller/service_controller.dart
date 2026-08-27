import 'package:flutter/material.dart';

import '../models/service_model.dart';
import '../services/service_service.dart';

class ServiceController extends ChangeNotifier {
  ServiceController(this._service);

  final ServiceService _service;

  bool isLoading = false;

  List<ServiceModel> services = [];

  ServiceModel? selectedService;

  String? errorMessage;

  Future<void> loadServices(String salonId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      services = await _service.getServices(salonId);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void selectService(ServiceModel service) {
    selectedService = service;
    notifyListeners();
  }
}
