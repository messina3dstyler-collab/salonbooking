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
    _validateRegistrationData(
      ownerName: ownerName,
      salonName: salonName,
      email: email,
      password: password,
      taxIdType: taxIdType,
      taxId: taxId,
      openingHour: openingHour,
      closingHour: closingHour,
      closedWeekdays: closedWeekdays,
    );

    User? firebaseUser;
    String? salonId;
    bool salonCreated = false;

    try {
      // =========================================================
      // 1. CREA ACCOUNT FIREBASE AUTH
      // =========================================================

      await _authService.register(
        email: email,
        password: password,
      );

      firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception(
          'Utente Firebase non trovato dopo la registrazione.',
        );
      }

      salonId = firebaseUser.uid;

      // =========================================================
      // 2. CREA DOCUMENTO SALON
      // =========================================================

      final salon = SalonModel(
        id: salonId,
        name: salonName.trim(),
        address: address.trim(),
        city: city.trim(),
        imageUrl: '',
        rating: 0,
        reviewCount: 0,
        phone: phone.trim(),
        description: description.trim(),
        openingHour: openingHour,
        closingHour: closingHour,
        closedWeekdays: List<int>.from(closedWeekdays),
        closedDates: const [],
        active: true,
        taxIdType: taxIdType,
        taxId: taxId.trim(),
      );

      await _salonRepository.createSalon(salon);
      salonCreated = true;

      // =========================================================
      // 3. CREA DOCUMENTO USER
      // =========================================================

      final user = UserModel(
        id: salonId,
        name: ownerName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        role: 'admin',
        salonId: salonId,
        createdAt: DateTime.now(),
      );

      await _userRepository.createUser(user);

      // =========================================================
      // REGISTRAZIONE COMPLETATA
      // =========================================================
    } catch (e) {
      // =========================================================
      // CLEANUP
      // =========================================================
      //
      // Il Salon viene eliminato solamente se la sua creazione
      // è realmente andata a buon fine.
      //
      // La delete del documento users/{uid} NON viene effettuata
      // dal client perché le Firestore Rules la vietano.
      // =========================================================

      if (salonCreated && salonId != null) {
        try {
          await _salonRepository.deleteSalon(salonId);
        } catch (_) {
          // Il cleanup del Salon non deve nascondere
          // l'errore originale della registrazione.
        }
      }

      // Rimuove l'account Firebase creato durante questa
      // procedura.
      try {
        await firebaseUser?.delete();
      } catch (_) {
        // Manteniamo l'errore originale.
      }

      rethrow;
    }
  }

  void _validateRegistrationData({
    required String ownerName,
    required String salonName,
    required String email,
    required String password,
    required String taxIdType,
    required String taxId,
    required int openingHour,
    required int closingHour,
    required List<int> closedWeekdays,
  }) {
    if (ownerName.trim().isEmpty) {
      throw Exception('Il nome del titolare è obbligatorio.');
    }

    if (salonName.trim().isEmpty) {
      throw Exception('Il nome del salone è obbligatorio.');
    }

    if (email.trim().isEmpty) {
      throw Exception("L'email è obbligatoria.");
    }

    if (password.length < 6) {
      throw Exception(
        'La password deve contenere almeno 6 caratteri.',
      );
    }

    if (taxIdType != 'vat' && taxIdType != 'fiscalCode') {
      throw Exception(
        'Tipo di identificativo fiscale non valido.',
      );
    }

    if (taxId.trim().isEmpty) {
      throw Exception(
        taxIdType == 'vat'
            ? 'La Partita IVA è obbligatoria.'
            : 'Il Codice Fiscale è obbligatorio.',
      );
    }

    if (openingHour < 0 || openingHour > 23) {
      throw Exception('Orario di apertura non valido.');
    }

    if (closingHour < 0 || closingHour > 23) {
      throw Exception('Orario di chiusura non valido.');
    }

    if (closingHour <= openingHour) {
      throw Exception(
        "L'orario di chiusura deve essere successivo "
            "all'orario di apertura.",
      );
    }

    for (final weekday in closedWeekdays) {
      if (weekday < 1 || weekday > 7) {
        throw Exception(
          'Giorno di chiusura non valido.',
        );
      }
    }
  }
}