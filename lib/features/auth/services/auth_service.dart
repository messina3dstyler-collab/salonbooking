import '../repositories/auth_repository.dart';

class AuthService {
  const AuthService(this._repository);

  final AuthRepository _repository;

  Future<void> login({
    required String email,
    required String password,
  }) {
    return _repository.signIn(
      email: email,
      password: password,
    );
  }

  Future<void> register({
    required String email,
    required String password,
  }) {
    return _repository.register(
      email: email,
      password: password,
    );
  }

  Future<void> logout() {
    return _repository.signOut();
  }

  Future<bool> isLoggedIn() {
    return _repository.isLoggedIn();
  }
}