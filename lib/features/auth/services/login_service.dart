import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class LoginResult {
  const LoginResult({
    required this.uid,
    required this.role,
    this.salonId,
  });

  final String uid;
  final String role;
  final String? salonId;

  bool get isAdmin => role == 'admin';
}

class LoginService {
  LoginService(
      this._authService,
      this._firestore,
      );

  final AuthService _authService;
  final FirebaseFirestore _firestore;

  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    await _authService.login(
      email: email,
      password: password,
    );

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      throw Exception('Utente Firebase non trovato.');
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!snapshot.exists) {
      throw Exception('Profilo utente non trovato.');
    }

    final data = snapshot.data()!;

    final role = data['role'] as String? ?? 'customer';
    final salonId = data['salonId'] as String?;

    if (role == 'admin' &&
        (salonId == null || salonId.isEmpty)) {
      throw Exception('Admin senza salonId associato.');
    }

    return LoginResult(
      uid: firebaseUser.uid,
      role: role,
      salonId: salonId,
    );
  }
}