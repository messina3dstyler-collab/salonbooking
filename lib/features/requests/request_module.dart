import 'package:cloud_firestore/cloud_firestore.dart';

import '../appointment/appointment_module.dart';
import 'datasource/firestore_request_datasource.dart';
import 'mappers/appointment_request_mapper.dart';
import 'mappers/request_timeline_mapper.dart';
import 'repository/appointment_request_repository.dart';
import 'repository/appointment_request_repository_impl.dart';
import 'services/request_workflow_service.dart';
import 'services/request_workflow_service_impl.dart';
import 'transactions/firestore_request_transaction.dart';
import 'transactions/request_transaction_service.dart';
import 'validators/request_creation_validator.dart';
import 'validators/request_response_validator.dart';
import 'validators/request_state_validator.dart';

class RequestModule {
  RequestModule._();

  //--------------------------------------------------
  // FIREBASE
  //--------------------------------------------------

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //--------------------------------------------------
  // MAPPERS
  //--------------------------------------------------

  static const AppointmentRequestMapper _requestMapper =
  AppointmentRequestMapper();

  static const RequestTimelineMapper _timelineMapper =
  RequestTimelineMapper();

  //--------------------------------------------------
  // VALIDATORS
  //--------------------------------------------------

  static const RequestCreationValidator _creationValidator =
  RequestCreationValidator();

  static const RequestResponseValidator _responseValidator =
  RequestResponseValidator();

  static const RequestStateValidator _stateValidator =
  RequestStateValidator();

  //--------------------------------------------------
  // DATASOURCE
  //--------------------------------------------------

  static final FirestoreRequestDatasource datasource =
  FirestoreRequestDatasource(
    firestore: _firestore,
    requestMapper: _requestMapper,
    timelineMapper: _timelineMapper,
  );

  //--------------------------------------------------
  // TRANSACTION
  //--------------------------------------------------

  static final RequestTransactionService transaction =
  FirestoreRequestTransaction(
    firestore: _firestore,
    datasource: datasource,
    requestMapper: _requestMapper,
    timelineMapper: _timelineMapper,
    appointmentRequestService:
    AppointmentModule.requestService,
  );

  //--------------------------------------------------
  // WORKFLOW
  //--------------------------------------------------

  static final RequestWorkflowService workflow =
  RequestWorkflowServiceImpl(
    datasource: datasource,
    transaction: transaction,
    appointmentRepository:
    AppointmentModule.repository,
    creationValidator:
    _creationValidator,
    responseValidator:
    _responseValidator,
    stateValidator:
    _stateValidator,
  );

  //--------------------------------------------------
  // REPOSITORY
  //--------------------------------------------------

  static final AppointmentRequestRepository repository =
  AppointmentRequestRepositoryImpl(
    workflow: workflow,
  );
}