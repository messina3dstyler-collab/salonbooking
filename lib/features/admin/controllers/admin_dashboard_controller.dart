import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/admin_dashboard_model.dart';
import '../services/admin_dashboard_service.dart';

class AdminDashboardController extends ChangeNotifier {
  AdminDashboardController(this._service);

  final AdminDashboardService _service;

  StreamSubscription<AdminDashboardModel>? _dashboardSubscription;

  bool _isLoading = false;
  String? _error;
  String? _salonId;
  int _requestId = 0;

  AdminDashboardModel _dashboard = AdminDashboardModel.empty();

  bool get isLoading => _isLoading;

  String? get error => _error;

  String? get salonId => _salonId;

  AdminDashboardModel get dashboard => _dashboard;

  Future<void> loadDashboard({
    required String salonId,
  }) async {
    if (_isLoading && _salonId == salonId) {
      return;
    }

    final currentRequestId = ++_requestId;

    _dashboardSubscription?.cancel();
    _dashboardSubscription = null;

    _salonId = salonId;
    _error = null;
    _setLoading(true);

    try {
      final dashboard = await _service.getDashboard(
        salonId: salonId,
      );

      if (currentRequestId != _requestId) {
        return;
      }

      _dashboard = dashboard;

      _startDashboardListener(
        salonId: salonId,
        requestId: currentRequestId,
      );
    } catch (error, stackTrace) {
      if (currentRequestId != _requestId) {
        return;
      }

      _setError(
        error,
        stackTrace,
      );
    } finally {
      if (currentRequestId == _requestId) {
        _setLoading(false);
      }
    }
  }

  Future<void> refresh() async {
    final salonId = _salonId;

    if (salonId == null || salonId.isEmpty) {
      return;
    }

    await loadDashboard(
      salonId: salonId,
    );
  }

  void clear() {
    _requestId++;

    _dashboardSubscription?.cancel();
    _dashboardSubscription = null;

    _dashboard = AdminDashboardModel.empty();
    _isLoading = false;
    _error = null;
    _salonId = null;

    notifyListeners();
  }

  void clearError() {
    if (_error == null) {
      return;
    }

    _error = null;
    notifyListeners();
  }

  void _startDashboardListener({
    required String salonId,
    required int requestId,
  }) {
    _dashboardSubscription = _service.watchDashboard(
      salonId: salonId,
    ).listen(
          (dashboard) {
        if (requestId != _requestId || salonId != _salonId) {
          return;
        }

        _dashboard = dashboard;
        _error = null;

        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        if (requestId != _requestId || salonId != _salonId) {
          return;
        }

        _setError(
          error,
          stackTrace,
        );
      },
    );
  }

  void _setError(
      Object error,
      StackTrace stackTrace,
      ) {
    _error = error.toString();

    debugPrint(
      'ADMIN DASHBOARD ERROR: $error',
    );

    debugPrintStack(
      stackTrace: stackTrace,
    );

    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _dashboardSubscription?.cancel();
    super.dispose();
  }
}