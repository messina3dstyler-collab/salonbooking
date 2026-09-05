import 'package:cloud_firestore/cloud_firestore.dart';

import '../datasource/appointment_request_datasource.dart';
import '../mappers/appointment_request_mapper.dart';
import '../mappers/request_timeline_mapper.dart';
import '../models/appointment_request.dart';

import 'operations/accept_request_operation.dart';
import 'operations/archive_request_operation.dart';
import 'operations/cancel_request_operation.dart';
import 'operations/create_request_operation.dart';
import 'operations/expire_request_operation.dart';
import 'operations/reject_request_operation.dart';
import 'operations/reminder_request_operation.dart';
import 'operations/send_request_operation.dart';
import 'request_transaction_context.dart';
import 'request_transaction_service.dart';
import '../../appointment/services/appointment_request_service_base.dart';

class FirestoreRequestTransaction
    implements RequestTransactionService {
  FirestoreRequestTransaction({
    required AppointmentRequestDatasource datasource,
    FirebaseFirestore? firestore,
    AppointmentRequestMapper? requestMapper,
    RequestTimelineMapper? timelineMapper,
    required AppointmentRequestServiceBase
    appointmentRequestService,
  })  : _datasource = datasource,
        _firestore =
            firestore ?? FirebaseFirestore.instance,
        _requestMapper =
            requestMapper ??
                const AppointmentRequestMapper(),
        _timelineMapper =
            timelineMapper ??
                const RequestTimelineMapper(),
        _appointmentRequestService =
            appointmentRequestService;

  final FirebaseFirestore _firestore;

  final AppointmentRequestDatasource _datasource;

  final AppointmentRequestMapper _requestMapper;

  final RequestTimelineMapper _timelineMapper;

  final AppointmentRequestServiceBase
  _appointmentRequestService;

  //--------------------------------------------------
  // CONTEXT
  //--------------------------------------------------

  RequestTransactionContext _context(
      Transaction transaction,
      ) {
    return RequestTransactionContext(
      firestore: _firestore,
      transaction: transaction,
      datasource: _datasource,
      requestMapper: _requestMapper,
      timelineMapper: _timelineMapper,
      appointmentRequestService:
      _appointmentRequestService,
    );
  }

  //--------------------------------------------------
  // LOAD REQUEST
  //--------------------------------------------------

  Future<AppointmentRequest> _loadRequest(
      RequestTransactionContext context,
      String requestId,
      ) async {
    final snapshot =
    await context.loadRequest(
      requestId,
    );

    if (!snapshot.exists ||
        snapshot.data() == null) {
      throw StateError(
        "Request '$requestId' non trovata.",
      );
    }

    return _requestMapper.fromDocument(
      snapshot,
    );
  }

  //--------------------------------------------------
  // CREATE
  //--------------------------------------------------

  @override
  Future<void> createRequest({
    required AppointmentRequest request,
  }) async {
    await _firestore.runTransaction(
          (transaction) async {
        final context =
        _context(transaction);

        await CreateRequestOperation(
          context,
        ).execute(request);
      },
    );
  }

  //--------------------------------------------------
  // SEND
  //--------------------------------------------------

  @override
  Future<void> sendRequest({
    required String requestId,
  }) async {
    await _firestore.runTransaction(
          (transaction) async {
        final context =
        _context(transaction);

        final request =
        await _loadRequest(
          context,
          requestId,
        );

        await SendRequestOperation(
          context,
        ).execute(request);
      },
    );
  }

  //--------------------------------------------------
  // ACCEPT
  //--------------------------------------------------

  @override
  Future<void> acceptRequest({
    required String requestId,
  }) async {
    await _firestore.runTransaction(
          (transaction) async {
        final context =
        _context(transaction);

        final request =
        await _loadRequest(
          context,
          requestId,
        );

        await AcceptRequestOperation(
          context,
        ).execute(
          request,
        );
      },
    );
  }

  //--------------------------------------------------
  // REJECT
  //--------------------------------------------------

  @override
  Future<void> rejectRequest({
    required String requestId,
  }) async {
    await _firestore.runTransaction(
          (transaction) async {
        final context =
        _context(transaction);

        final request =
        await _loadRequest(
          context,
          requestId,
        );

        await RejectRequestOperation(
          context,
        ).execute(
          request,
        );
      },
    );
  }

  //--------------------------------------------------
  // CANCEL
  //--------------------------------------------------

  @override
  Future<void> cancelRequest({
    required String requestId,
  }) async {
    await _firestore.runTransaction(
          (transaction) async {
        final context =
        _context(transaction);

        final request =
        await _loadRequest(
          context,
          requestId,
        );

        await CancelRequestOperation(
          context,
        ).execute(
          request,
        );
      },
    );
  }

  //--------------------------------------------------
  // EXPIRE
  //--------------------------------------------------

  @override
  Future<void> expireRequest({
    required String requestId,
  }) async {
    await _firestore.runTransaction(
          (transaction) async {
        final context =
        _context(transaction);

        final request =
        await _loadRequest(
          context,
          requestId,
        );

        await ExpireRequestOperation(
          context,
        ).execute(
          request,
        );
      },
    );
  }

  //--------------------------------------------------
  // REMINDER
  //--------------------------------------------------

  @override
  Future<void> remindCustomer({
    required String requestId,
  }) async {
    await _firestore.runTransaction(
          (transaction) async {
        final context =
        _context(transaction);

        final request =
        await _loadRequest(
          context,
          requestId,
        );

        await ReminderRequestOperation(
          context,
        ).execute(
          request,
        );
      },
    );
  }

  //--------------------------------------------------
  // ARCHIVE
  //--------------------------------------------------

  @override
  Future<void> archiveRequest({
    required String requestId,
  }) async {
    await _firestore.runTransaction(
          (transaction) async {
        final context =
        _context(transaction);

        final request =
        await _loadRequest(
          context,
          requestId,
        );

        await ArchiveRequestOperation(
          context,
        ).execute(
          request,
        );
      },
    );
  }
}