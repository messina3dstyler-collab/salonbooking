import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/admin/presentation/pages/admin_home_page.dart';
import '../features/appointment/presentation/pages/appointments_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/salon_register_page.dart';
import '../features/main/presentation/pages/main_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';

  static const register = '/register';
  static const salonRegister = '/register-salon';

  static const home = '/home';
  static const adminHome = '/admin';

  static const appointments = '/appointments';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.salonRegister,
      builder: (context, state) => const SalonRegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: AppRoutes.appointments,
      builder: (context, state) => const AppointmentsPage(),
    ),
    GoRoute(
      path: AppRoutes.adminHome,
      builder: (context, state) {
        final salonId = state.extra as String?;

        if (salonId == null || salonId.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Errore: salone non associato all\'account.',
              ),
            ),
          );
        }

        return AdminHomePage(
          salonId: salonId,
        );
      },
    ),
  ],
);