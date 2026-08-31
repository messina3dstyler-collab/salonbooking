import '../models/appointment_request.dart';

class RequestStateValidator {
  const RequestStateValidator();

  //--------------------------------------------------
  // VALIDAZIONE CREAZIONE
  //--------------------------------------------------

  String? validateCreation(
      AppointmentRequest request,
      ) {
    if (request.status != AppointmentRequestStatus.draft) {
      return "Una nuova richiesta deve essere creata in stato Draft.";
    }

    return null;
  }

  //--------------------------------------------------
  // VALIDAZIONE ACCETTAZIONE
  //--------------------------------------------------

  String? validateAccept(
      AppointmentRequest request,
      ) {
    return validateTransition(
      from: request.status,
      to: AppointmentRequestStatus.accepted,
    );
  }

  //--------------------------------------------------
  // VALIDAZIONE RIFIUTO
  //--------------------------------------------------

  String? validateReject(
      AppointmentRequest request,
      ) {
    return validateTransition(
      from: request.status,
      to: AppointmentRequestStatus.rejected,
    );
  }

  //--------------------------------------------------
  // CAMBIO DI STATO
  //--------------------------------------------------

  String? validateTransition({
    required AppointmentRequestStatus from,
    required AppointmentRequestStatus to,
  }) {
    if (from == to) {
      return "La richiesta è già nello stato selezionato.";
    }

    switch (from) {
    //------------------------------------------------
    // DRAFT
    //------------------------------------------------

      case AppointmentRequestStatus.draft:
        switch (to) {
          case AppointmentRequestStatus.pendingCustomer:
          case AppointmentRequestStatus.cancelled:
            return null;

          default:
            return "Una bozza può essere solo inviata o annullata.";
        }

    //------------------------------------------------
    // PENDING CUSTOMER
    //------------------------------------------------

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

    //------------------------------------------------
    // STATI FINALI
    //------------------------------------------------

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

  //--------------------------------------------------
  // STATO FINALE
  //--------------------------------------------------

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
        return false;
    }
  }

  //--------------------------------------------------
  // MODIFICABILE
  //--------------------------------------------------

  bool canEdit(
      AppointmentRequest request,
      ) {
    return request.status == AppointmentRequestStatus.draft;
  }

  //--------------------------------------------------
  // ELIMINABILE
  //--------------------------------------------------

  bool canDelete(
      AppointmentRequest request,
      ) {
    return request.status == AppointmentRequestStatus.draft;
  }

  //--------------------------------------------------
  // ANNULLABILE
  //--------------------------------------------------

  bool canCancel(
      AppointmentRequest request,
      ) {
    switch (request.status) {
      case AppointmentRequestStatus.draft:
      case AppointmentRequestStatus.pendingCustomer:
        return true;

      default:
        return false;
    }
  }

  //--------------------------------------------------
  // RICHIEDE RISPOSTA CLIENTE
  //--------------------------------------------------

  bool requiresCustomerResponse(
      AppointmentRequest request,
      ) {
    return request.status ==
        AppointmentRequestStatus.pendingCustomer;
  }

  //--------------------------------------------------
  // ARCHIVIABILE
  //--------------------------------------------------

  bool canArchive(
      AppointmentRequest request,
      ) {
    return isFinalState(
      request.status,
    );
  }
}