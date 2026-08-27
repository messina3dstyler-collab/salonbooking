import 'package:flutter/material.dart';

import '../services/login_service.dart';

class LoginController extends ChangeNotifier {
  LoginController(this._loginService);

  final LoginService _loginService;

  bool isLoading = false;
  String? errorMessage;

  String? uid;
  String? role;
  String? salonId;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;

    uid = null;
    role = null;
    salonId = null;

    notifyListeners();

    try {
      final result = await _loginService.login(
        email: email,
        password: password,
      );

      uid = result.uid;
      role = result.role;
      salonId = result.salonId;

      debugPrint('''
================ LOGIN =================
UID      : $uid
ROLE     : $role
SALON ID : $salonId
========================================
''');

      return true;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('LoginController -> $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool get isCustomer => role == 'customer';

  bool get isAdmin => role == 'admin';

  String? get currentSalonId => salonId;
}