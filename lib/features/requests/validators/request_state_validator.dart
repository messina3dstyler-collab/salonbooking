import '../models/appointment_request.dart';

class RequestStateValidator {
  const RequestStateValidator();

  // --------------------------------------------------
  // VALIDAZIONE CREAZIONE
  // --------------------------------------------------

  String? validateCreation(
      AppointmentRequest request,
      ) {
    if (request.status != AppointmentRequestStatus.draft) {
      return "Una nuova richiesta deve essere creata in stato Draft.";
    }

    if (request.isArchived) {
      return "Una nuova richiesta non può essere archiviata.";
    }

    return null;
  }

  // --------------------------------------------------
  // VALIDAZIONE CREAZIONE CANCELLAZIONE CLIENTE
  // --------------------------------------------------

  String? validateCustomerCancellationCreation(
      AppointmentRequest request,
      ) {
    if (request.isArchived) {
      return "Una nuova richiesta non può essere archiviata.";
    }

    if (request.createdBy != RequestAuthor.customer) {
      return "La richiesta di cancellazione deve essere creata dal cliente.";
    }

    if (request.type != AppointmentRequestType.cancelAppointment) {
      return "Il cliente può creare solamente richieste di cancellazione.";
    }

    if (request.status !=
        AppointmentRequestStatus.pendingSalon) {
      return "La richiesta di cancellazione deve essere in attesa del salone.";
    }

    return null;
  }

  // --------------------------------------------------
  // VALIDAZIONE ACCETTAZIONE
  // --------------------------------------------------

  String? validateAccept(
      AppointmentRequest request,
      ) {
    if (request.isArchived) {
      return "Una richiesta archiviata non può essere accettata.";
    }

    if (request.status ==
        AppointmentRequestStatus.pendingSalon &&
        request.type != AppointmentRequestType.cancelAppointment) {
      return "Solo una richiesta di cancellazione può essere accettata dal salone.";
    }

    return validateTransition(
      from: request.status,
      to: AppointmentRequestStatus.accepted,
    );
  }

  // --------------------------------------------------
  // VALIDAZIONE RIFIUTO
  // --------------------------------------------------

  String? validateReject(
      AppointmentRequest request,
      ) {
    if (request.isArchived) {
      return "Una richiesta archiviata non può essere rifiutata.";
    }

    if (request.status ==
        AppointmentRequestStatus.pendingSalon &&
        request.type != AppointmentRequestType.cancelAppointment) {
      return "Solo una richiesta di cancellazione può essere rifiutata dal salone.";
    }

    return validateTransition(
      from: request.status,
      to: AppointmentRequestStatus.rejected,
    );
  }

  // --------------------------------------------------
  // CAMBIO DI STATO
  // --------------------------------------------------

  String? validateTransition({
    required AppointmentRequestStatus from,
    required AppointmentRequestStatus to,
  }) {
    if (from == to) {
      return "La richiesta è già nello stato selezionato.";
    }

    switch (from) {
    // ------------------------------------------------
    // DRAFT
    // ------------------------------------------------

      case AppointmentRequestStatus.draft:
        switch (to) {
          case AppointmentRequestStatus.pendingCustomer:
          case AppointmentRequestStatus.cancelled:
            return null;

          default:
            return "Una bozza può essere solo inviata o annullata.";
        }

    // ------------------------------------------------
    // PENDING CUSTOMER
    // ------------------------------------------------

      case AppointmentRequestStatus.pendingCustomer:
        switch (to) {
          case AppointmentRequestStatus.accepted:
          case AppointmentRequestStatus.rejected:
          case AppointmentRequestStatus.expired:
          case AppointmentRequestStatus.cancelled:
            return null;

          default:
            return "Transizione non consentita.";
        }

    // ------------------------------------------------
    // PENDING SALON
    // ------------------------------------------------

      case AppointmentRequestStatus.pendingSalon:
        switch (to) {
          case AppointmentRequestStatus.accepted:
          case AppointmentRequestStatus.rejected:
            return null;

          default:
            return "Una richiesta in attesa del salone può essere solo accettata o rifiutata.";
        }

    // ------------------------------------------------
    // STATI FINALI
    // ------------------------------------------------

      case AppointmentRequestStatus.accepted:
        return "Una richiesta accettata è definitiva.";

      case AppointmentRequestStatus.rejected:
        return "Una richiesta rifiutata è definitiva.";

      case AppointmentRequestStatus.expired:
        return "Una richiesta scaduta non può cambiare stato.";

      case AppointmentRequestStatus.cancelled:
        return "Una richiesta annullata è definitiva.";
    }
  }

  // --------------------------------------------------
  // STATO FINALE
  // --------------------------------------------------

  bool isFinalState(
      AppointmentRequestStatus status,
      ) {
    switch (status) {
      case AppointmentRequestStatus.accepted:
      case AppointmentRequestStatus.rejected:
      case AppointmentRequestStatus.expired:
      case AppointmentRequestStatus.cancelled:
        return true;

      case AppointmentRequestStatus.draft:
      case AppointmentRequestStatus.pendingCustomer:
      case AppointmentRequestStatus.pendingSalon:
        return false;
    }
  }

  // --------------------------------------------------
  // MODIFICABILE
  // --------------------------------------------------

  bool canEdit(
      AppointmentRequest request,
      ) {
    return request.status == AppointmentRequestStatus.draft &&
        !request.isArchived;
  }

  // --------------------------------------------------
  // ELIMINABILE
  // --------------------------------------------------

  bool canDelete(
      AppointmentRequest request,
      ) {
    return request.status == AppointmentRequestStatus.draft &&
        !request.isArchived;
  }

  // --------------------------------------------------
  // ANNULLABILE
  // --------------------------------------------------

  bool canCancel(
      AppointmentRequest request,
      ) {
    if (request.isArchived) {
      return false;
    }

    switch (request.status) {
      case AppointmentRequestStatus.draft:
      case AppointmentRequestStatus.pendingCustomer:
        return true;

      default:
        return false;
    }
  }

  // --------------------------------------------------
  // RICHIEDE RISPOSTA CLIENTE
  // --------------------------------------------------

  bool requiresCustomerResponse(
      AppointmentRequest request,
      ) {
    return request.status ==
        AppointmentRequestStatus.pendingCustomer &&
        !request.isArchived;
  }

  // --------------------------------------------------
  // ARCHIVIABILE
  // --------------------------------------------------

  bool canArchive(
      AppointmentRequest request,
      ) {
    return isFinalState(request.status) &&
        !request.isArchived;
  }
}