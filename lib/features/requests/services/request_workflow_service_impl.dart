import '../datasource/appointment_request_datasource.dart';
import '../exceptions/request_validation_exception.dart';
import '../models/appointment_request.dart';
import '../models/request_timeline_event.dart';
import '../transactions/request_transaction_service.dart';
import '../validators/request_creation_validator.dart';
import '../validators/request_response_validator.dart';
import '../validators/request_state_validator.dart';
import '../../appointment/models/appointment_model.dart';
import '../../appointment/repositories/appointment_repository.dart';
import 'request_workflow_service.dart';

class RequestWorkflowServiceImpl implements RequestWorkflowService {
  RequestWorkflowServiceImpl({
    required AppointmentRequestDatasource datasource,
    required RequestTransactionService transaction,
    required AppointmentRepository appointmentRepository,
    RequestCreationValidator? creationValidator,
    RequestResponseValidator? responseValidator,
    RequestStateValidator? stateValidator,
  })  : _datasource = datasource,
        _transaction = transaction,
        _appointmentRepository = appointmentRepository,
        _creationValidator =
            creationValidator ?? const RequestCreationValidator(),
        _responseValidator =
            responseValidator ?? const RequestResponseValidator(),
        _stateValidator =
            stateValidator ?? const RequestStateValidator();

  final AppointmentRequestDatasource _datasource;
  final RequestTransactionService _transaction;
  final AppointmentRepository _appointmentRepository;
  final RequestCreationValidator _creationValidator;
  final RequestResponseValidator _responseValidator;
  final RequestStateValidator _stateValidator;

  //--------------------------------------------------
  // CREAZIONE
  //--------------------------------------------------

  @override
  Future<AppointmentRequest> createRescheduleRequest({
    required AppointmentRequest request,
  }) =>
      _create(request);

  @override
  Future<AppointmentRequest> createEmployeeChangeRequest({
    required AppointmentRequest request,
  }) =>
      _create(request);

  @override
  Future<AppointmentRequest> createServicesChangeRequest({
    required AppointmentRequest request,
  }) =>
      _create(request);

  @override
  Future<AppointmentRequest> createCancelRequest({
    required AppointmentRequest request,
  }) =>
      _create(request);

  @override
  Future<AppointmentRequest> createCustomRequest({
    required AppointmentRequest request,
  }) =>
      _create(request);

  Future<AppointmentRequest> _create(
      AppointmentRequest request,
      ) async {
    final creationError = _creationValidator.validate(
      request,
    );

    if (creationError != null) {
      throw RequestValidationException(
        creationError,
      );
    }

    final stateError = _stateValidator.validateCreation(
      request,
    );

    if (stateError != null) {
      throw RequestValidationException(
        stateError,
      );
    }

    await _transaction.createRequest(
      request: request,
    );

    return request;
  }

  //--------------------------------------------------
  // INVIO
  //--------------------------------------------------

  @override
  Future<void> sendRequest(
      String requestId,
      ) async {
    final request = await _loadRequest(
      requestId,
    );

    final stateError = _stateValidator.validateTransition(
      from: request.status,
      to: AppointmentRequestStatus.pendingCustomer,
    );

    if (stateError != null) {
      throw RequestValidationException(
        stateError,
      );
    }

    await _transaction.sendRequest(
      requestId: requestId,
    );
  }

  //--------------------------------------------------
  // ACCETTA
  //--------------------------------------------------

  @override
  Future<void> acceptRequest(
      String requestId,
      ) async {
    final request = await _loadRequest(
      requestId,
    );

    final stateError = _stateValidator.validateAccept(
      request,
    );

    if (stateError != null) {
      throw RequestValidationException(
        stateError,
      );
    }

    final responseError = _responseValidator.validateAccept(
      request,
    );

    if (responseError != null) {
      throw RequestValidationException(
        responseError,
      );
    }

    await _transaction.acceptRequest(
      requestId: requestId,
    );
  }

  //--------------------------------------------------
  // RIFIUTA
  //--------------------------------------------------

  @override
  Future<void> rejectRequest(
      String requestId,
      ) async {
    final request = await _loadRequest(
      requestId,
    );

    final stateError = _stateValidator.validateReject(
      request,
    );

    if (stateError != null) {
      throw RequestValidationException(
        stateError,
      );
    }

    final responseError = _responseValidator.validateReject(
      request,
    );

    if (responseError != null) {
      throw RequestValidationException(
        responseError,
      );
    }

    await _transaction.rejectRequest(
      requestId: requestId,
    );
  }

  //--------------------------------------------------
  // ANNULLA
  //--------------------------------------------------

  @override
  Future<void> cancelRequest(
      String requestId,
      ) async {
    final request = await _loadRequest(
      requestId,
    );

    final stateError = _stateValidator.validateTransition(
      from: request.status,
      to: AppointmentRequestStatus.cancelled,
    );

    if (stateError != null) {
      throw RequestValidationException(
        stateError,
      );
    }

    final responseError = _responseValidator.validateCancel(
      request,
    );

    if (responseError != null) {
      throw RequestValidationException(
        responseError,
      );
    }

    await _transaction.cancelRequest(
      requestId: requestId,
    );
  }

  //--------------------------------------------------
  // SCADENZA
  //--------------------------------------------------

  @override
  Future<void> expireRequest(
      String requestId,
      ) async {
    final request = await _loadRequest(
      requestId,
    );

    final stateError = _stateValidator.validateTransition(
      from: request.status,
      to: AppointmentRequestStatus.expired,
    );

    if (stateError != null) {
      throw RequestValidationException(
        stateError,
      );
    }

    if (request.status !=
        AppointmentRequestStatus.pendingCustomer) {
      throw const RequestValidationException(
        "È possibile far scadere solo una richiesta in attesa del cliente.",
      );
    }

    final expiresAt = request.payload["expiresAt"];

    if (expiresAt == null) {
      throw const RequestValidationException(
        "La richiesta non contiene una data di scadenza.",
      );
    }

    DateTime? expiration;

    if (expiresAt is DateTime) {
      expiration = expiresAt;
    } else if (expiresAt is String) {
      expiration = DateTime.tryParse(
        expiresAt,
      );
    }

    if (expiration == null) {
      throw const RequestValidationException(
        "La data di scadenza della richiesta non è valida.",
      );
    }

    if (!DateTime.now().isAfter(expiration)) {
      throw const RequestValidationException(
        "La richiesta non è ancora scaduta.",
      );
    }

    await _transaction.expireRequest(
      requestId: requestId,
    );
  }

  //--------------------------------------------------
  // SOLLECITO
  //--------------------------------------------------

  @override
  Future<void> remindCustomer(
      String requestId,
      ) async {
    final request = await _loadRequest(
      requestId,
    );

    final responseError = _responseValidator.validateReminder(
      request,
    );

    if (responseError != null) {
      throw RequestValidationException(
        responseError,
      );
    }

    await _transaction.remindCustomer(
      requestId: requestId,
    );
  }

  //--------------------------------------------------
  // LETTURA
  //--------------------------------------------------

  @override
  Future<AppointmentRequest?> getById(
      String requestId,
      ) {
    return _datasource.getById(
      requestId,
    );
  }

  @override
  Future<List<RequestTimelineEvent>> getTimeline(
      String requestId,
      ) {
    return _datasource.getTimeline(
      requestId,
    );
  }

  @override
  Stream<List<AppointmentRequest>> watchAppointmentRequests(
      String appointmentId,
      ) {
    return _datasource.watchAppointmentRequests(
      appointmentId,
    );
  }

  @override
  Stream<List<AppointmentRequest>> watchCustomerRequests(
      String customerId,
      ) {
    return _datasource.watchCustomerRequests(
      customerId,
    );
  }

  @override
  Stream<List<AppointmentRequest>> watchPendingRequests(
      String salonId,
      ) {
    return _datasource.watchPendingRequests(
      salonId,
    );
  }

  //--------------------------------------------------
  // VALIDAZIONI
  //--------------------------------------------------

  @override
  Future<bool> canCreateRequest(
      String appointmentId,
      ) async {
    if (appointmentId.trim().isEmpty) {
      return false;
    }

    try {
      final AppointmentModel? appointment =
      await _appointmentRepository.getAppointment(
        appointmentId: appointmentId,
      );

      if (appointment == null) {
        return false;
      }

      return appointment.isPending || appointment.isConfirmed;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> canAcceptRequest(
      String requestId,
      ) async {
    try {
      final request = await _loadRequest(
        requestId,
      );

      final stateError = _stateValidator.validateAccept(
        request,
      );

      if (stateError != null) {
        return false;
      }

      final responseError = _responseValidator.validateAccept(
        request,
      );

      return responseError == null;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> canRejectRequest(
      String requestId,
      ) async {
    try {
      final request = await _loadRequest(
        requestId,
      );

      final stateError = _stateValidator.validateReject(
        request,
      );

      if (stateError != null) {
        return false;
      }

      final responseError = _responseValidator.validateReject(
        request,
      );

      return responseError == null;
    } catch (_) {
      return false;
    }
  }

  //--------------------------------------------------
  // ARCHIVIAZIONE
  //--------------------------------------------------

  @override
  Future<void> archiveRequest(
      String requestId,
      ) async {
    final request = await _loadRequest(
      requestId,
    );

    if (!_stateValidator.canArchive(request)) {
      throw const RequestValidationException(
        "La richiesta non è ancora archiviabile.",
      );
    }

    await _transaction.archiveRequest(
      requestId: requestId,
    );
  }

  //--------------------------------------------------
  // LOAD
  //--------------------------------------------------

  Future<AppointmentRequest> _loadRequest(
      String requestId,
      ) async {
    final request = await _datasource.getById(
      requestId,
    );

    if (request == null) {
      throw const RequestValidationException(
        "Richiesta inesistente.",
      );
    }

    return request;
  }
}