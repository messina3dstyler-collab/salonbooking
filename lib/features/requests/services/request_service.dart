import '../models/appointment_request.dart';
import '../models/request_timeline_event.dart';
import '../repository/appointment_request_repository.dart';

class RequestService {
  RequestService(
      this._repository,
      );

  final AppointmentRequestRepository _repository;

  //--------------------------------------------------
  // CREAZIONE
  //--------------------------------------------------

  Future<AppointmentRequest> createRescheduleRequest({
    required AppointmentRequest request,
  }) =>
      _repository.createRescheduleRequest(
        request,
      );

  Future<AppointmentRequest> createEmployeeChangeRequest({
    required AppointmentRequest request,
  }) =>
      _repository.createEmployeeChangeRequest(
        request,
      );

  Future<AppointmentRequest> createServicesChangeRequest({
    required AppointmentRequest request,
  }) =>
      _repository.createServicesChangeRequest(
        request,
      );

  Future<AppointmentRequest> createCancelRequest({
    required AppointmentRequest request,
  }) =>
      _repository.createCancelRequest(
        request,
      );

  Future<AppointmentRequest> createCustomRequest({
    required AppointmentRequest request,
  }) =>
      _repository.createCustomRequest(
        request,
      );

  //--------------------------------------------------
  // WORKFLOW
  //--------------------------------------------------

  Future<void> send({
    required String requestId,
  }) =>
      _repository.send(
        requestId,
      );

  Future<void> accept({
    required String requestId,
  }) =>
      _repository.accept(
        requestId,
      );

  Future<void> reject({
    required String requestId,
  }) =>
      _repository.reject(
        requestId,
      );

  Future<void> cancel({
    required String requestId,
  }) =>
      _repository.cancel(
        requestId,
      );

  Future<void> expire({
    required String requestId,
  }) =>
      _repository.expire(
        requestId,
      );

  Future<void> remindCustomer({
    required String requestId,
  }) =>
      _repository.remindCustomer(
        requestId,
      );

  Future<void> archive({
    required String requestId,
  }) =>
      _repository.archive(
        requestId,
      );

  //--------------------------------------------------
  // LETTURA
  //--------------------------------------------------

  Future<AppointmentRequest?> getById({
    required String requestId,
  }) =>
      _repository.getById(
        requestId,
      );

  Future<List<RequestTimelineEvent>> getTimeline({
    required String requestId,
  }) =>
      _repository.getTimeline(
        requestId,
      );

  //--------------------------------------------------
  // STREAM
  //--------------------------------------------------

  Stream<List<AppointmentRequest>>
  watchAppointmentRequests({
    required String appointmentId,
  }) =>
      _repository.watchAppointmentRequests(
        appointmentId,
      );

  Stream<List<AppointmentRequest>>
  watchCustomerRequests({
    required String customerId,
  }) =>
      _repository.watchCustomerRequests(
        customerId,
      );

  Stream<List<AppointmentRequest>>
  watchPendingRequests({
    required String salonId,
  }) =>
      _repository.watchPendingRequests(
        salonId,
      );
}