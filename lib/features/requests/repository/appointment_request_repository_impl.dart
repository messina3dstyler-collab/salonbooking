import '../models/appointment_request.dart';
import '../models/request_timeline_event.dart';

import '../services/request_workflow_service.dart';

import 'appointment_request_repository.dart';

class AppointmentRequestRepositoryImpl
    implements AppointmentRequestRepository {
  AppointmentRequestRepositoryImpl({
    required RequestWorkflowService workflow,
  }) : _workflow = workflow;

  final RequestWorkflowService _workflow;

  //--------------------------------------------------
  // CREAZIONE
  //--------------------------------------------------

  @override
  Future<AppointmentRequest>
  createRescheduleRequest(
      AppointmentRequest request,
      ) {
    return _workflow.createRescheduleRequest(
      request: request,
    );
  }

  @override
  Future<AppointmentRequest>
  createEmployeeChangeRequest(
      AppointmentRequest request,
      ) {
    return _workflow
        .createEmployeeChangeRequest(
      request: request,
    );
  }

  @override
  Future<AppointmentRequest>
  createServicesChangeRequest(
      AppointmentRequest request,
      ) {
    return _workflow
        .createServicesChangeRequest(
      request: request,
    );
  }

  @override
  Future<AppointmentRequest>
  createCancelRequest(
      AppointmentRequest request,
      ) {
    return _workflow.createCancelRequest(
      request: request,
    );
  }

  @override
  Future<AppointmentRequest>
  createCustomRequest(
      AppointmentRequest request,
      ) {
    return _workflow.createCustomRequest(
      request: request,
    );
  }

  //--------------------------------------------------
  // WORKFLOW
  //--------------------------------------------------

  @override
  Future<void> send(
      String requestId,
      ) {
    return _workflow.sendRequest(
      requestId,
    );
  }

  @override
  Future<void> accept(
      String requestId,
      ) {
    return _workflow.acceptRequest(
      requestId,
    );
  }

  @override
  Future<void> reject(
      String requestId,
      ) {
    return _workflow.rejectRequest(
      requestId,
    );
  }

  @override
  Future<void> cancel(
      String requestId,
      ) {
    return _workflow.cancelRequest(
      requestId,
    );
  }

  @override
  Future<void> expire(
      String requestId,
      ) {
    return _workflow.expireRequest(
      requestId,
    );
  }

  @override
  Future<void> remindCustomer(
      String requestId,
      ) {
    return _workflow.remindCustomer(
      requestId,
    );
  }

  //--------------------------------------------------
  // LETTURA
  //--------------------------------------------------

  @override
  Future<AppointmentRequest?> getById(
      String requestId,
      ) {
    throw UnimplementedError();
  }

  @override
  Future<List<RequestTimelineEvent>>
  getTimeline(
      String requestId,
      ) {
    throw UnimplementedError();
  }

  @override
  Stream<List<AppointmentRequest>>
  watchAppointmentRequests(
      String appointmentId,
      ) {
    throw UnimplementedError();
  }

  @override
  Stream<List<AppointmentRequest>>
  watchCustomerRequests(
      String customerId,
      ) {
    throw UnimplementedError();
  }

  @override
  Stream<List<AppointmentRequest>>
  watchPendingRequests(
      String salonId,
      ) {
    throw UnimplementedError();
  }

  //--------------------------------------------------
  // MANUTENZIONE
  //--------------------------------------------------

  @override
  Future<void> archive(
      String requestId,
      ) {
    throw UnimplementedError();
  }
}