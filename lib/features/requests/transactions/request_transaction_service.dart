import '../models/appointment_request.dart';

abstract class RequestTransactionService {
  const RequestTransactionService();

  //--------------------------------------------------
  // CREAZIONE
  //--------------------------------------------------

  Future<void> createRequest({
    required AppointmentRequest request,
  });

  //--------------------------------------------------
  // INVIO
  //--------------------------------------------------

  Future<void> sendRequest({
    required String requestId,
  });

  //--------------------------------------------------
  // RISPOSTA CLIENTE
  //--------------------------------------------------

  Future<void> acceptRequest({
    required String requestId,
  });

  Future<void> rejectRequest({
    required String requestId,
  });

  //--------------------------------------------------
  // GESTIONE SALONE
  //--------------------------------------------------

  Future<void> cancelRequest({
    required String requestId,
  });

  Future<void> expireRequest({
    required String requestId,
  });

  Future<void> remindCustomer({
    required String requestId,
  });

  //--------------------------------------------------
  // MANUTENZIONE
  //--------------------------------------------------

  Future<void> archiveRequest({
    required String requestId,
  });
}