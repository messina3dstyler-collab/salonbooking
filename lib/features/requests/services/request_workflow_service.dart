import '../models/appointment_request.dart';

abstract class RequestWorkflowService {
  //--------------------------------------------------
  // CREAZIONE
  //--------------------------------------------------

  Future<AppointmentRequest> createRescheduleRequest({
    required AppointmentRequest request,
  });

  Future<AppointmentRequest> createEmployeeChangeRequest({
    required AppointmentRequest request,
  });

  Future<AppointmentRequest> createServicesChangeRequest({
    required AppointmentRequest request,
  });

  Future<AppointmentRequest> createCancelRequest({
    required AppointmentRequest request,
  });

  Future<AppointmentRequest> createCustomRequest({
    required AppointmentRequest request,
  });

  //--------------------------------------------------
  // INVIO
  //--------------------------------------------------

  Future<void> sendRequest(
      String requestId,
      );

  Future<void> remindCustomer(
      String requestId,
      );

  Future<void> cancelRequest(
      String requestId,
      );

  //--------------------------------------------------
  // RISPOSTA CLIENTE
  //--------------------------------------------------

  Future<void> acceptRequest(
      String requestId,
      );

  Future<void> rejectRequest(
      String requestId,
      );

  Future<void> expireRequest(
      String requestId,
      );

  //--------------------------------------------------
  // VALIDAZIONE
  //--------------------------------------------------

  Future<bool> canCreateRequest(
      String appointmentId,
      );

  Future<bool> canAcceptRequest(
      String requestId,
      );

  Future<bool> canRejectRequest(
      String requestId,
      );
}