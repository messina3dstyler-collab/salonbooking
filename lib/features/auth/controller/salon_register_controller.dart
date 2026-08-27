import 'package:flutter/material.dart';

import '../services/salon_registration_service.dart';

class SalonRegisterController extends ChangeNotifier {
  SalonRegisterController(this._registrationService);

  final SalonRegistrationService _registrationService;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register({
    required String ownerName,
    required String salonName,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String city,
    required String description,
    required int openingHour,
    required int closingHour,
    required List<int> closedWeekdays,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _registrationService.register(
        ownerName: ownerName,
        salonName: salonName,
        email: email,
        password: password,
        phone: phone,
        address: address,
        city: city,
        description: description,
        openingHour: openingHour,
        closingHour: closingHour,
        closedWeekdays: closedWeekdays,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}