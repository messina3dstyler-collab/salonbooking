import 'package:firebase_auth/firebase_auth.dart';

import '../../salon/models/salon_model.dart';
import '../../salon/repositories/salon_repository.dart';
import '../../user/models/user_model.dart';
import '../../user/repositories/user_repository.dart';

import 'auth_service.dart';

class SalonRegistrationService {
  SalonRegistrationService(
      this._authService,
      this._userRepository,
      this._salonRepository,
      );

  final AuthService _authService;
  final UserRepository _userRepository;
  final SalonRepository _salonRepository;

  Future<void> register({
    required String ownerName,
    required String salonName,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String city,
    required String description,

    required String taxIdType,
    required String taxId,

    required int openingHour,
    required int closingHour,
    required List<int> closedWeekdays,
  }) async {
    User? firebaseUser;

    try {
      await _authService.register(
        email: email,
        password: password,
      );

      firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception(
          'Utente Firebase non trovato.',
        );
      }

      final salon = SalonModel(
        id: firebaseUser.uid,
        name: salonName,
        address: address,
        city: city,
        imageUrl: '',
        rating: 0,
        reviewCount: 0,
        phone: phone,
        description: description,

        taxIdType: taxIdType,
        taxId: taxId,

        openingHour: openingHour,
        closingHour: closingHour,
        closedWeekdays: closedWeekdays,
        closedDates: const [],
        active: true,
      );

      await _salonRepository.createSalon(
        salon,
      );

      final user = UserModel(
        id: firebaseUser.uid,
        name: ownerName,
        email: email,
        phone: phone,
        role: 'admin',
        salonId: firebaseUser.uid,
        createdAt: DateTime.now(),
      );

      await _userRepository.createUser(
        user,
      );
    } catch (e) {
      try {
        await firebaseUser?.delete();
      } catch (_) {}

      rethrow;
    }
  }
}