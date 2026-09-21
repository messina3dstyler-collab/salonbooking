import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

    debugPrint(
      'SPLASH -> FirebaseAuth.currentUser: '
          '${firebaseUser?.uid ?? 'NULL'}',
    );

    if (firebaseUser == null) {
      debugPrint(
        'SPLASH -> Nessun utente autenticato. '
            'Navigazione verso login.',
      );

      return const SplashNavigationResult(
        route: AppRoutes.login,
      );
    }

    try {
      debugPrint(
        'SPLASH -> Lettura users/${firebaseUser.uid}',
      );

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      debugPrint(
        'SPLASH -> Firestore user document exists: '
            '${userDoc.exists}',
      );

      if (!userDoc.exists) {
        debugPrint(
          'SPLASH -> Profilo utente non trovato.',
        );

        return const SplashNavigationResult(
          route: AppRoutes.login,
        );
      }

      final data = userDoc.data()!;

      debugPrint(
        'SPLASH -> User data: $data',
      );

      final roleValue = data['role'];

      if (roleValue is! String || roleValue.isEmpty) {
        debugPrint(
          'SPLASH -> Profilo utente con ruolo non valido. '
              'Navigazione verso login.',
        );

        return const SplashNavigationResult(
          route: AppRoutes.login,
        );
      }

      final role = roleValue;
      final salonId = data['salonId'] as String?;

      debugPrint(
        'SPLASH -> role=$role, salonId=$salonId',
      );

      if (role != 'customer' && role != 'admin') {
        debugPrint(
          'SPLASH -> Ruolo utente non riconosciuto. '
              'Navigazione verso login.',
        );

        return const SplashNavigationResult(
          route: AppRoutes.login,
        );
      }

      if (role == 'admin') {
        if (salonId == null || salonId.isEmpty) {
          debugPrint(
            'SPLASH -> Admin senza salonId. '
                'Navigazione verso login.',
          );

          return const SplashNavigationResult(
            route: AppRoutes.login,
          );
        }

        debugPrint(
          'SPLASH -> Admin valido. '
              'Navigazione verso ${AppRoutes.adminHome}',
        );

        return SplashNavigationResult(
          route: AppRoutes.adminHome,
          extra: salonId,
        );
      }

      if (salonId != null && salonId.isNotEmpty) {
        debugPrint(
          'SPLASH -> Customer con salonId non valido. '
              'Navigazione verso login.',
        );

        return const SplashNavigationResult(
          route: AppRoutes.login,
        );
      }

      debugPrint(
        'SPLASH -> Customer valido. '
            'Navigazione verso ${AppRoutes.home}',
      );

      return const SplashNavigationResult(
        route: AppRoutes.home,
      );
    } catch (e, stackTrace) {
      debugPrint(
        'SPLASH -> ERRORE FIRESTORE/AUTH: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return const SplashNavigationResult(
        route: AppRoutes.login,
      );
    }
  }
}