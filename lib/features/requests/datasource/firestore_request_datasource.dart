import 'package:cloud_firestore/cloud_firestore.dart';

import '../mappers/appointment_request_mapper.dart';
import '../mappers/request_timeline_mapper.dart';
import '../models/appointment_request.dart';
import '../models/request_timeline_event.dart';

import 'appointment_request_datasource.dart';

class FirestoreRequestDatasource
    implements AppointmentRequestDatasource {
  FirestoreRequestDatasource({
    FirebaseFirestore? firestore,
    AppointmentRequestMapper? requestMapper,
    RequestTimelineMapper? timelineMapper,
  })  : _firestore =
      firestore ?? FirebaseFirestore.instance,
        _requestMapper =
            requestMapper ??
                const AppointmentRequestMapper(),
        _timelineMapper =
            timelineMapper ??
                const RequestTimelineMapper();

  final FirebaseFirestore _firestore;

  final AppointmentRequestMapper _requestMapper;

  final RequestTimelineMapper _timelineMapper;

  CollectionReference<Map<String, dynamic>>
  get _requests =>
      _firestore.collection(
        "appointment_requests",
      );

  CollectionReference<Map<String, dynamic>>
  _timeline(String requestId) =>
      _requests
          .doc(requestId)
          .collection("timeline");

  //--------------------------------------------------
  // REQUESTS
  //--------------------------------------------------

  @override
  Future<void> create(
      AppointmentRequest request,
      ) async {
    await _requests.doc(request.id).set(
      _requestMapper.toMap(request),
    );
  }

  @override
  Future<void> update(
      AppointmentRequest request,
      ) async {
    await _requests.doc(request.id).update(
      _requestMapper.toMap(request),
    );
  }

  @override
  Future<void> delete(
      String requestId,
      ) async {
    await _requests.doc(requestId).delete();
  }

  @override
  Future<AppointmentRequest?> getById(
      String requestId,
      ) async {
    final doc =
    await _requests.doc(requestId).get();

    if (!doc.exists) {
      return null;
    }

    return _requestMapper.fromMap(
      doc.data()!,
    );
  }

  //--------------------------------------------------
  // TIMELINE
  //--------------------------------------------------

  @override
  Future<void> addTimelineEvent(
      RequestTimelineEvent event,
      ) async {
    await _timeline(event.requestId)
        .doc(event.id)
        .set(
      _timelineMapper.toMap(event),
    );
  }

  @override
  Future<List<RequestTimelineEvent>>
  getTimeline(
      String requestId,
      ) async {
    final snapshot =
    await _timeline(requestId)
        .orderBy("createdAt")
        .get();

    return snapshot.docs
        .map(
          (doc) => _timelineMapper.fromMap(
        doc.data(),
      ),
    )
        .toList();
  }

  //--------------------------------------------------
  // STREAMS
  //--------------------------------------------------

  @override
  Stream<List<AppointmentRequest>>
  watchAppointmentRequests(
      String appointmentId,
      ) {
    return _requests
        .where(
      "appointmentId",
      isEqualTo: appointmentId,
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) =>
            _requestMapper.fromMap(
              doc.data(),
            ),
      )
          .toList(),
    );
  }

  @override
  Stream<List<AppointmentRequest>>
  watchCustomerRequests(
      String customerId,
      ) {
    return _requests
        .where(
      "customerId",
      isEqualTo: customerId,
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) =>
            _requestMapper.fromMap(
              doc.data(),
            ),
      )
          .toList(),
    );
  }

  @override
  Stream<List<AppointmentRequest>>
  watchSalonRequests(
      String salonId,
      ) {
    return _requests
        .where(
      "salonId",
      isEqualTo: salonId,
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) =>
            _requestMapper.fromMap(
              doc.data(),
            ),
      )
          .toList(),
    );
  }

  @override
  Stream<List<AppointmentRequest>>
  watchPendingRequests(
      String salonId,
      ) {
    return _requests
        .where(
      "salonId",
      isEqualTo: salonId,
    )
        .where(
      "status",
      isEqualTo:
      AppointmentRequestStatus
          .pendingCustomer
          .name,
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) =>
            _requestMapper.fromMap(
              doc.data(),
            ),
      )
          .toList(),
    );
  }
}