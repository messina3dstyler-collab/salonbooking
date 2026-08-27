import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../user/models/user_model.dart';
import '../../user/services/user_service.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._userService);

  final UserService _userService;

  bool isLoading = false;

  UserModel? user;

  Future<void> loadUser() async {
    isLoading = true;
    notifyListeners();

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        user = null;
      } else {
        user = await _userService.getUser(firebaseUser.uid);
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    if (user == null) return;

    await _userService.updateProfile(
      userId: user!.id,
      name: name,
      phone: phone,
    );

    await loadUser();
  }
}
