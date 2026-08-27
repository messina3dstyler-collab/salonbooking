import 'dart:async';

import 'package:flutter/material.dart';

import '../models/appointment_request.dart';
import '../models/request_timeline_event.dart';
import '../services/request_service.dart';

class RequestController extends ChangeNotifier {
  RequestController(this._service);

  final RequestService _service;

  List<AppointmentRequest> _requests = [];
  List<RequestTimelineEvent> _timeline = [];

  StreamSubscription<List<AppointmentRequest>>?
  _requestsSubscription;

  bool _isLoading = false;
  String? _error;

  List<AppointmentRequest> get requests => _requests;
  List<RequestTimelineEvent> get timeline => _timeline;

  bool get isLoading => _isLoading;

  String? get error => _error;

  bool get hasRequests => _requests.isNotEmpty;

  //--------------------------------------------------
  // CREAZIONE
  //--------------------------------------------------

  Future<void> createRescheduleRequest(
      AppointmentRequest request,
      ) =>
      _execute(() async {
        await _service.createRescheduleRequest(
          request: request,
        );
      });

  Future<void> createEmployeeChangeRequest(
      AppointmentRequest request,
      ) =>
      _execute(() async {
        await _service.createEmployeeChangeRequest(
          request: request,
        );
      });

  Future<void> createServicesChangeRequest(
      AppointmentRequest request,
      ) =>
      _execute(() async {
        await _service.createServicesChangeRequest(
          request: request,
        );
      });

  Future<void> createCancelRequest(
      AppointmentRequest request,
      ) =>
      _execute(() async {
        await _service.createCancelRequest(
          request: request,
        );
      });

  Future<void> createCustomRequest(
      AppointmentRequest request,
      ) =>
      _execute(() async {
        await _service.createCustomRequest(
          request: request,
        );
      });

  //--------------------------------------------------
  // WORKFLOW
  //--------------------------------------------------

  Future<void> send(String requestId) =>
      _execute(() => _service.send(
        requestId: requestId,
      ));

  Future<void> accept(String requestId) =>
      _execute(() => _service.accept(
        requestId: requestId,
      ));

  Future<void> reject(String requestId) =>
      _execute(() => _service.reject(
        requestId: requestId,
      ));

  Future<void> cancel(String requestId) =>
      _execute(() => _service.cancel(
        requestId: requestId,
      ));

  Future<void> expire(String requestId) =>
      _execute(() => _service.expire(
        requestId: requestId,
      ));

  Future<void> remindCustomer(
      String requestId,
      ) =>
      _execute(() => _service.remindCustomer(
        requestId: requestId,
      ));

  Future<void> archive(String requestId) =>
      _execute(() => _service.archive(
        requestId: requestId,
      ));

  //--------------------------------------------------
  // LETTURA
  //--------------------------------------------------

  Future<AppointmentRequest?> getById(
      String requestId,
      ) {
    return _service.getById(
      requestId: requestId,
    );
  }

  Future<void> loadTimeline(
      String requestId,
      ) =>
      _execute(() async {
        _timeline = await _service.getTimeline(
          requestId: requestId,
        );
      });

  //--------------------------------------------------
  // STREAM
  //--------------------------------------------------

  void bindAppointment(
      String appointmentId,
      ) {
    _bind(
      _service.watchAppointmentRequests(
        appointmentId: appointmentId,
      ),
    );
  }

  void bindCustomer(
      String customerId,
      ) {
    _bind(
      _service.watchCustomerRequests(
        customerId: customerId,
      ),
    );
  }

  void bindPending(
      String salonId,
      ) {
    _bind(
      _service.watchPendingRequests(
        salonId: salonId,
      ),
    );
  }

  void _bind(
      Stream<List<AppointmentRequest>> stream,
      ) {
    _requestsSubscription?.cancel();

    _requestsSubscription = stream.listen(
          (value) {
        _requests = value;
        notifyListeners();
      },
    );
  }

  //--------------------------------------------------
  // UTIL
  //--------------------------------------------------

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refreshTimeline(
      String requestId,
      ) =>
      loadTimeline(requestId);

  Future<void> _execute(
      Future<void> Function() action,
      ) async {
    _setLoading(true);
    _error = null;

    try {
      await action();
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(
      bool value,
      ) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _requestsSubscription?.cancel();
    super.dispose();
  }
}