import '../models/appointment_request.dart';

class RequestCreationValidator {
  const RequestCreationValidator();

  String? validate(
      AppointmentRequest request,
      ) {
    //------------------------------------------
    // Richiesta già inviata
    //------------------------------------------

    if (request.status !=
        AppointmentRequestStatus.draft) {
      return "La richiesta non è più modificabile.";
    }

    //------------------------------------------
    // Payload vuoto
    //------------------------------------------

    if (request.payload.isEmpty) {
      return "La richiesta non contiene modifiche.";
    }

    //------------------------------------------
    // Controlli specifici
    //------------------------------------------

    switch (request.type) {
      case AppointmentRequestType.reschedule:
        return _validateReschedule(
          request,
        );

      case AppointmentRequestType.changeEmployee:
        return _validateEmployee(
          request,
        );

      case AppointmentRequestType.changeServices:
        return _validateServices(
          request,
        );

      case AppointmentRequestType.cancelAppointment:
        return _validateCancel(
          request,
        );

      case AppointmentRequestType.custom:
        return _validateCustom(
          request,
        );
    }
  }

  //--------------------------------------------------
  // RESCHEDULE
  //--------------------------------------------------

  String? _validateReschedule(
      AppointmentRequest request,
      ) {
    final oldStart =
    request.payload["oldStart"];

    final newStart =
    request.payload["newStart"];

    if (oldStart == null ||
        newStart == null) {
      return "L'orario non è valido.";
    }

    return null;
  }

  //--------------------------------------------------
  // EMPLOYEE
  //--------------------------------------------------

  String? _validateEmployee(
      AppointmentRequest request,
      ) {
    final oldEmployee =
    request.payload["oldEmployee"];

    final newEmployee =
    request.payload["newEmployee"];

    if (oldEmployee == null ||
        newEmployee == null) {
      return "Operatore non valido.";
    }

    if (oldEmployee == newEmployee) {
      return "Il nuovo operatore coincide con quello attuale.";
    }

    return null;
  }

  //--------------------------------------------------
  // SERVICES
  //--------------------------------------------------

  String? _validateServices(
      AppointmentRequest request,
      ) {
    final services =
    request.payload["newServices"];

    if (services == null) {
      return "Nessun servizio selezionato.";
    }

    return null;
  }

  //--------------------------------------------------
  // CANCEL
  //--------------------------------------------------

  String? _validateCancel(
      AppointmentRequest request,
      ) {
    final reason =
    request.payload["reason"];

    if (reason == null ||
        reason.toString().trim().isEmpty) {
      return "Specificare il motivo della cancellazione.";
    }

    return null;
  }

  //--------------------------------------------------
  // CUSTOM
  //--------------------------------------------------

  String? _validateCustom(
      AppointmentRequest request,
      ) {
    final title =
    request.payload["title"];

    if (title == null ||
        title.toString().trim().isEmpty) {
      return "Titolo mancante.";
    }

    return null;
  }
}