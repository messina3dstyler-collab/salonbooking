import '../datasource/appointment_request_datasource.dart';
import '../exceptions/request_validation_exception.dart';
import '../models/appointment_request.dart';
import '../transactions/request_transaction_service.dart';
import '../validators/request_creation_validator.dart';
import '../validators/request_response_validator.dart';
import '../validators/request_state_validator.dart';
import 'request_workflow_service.dart';

class RequestWorkflowServiceImpl implements RequestWorkflowService {
  RequestWorkflowServiceImpl({
    required AppointmentRequestDatasource datasource,
    required RequestTransactionService transaction,
    RequestCreationValidator? creationValidator,
    RequestResponseValidator? responseValidator,
    RequestStateValidator? stateValidator,
  })  : _datasource = datasource,
        _transaction = transaction,
        _creationValidator =
            creationValidator ?? const RequestCreationValidator(),
        _responseValidator =
            responseValidator ?? const RequestResponseValidator(),
        _stateValidator =
            stateValidator ?? const RequestStateValidator();

  final AppointmentRequestDatasource _datasource;
  final RequestTransactionService _transaction;
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
    final creationError =
    _creationValidator.validate(
      request,
    );

    if (creationError != null) {
      throw RequestValidationException(
        creationError,
      );
    }

    final stateError =
    _stateValidator.validateCreation(
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
    final request =
    await _datasource.getById(
      requestId,
    );

    if (request == null) {
      throw const RequestValidationException(
        "Richiesta inesistente.",
      );
    }

    final stateError =
    _stateValidator.validateAccept(
      request,
    );

    if (stateError != null) {
      throw RequestValidationException(
        stateError,
      );
    }

    final responseError =
    _responseValidator.validateAccept(
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
    final request =
    await _datasource.getById(
      requestId,
    );

    if (request == null) {
      throw const RequestValidationException(
        "Richiesta inesistente.",
      );
    }

    final stateError =
    _stateValidator.validateReject(
      request,
    );

    if (stateError != null) {
      throw RequestValidationException(
        stateError,
      );
    }

    final responseError =
    _responseValidator.validateReject(
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
    await _transaction.remindCustomer(
      requestId: requestId,
    );
  }

  //--------------------------------------------------
  // VALIDAZIONI
  //--------------------------------------------------

  @override
  Future<bool> canCreateRequest(
      String appointmentId,
      ) async {
    return true;
  }

  @override
  Future<bool> canAcceptRequest(
      String requestId,
      ) async {
    return true;
  }

  @override
  Future<bool> canRejectRequest(
      String requestId,
      ) async {
    return true;
  }
}