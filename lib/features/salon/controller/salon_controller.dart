import 'package:flutter/material.dart';

import '../models/salon_model.dart';
import '../services/salon_service.dart';

class SalonController extends ChangeNotifier {
  SalonController(this._service);

  final SalonService _service;

  bool isLoading = false;

  List<SalonModel> salons = [];

  Future<void> loadSalons() async {
    isLoading = true;
    notifyListeners();

    try {
      salons = await _service.getSalons();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
