import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/register_service.dart';

class RegisterController extends ChangeNotifier {
  RegisterController(this._registerService);

  final RegisterService _registerService;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _registerService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      debugPrint('''
============= CUSTOMER CREATED =============
UID   : ${user.id}
EMAIL : ${user.email}
============================================
''');

      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Questa email è già registrata.';
          break;
        case 'weak-password':
          errorMessage = 'La password è troppo debole.';
          break;
        case 'invalid-email':
          errorMessage = 'Email non valida.';
          break;
        default:
          errorMessage = e.message ?? 'Errore di autenticazione.';
      }

      return false;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('RegisterController -> $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}