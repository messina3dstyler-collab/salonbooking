import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../salon/salon_providers.dart';
import '../user/user_providers.dart';
import 'controller/login_controller.dart';
import 'controller/register_controller.dart';
import 'controller/salon_register_controller.dart';
import 'repositories/firebase_auth_repository.dart';
import 'services/auth_service.dart';
import 'services/login_service.dart';
import 'services/register_service.dart';
import 'services/salon_registration_service.dart';

final authRepositoryProvider = Provider<FirebaseAuthRepository>(
      (ref) => FirebaseAuthRepository(),
);

final authServiceProvider = Provider<AuthService>(
      (ref) => AuthService(
    ref.read(authRepositoryProvider),
  ),
);

final loginServiceProvider = Provider<LoginService>(
      (ref) => LoginService(
    ref.read(authServiceProvider),
    FirebaseFirestore.instance,
  ),
);

final registerServiceProvider = Provider<RegisterService>(
      (ref) => RegisterService(
    ref.read(authServiceProvider),
    ref.read(userRepositoryProvider),
  ),
);

final salonRegistrationServiceProvider = Provider<SalonRegistrationService>(
      (ref) => SalonRegistrationService(
    ref.read(authServiceProvider),
    ref.read(userRepositoryProvider),
    ref.read(salonRepositoryProvider),
  ),
);

final loginControllerProvider = ChangeNotifierProvider<LoginController>(
      (ref) => LoginController(
    ref.read(loginServiceProvider),
  ),
);

final registerControllerProvider = ChangeNotifierProvider<RegisterController>(
      (ref) => RegisterController(
    ref.read(registerServiceProvider),
  ),
);

final salonRegisterControllerProvider =
ChangeNotifierProvider<SalonRegisterController>(
      (ref) => SalonRegisterController(
    ref.read(salonRegistrationServiceProvider),
  ),
);