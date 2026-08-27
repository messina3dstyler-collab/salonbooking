import '../models/appointment_request.dart';
import '../models/request_timeline_event.dart';

abstract class AppointmentRequestRepository {
  //--------------------------------------------------
  // CREAZIONE
  //--------------------------------------------------

  Future<AppointmentRequest> createRescheduleRequest(
      AppointmentRequest request,
      );

  Future<AppointmentRequest> createEmployeeChangeRequest(
      AppointmentRequest request,
      );

  Future<AppointmentRequest> createServicesChangeRequest(
      AppointmentRequest request,
      );

  Future<AppointmentRequest> createCancelRequest(
      AppointmentRequest request,
      );

  Future<AppointmentRequest> createCustomRequest(
      AppointmentRequest request,
      );

  //--------------------------------------------------
  // WORKFLOW
  //--------------------------------------------------

  Future<void> send(
      String requestId,
      );

  Future<void> accept(
      String requestId,
      );

  Future<void> reject(
      String requestId,
      );

  Future<void> cancel(
      String requestId,
      );

  Future<void> expire(
      String requestId,
      );

  Future<void> remindCustomer(
      String requestId,
      );

  //--------------------------------------------------
  // LETTURA
  //--------------------------------------------------

  Future<AppointmentRequest?> getById(
      String requestId,
      );

  Future<List<RequestTimelineEvent>>
  getTimeline(
      String requestId,
      );

  Stream<List<AppointmentRequest>>
  watchAppointmentRequests(
      String appointmentId,
      );

  Stream<List<AppointmentRequest>>
  watchCustomerRequests(
      String customerId,
      );

  Stream<List<AppointmentRequest>>
  watchPendingRequests(
      String salonId,
      );

  //--------------------------------------------------
  // MANUTENZIONE
  //--------------------------------------------------

  Future<void> archive(
      String requestId,
      );
}