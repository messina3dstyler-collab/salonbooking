import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/constants/app_routes.dart';

class SplashNavigationResult {
  const SplashNavigationResult({
    required this.route,
    this.extra,
  });

  final String route;
  final Object? extra;
}

class SplashController {
  const SplashController();

  Future<SplashNavigationResult> initialize() async {
    await Future.delayed(const Duration(seconds: 2));

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return const SplashNavigationResult(
        route: AppRoutes.login,
      );
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        return const SplashNavigationResult(
          route: AppRoutes.login,
        );
      }

      final data = userDoc.data()!;

      final role = data['role'] as String? ?? 'customer';
      final salonId = data['salonId'] as String?;

      if (role == 'admin') {
        if (salonId == null || salonId.isEmpty) {
          return const SplashNavigationResult(
            route: AppRoutes.login,
          );
        }

        return SplashNavigationResult(
          route: AppRoutes.adminHome,
          extra: salonId,
        );
      }

      return const SplashNavigationResult(
        route: AppRoutes.home,
      );
    } catch (_) {
      return const SplashNavigationResult(
        route: AppRoutes.login,
      );
    }
  }
}