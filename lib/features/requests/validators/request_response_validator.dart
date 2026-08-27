import '../models/appointment_request.dart';

class RequestResponseValidator {
  const RequestResponseValidator();

  //--------------------------------------------------
  // ACCETTAZIONE
  //--------------------------------------------------

  String? validateAccept(
      AppointmentRequest request,
      ) {
    //------------------------------------------
    // Deve essere in attesa del cliente
    //------------------------------------------

    if (request.status !=
        AppointmentRequestStatus.pendingCustomer) {
      return "La richiesta non è più in attesa della risposta del cliente.";
    }

    //------------------------------------------
    // Richiesta già scaduta
    //------------------------------------------

    if (_isExpired(request)) {
      return "La richiesta è scaduta.";
    }

    return null;
  }

  //--------------------------------------------------
  // RIFIUTO
  //--------------------------------------------------

  String? validateReject(
      AppointmentRequest request,
      ) {
    //------------------------------------------
    // Deve essere in attesa del cliente
    //------------------------------------------

    if (request.status !=
        AppointmentRequestStatus.pendingCustomer) {
      return "La richiesta non è più in attesa della risposta del cliente.";
    }

    //------------------------------------------
    // Richiesta già scaduta
    //------------------------------------------

    if (_isExpired(request)) {
      return "La richiesta è scaduta.";
    }

    return null;
  }

  //--------------------------------------------------
  // ANNULLAMENTO DA PARTE DEL SALONE
  //--------------------------------------------------

  String? validateCancel(
      AppointmentRequest request,
      ) {
    switch (request.status) {
      case AppointmentRequestStatus.draft:
      case AppointmentRequestStatus.pendingCustomer:
        return null;

      case AppointmentRequestStatus.accepted:
        return "La richiesta è già stata accettata.";

      case AppointmentRequestStatus.rejected:
        return "La richiesta è già stata rifiutata.";

      case AppointmentRequestStatus.expired:
        return "La richiesta è già scaduta.";

      case AppointmentRequestStatus.cancelled:
        return "La richiesta è già stata annullata.";
    }
  }

  //--------------------------------------------------
  // SOLLECITO
  //--------------------------------------------------

  String? validateReminder(
      AppointmentRequest request,
      ) {
    if (request.status !=
        AppointmentRequestStatus.pendingCustomer) {
      return "È possibile inviare un sollecito solo alle richieste in attesa.";
    }

    if (_isExpired(request)) {
      return "La richiesta è scaduta.";
    }

    return null;
  }

  //--------------------------------------------------
  // SCADENZA
  //--------------------------------------------------

  bool _isExpired(
      AppointmentRequest request,
      ) {
    final expiresAt =
    request.payload["expiresAt"];

    if (expiresAt == null) {
      return false;
    }

    DateTime? expiration;

    if (expiresAt is DateTime) {
      expiration = expiresAt;
    } else if (expiresAt is String) {
      expiration =
          DateTime.tryParse(expiresAt);
    }

    if (expiration == null) {
      return false;
    }

    return DateTime.now().isAfter(
      expiration,
    );
  }
}