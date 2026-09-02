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
    required String taxIdType,
    required String taxId,
    required int openingHour,
    required int closingHour,
    required List<int> closedWeekdays,
  }) async {
    if (isLoading) {
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _registrationService.register(
        ownerName: ownerName.trim(),
        salonName: salonName.trim(),
        email: email.trim(),
        password: password,
        phone: phone.trim(),
        address: address.trim(),
        city: city.trim(),
        description: description.trim(),
        taxIdType: taxIdType,
        taxId: taxId.trim(),
        openingHour: openingHour,
        closingHour: closingHour,
        closedWeekdays: List<int>.from(closedWeekdays),
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        'SalonRegisterController -> registration error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      errorMessage = _mapErrorMessage(e);

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _mapErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('email-already-in-use')) {
      return 'Questa email è già associata a un account.';
    }

    if (message.contains('invalid-email')) {
      return 'L\'indirizzo email non è valido.';
    }

    if (message.contains('weak-password')) {
      return 'La password scelta è troppo debole.';
    }

    if (message.contains('network-request-failed')) {
      return 'Problema di connessione. Riprova.';
    }

    if (message.contains('permission-denied')) {
      return 'Operazione non autorizzata.';
    }

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return 'Errore durante la registrazione del salone.';
  }
}