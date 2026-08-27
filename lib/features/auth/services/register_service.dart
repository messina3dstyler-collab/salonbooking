import 'package:firebase_auth/firebase_auth.dart';

import '../../user/models/user_model.dart';
import '../../user/repositories/user_repository.dart';
import 'auth_service.dart';

class RegisterService {
  const RegisterService(
      this._authService,
      this._userRepository,
      );

  final AuthService _authService;
  final UserRepository _userRepository;

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _authService.register(
      email: email,
      password: password,
    );

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      throw Exception('Utente Firebase non trovato.');
    }

    final user = UserModel(
      id: firebaseUser.uid,
      name: name,
      email: email,
      phone: phone,
      role: 'customer',
      salonId: null,
      createdAt: DateTime.now(),
    );

    await _userRepository.createUser(user);

    return user;
  }
}