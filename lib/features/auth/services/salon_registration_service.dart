import 'package:cloud_functions/cloud_functions.dart';

import 'auth_service.dart';

class SalonRegistrationService {
  SalonRegistrationService(
      this._authService,
      this._functions,
      );

  final AuthService _authService;
  final FirebaseFunctions _functions;

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

    // =========================================================
    // 1. CREA ACCOUNT FIREBASE AUTH
    // =========================================================
    //
    // L'account Auth deve esistere prima della Callable perché
    // registerSalon utilizza request.auth.uid come identità
    // autorevole del nuovo titolare.
    //
    // Il client NON sceglie:
    // - uid
    // - role
    // - salonId
    //
    // Questi valori vengono determinati dalla Cloud Function.
    // =========================================================

    await _authService.register(
      email: email,
      password: password,
    );

    // =========================================================
    // 2. PROVISIONING TRUSTED SERVER-SIDE
    // =========================================================
    //
    // La Cloud Function crea in una singola transaction:
    //
    //   salons/{uid}
    //   users/{uid}
    //
    // con:
    //
    //   users/{uid}.role    = "admin"
    //   users/{uid}.salonId = uid
    //
    // Il client invia solamente i dati della registrazione.
    //
    // NON viene eseguito alcun createSalon/createUser
    // direttamente dal client.
    // =========================================================

    final callable = _functions.httpsCallable(
      'registerSalon',
    );

    await callable.call(<String, dynamic>{
      'ownerName': ownerName.trim(),
      'salonName': salonName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'address': address.trim(),
      'city': city.trim(),
      'description': description.trim(),
      'taxIdType': taxIdType,
      'taxId': taxId.trim(),
      'openingHour': openingHour,
      'closingHour': closingHour,
      'closedWeekdays': List<int>.from(closedWeekdays),
    });

    // =========================================================
    // REGISTRAZIONE COMPLETATA
    // =========================================================
    //
    // Nessun cleanup automatico dell'account Firebase Auth.
    //
    // Questo è intenzionale:
    //
    // se la transaction server-side fosse stata completata ma
    // la risposta della Callable fosse andata persa per un
    // problema di rete, cancellare Firebase Auth dal client
    // potrebbe lasciare:
    //
    //   users/{uid}  -> esistente
    //   salons/{uid} -> esistente
    //   Auth         -> eliminato
    //
    // La Cloud Function è invece idempotente e rifiuta un
    // secondo provisioning quando i documenti esistono già.
    // =========================================================
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