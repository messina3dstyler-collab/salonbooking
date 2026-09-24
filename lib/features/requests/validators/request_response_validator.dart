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
    // Deve essere in attesa di una risposta
    //------------------------------------------

    final isPendingCustomer =
        request.status ==
            AppointmentRequestStatus.pendingCustomer;

    final isPendingSalonCancellation =
        request.status ==
            AppointmentRequestStatus.pendingSalon &&
            request.type ==
                AppointmentRequestType.cancelAppointment;

    if (!isPendingCustomer &&
        !isPendingSalonCancellation) {
      return "La richiesta non è in uno stato che può essere accettato.";
    }

    //------------------------------------------
    // Richiesta già scaduta
    //------------------------------------------

    // Le richieste pendingSalon di cancellazione
    // non utilizzano il meccanismo expiresAt del
    // workflow salon -> customer.
    if (isPendingCustomer && _isExpired(request)) {
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
    // Deve essere in attesa di una risposta
    //------------------------------------------

    final isPendingCustomer =
        request.status ==
            AppointmentRequestStatus.pendingCustomer;

    final isPendingSalonCancellation =
        request.status ==
            AppointmentRequestStatus.pendingSalon &&
            request.type ==
                AppointmentRequestType.cancelAppointment;

    if (!isPendingCustomer &&
        !isPendingSalonCancellation) {
      return "La richiesta non è in uno stato che può essere rifiutato.";
    }

    //------------------------------------------
    // Richiesta già scaduta
    //------------------------------------------

    // Le richieste pendingSalon di cancellazione
    // non utilizzano il meccanismo expiresAt del
    // workflow salon -> customer.
    if (isPendingCustomer && _isExpired(request)) {
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

      case AppointmentRequestStatus.pendingSalon:
        return "Una richiesta di cancellazione del cliente non può essere annullata dal salone.";

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