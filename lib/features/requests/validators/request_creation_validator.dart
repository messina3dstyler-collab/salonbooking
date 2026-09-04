import '../models/appointment_request.dart';

class RequestCreationValidator {
  const RequestCreationValidator();

  String? validate(
      AppointmentRequest request,
      ) {
    //------------------------------------------
    // Richiesta già inviata
    //------------------------------------------

    if (request.status != AppointmentRequestStatus.draft) {
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
    final oldStart = request.payload["oldStart"];
    final newStart = request.payload["newStart"];

    if (oldStart == null || newStart == null) {
      return "L'orario non è valido.";
    }

    if (oldStart.toString().trim().isEmpty ||
        newStart.toString().trim().isEmpty) {
      return "L'orario non è valido.";
    }

    final oldEnd = request.payload["oldEnd"];
    final newEnd = request.payload["newEnd"];

    if (oldEnd == null || newEnd == null) {
      return "L'intervallo orario non è completo.";
    }

    if (oldEnd.toString().trim().isEmpty ||
        newEnd.toString().trim().isEmpty) {
      return "L'intervallo orario non è completo.";
    }

    final oldStartDate = DateTime.tryParse(
      oldStart.toString(),
    );

    final newStartDate = DateTime.tryParse(
      newStart.toString(),
    );

    final oldEndDate = DateTime.tryParse(
      oldEnd.toString(),
    );

    final newEndDate = DateTime.tryParse(
      newEnd.toString(),
    );

    if (oldStartDate == null ||
        newStartDate == null ||
        oldEndDate == null ||
        newEndDate == null) {
      return "L'intervallo orario non è valido.";
    }

    if (!oldEndDate.isAfter(oldStartDate)) {
      return "L'orario attuale non è valido.";
    }

    if (!newEndDate.isAfter(newStartDate)) {
      return "Il nuovo intervallo orario non è valido.";
    }

    final oldEmployeeId =
    request.payload["oldEmployeeId"];

    final newEmployeeId =
    request.payload["newEmployeeId"];

    if (oldEmployeeId == null ||
        newEmployeeId == null) {
      return "L'operatore della richiesta non è valido.";
    }

    if (oldEmployeeId.toString().trim().isEmpty ||
        newEmployeeId.toString().trim().isEmpty) {
      return "L'operatore della richiesta non è valido.";
    }

    return null;
  }

  //--------------------------------------------------
  // EMPLOYEE
  //--------------------------------------------------

  String? _validateEmployee(
      AppointmentRequest request,
      ) {
    final oldEmployeeId =
    request.payload["oldEmployeeId"];

    final newEmployeeId =
    request.payload["newEmployeeId"];

    if (oldEmployeeId == null ||
        newEmployeeId == null) {
      return "Operatore non valido.";
    }

    final oldId = oldEmployeeId.toString().trim();
    final newId = newEmployeeId.toString().trim();

    if (oldId.isEmpty || newId.isEmpty) {
      return "Operatore non valido.";
    }

    if (oldId == newId) {
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
    final oldServiceIds =
    request.payload["oldServiceIds"];

    final newServiceIds =
    request.payload["newServiceIds"];

    if (oldServiceIds is! List ||
        newServiceIds is! List) {
      return "I servizi della richiesta non sono validi.";
    }

    // L'AppointmentModel attuale supporta un solo
    // serviceId. Per questo il workflow Request ->
    // Appointment deve ricevere esattamente un servizio.
    if (oldServiceIds.length != 1 ||
        newServiceIds.length != 1) {
      return "La richiesta deve contenere un solo servizio.";
    }

    final oldServiceId =
    oldServiceIds.first.toString().trim();

    final newServiceId =
    newServiceIds.first.toString().trim();

    if (oldServiceId.isEmpty ||
        newServiceId.isEmpty) {
      return "Servizio non valido.";
    }

    if (oldServiceId == newServiceId) {
      return "Il nuovo servizio coincide con quello attuale.";
    }

    final oldServiceNames =
    request.payload["oldServiceNames"];

    final newServiceNames =
    request.payload["newServiceNames"];

    if (oldServiceNames is! List ||
        newServiceNames is! List) {
      return "I nomi dei servizi non sono validi.";
    }

    if (oldServiceNames.length != 1 ||
        newServiceNames.length != 1) {
      return "La richiesta deve contenere un solo servizio.";
    }

    final oldServiceName =
    oldServiceNames.first.toString().trim();

    final newServiceName =
    newServiceNames.first.toString().trim();

    if (oldServiceName.isEmpty ||
        newServiceName.isEmpty) {
      return "Il nome del servizio non è valido.";
    }

    final newDuration =
    request.payload["newDuration"];

    if (newDuration is! num ||
        newDuration <= 0) {
      return "La durata del nuovo servizio non è valida.";
    }

    final newTotalPrice =
    request.payload["newTotalPrice"];

    if (newTotalPrice is! num ||
        newTotalPrice < 0) {
      return "Il prezzo del nuovo servizio non è valido.";
    }

    return null;
  }

  //--------------------------------------------------
  // CANCEL
  //--------------------------------------------------

  String? _validateCancel(
      AppointmentRequest request,
      ) {
    final reason = request.payload["reason"];

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
    final title = request.payload["title"];

    if (title == null ||
        title.toString().trim().isEmpty) {
      return "Titolo mancante.";
    }

    return null;
  }
}