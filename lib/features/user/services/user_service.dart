import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserService {
  UserService(this._repository);

  final UserRepository _repository;

  Future<UserModel?> getUser(String uid) {
    return _repository.getUser(uid);
  }

  Future<void> updateUser(UserModel user) {
    return _repository.updateUser(user);
  }

  Future<void> updateProfile({
    required String userId,
    required String name,
    required String phone,
  }) {
    return _repository.updateProfile(userId: userId, name: name, phone: phone);
  }
}
