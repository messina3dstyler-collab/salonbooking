import 'package:firebase_auth/firebase_auth.dart';

import '../models/home_user.dart';

class HomeService {
  const HomeService();

  HomeUser currentUser() {
    final user = FirebaseAuth.instance.currentUser;

    return HomeUser(
      name:
          user?.displayName?.isNotEmpty == true ? user!.displayName! : 'Utente',
      email: user?.email ?? '',
    );
  }
}
