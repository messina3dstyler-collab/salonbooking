import 'package:flutter/foundation.dart';

import '../models/review_model.dart';
import '../services/review_service.dart';

class ReviewController extends ChangeNotifier {
  ReviewController(this._service);

  final ReviewService _service;

  List<ReviewModel> _reviews = [];

  bool _loading = false;

  String? _error;
  String? _salonId;

  String? _lastLoadType;
  String? _lastUserId;
  String? _lastEmployeeId;

  List<ReviewModel> get reviews => _reviews;

  bool get isLoading => _loading;

  String? get error => _error;

  double get averageRating =>
      _reviews.isEmpty
          ? 0
          : _reviews.fold<double>(
        0,
            (sum, review) => sum + review.rating,
      ) /
          _reviews.length;

  int get reviewCount => _reviews.length;

  void setSalonId(String salonId) {
    if (_salonId == salonId) return;

    _salonId = salonId;

    notifyListeners();
  }

  //==============================================================
  // LOAD ALL
  //==============================================================

  Future<void> loadReviews({
    required String salonId,
  }) async {
    if (salonId.isEmpty) return;

    _salonId = salonId;
    _lastLoadType = 'all';
    _error = null;

    _setLoading(true);

    try {
      _reviews = await _service.getReviews(
        salonId: salonId,
      );
    } catch (e, s) {
      _handleError(e, s);
    } finally {
      _setLoading(false);
    }
  }

  //==============================================================
  // LOAD USER
  //==============================================================

  Future<void> loadUserReviews({
    required String salonId,
    required String userId,
  }) async {
    if (salonId.isEmpty || userId.isEmpty) {
      return;
    }

    _salonId = salonId;
    _lastLoadType = 'user';
    _lastUserId = userId;
    _error = null;

    _setLoading(true);

    try {
      _reviews = await _service.getUserReviews(
        salonId: salonId,
        userId: userId,
      );
    } catch (e, s) {
      _handleError(e, s);
    } finally {
      _setLoading(false);
    }
  }

  //==============================================================
  // LOAD EMPLOYEE
  //==============================================================

  Future<void> loadEmployeeReviews({
    required String salonId,
    required String employeeId,
  }) async {
    if (salonId.isEmpty || employeeId.isEmpty) {
      return;
    }

    _salonId = salonId;
    _lastLoadType = 'employee';
    _lastEmployeeId = employeeId;
    _error = null;

    _setLoading(true);

    try {
      _reviews = await _service.getEmployeeReviews(
        salonId: salonId,
        employeeId: employeeId,
      );
    } catch (e, s) {
      _handleError(e, s);
    } finally {
      _setLoading(false);
    }
  }

  //==============================================================
  // REFRESH
  //==============================================================

  Future<void> refresh() async {
    if (_salonId == null || _salonId!.isEmpty) {
      return;
    }

    switch (_lastLoadType) {
      case 'user':
        if (_lastUserId != null) {
          await loadUserReviews(
            salonId: _salonId!,
            userId: _lastUserId!,
          );
        }
        break;

      case 'employee':
        if (_lastEmployeeId != null) {
          await loadEmployeeReviews(
            salonId: _salonId!,
            employeeId: _lastEmployeeId!,
          );
        }
        break;

      default:
        await loadReviews(
          salonId: _salonId!,
        );
    }
  }

  //==============================================================
  // CREATE
  //==============================================================

  Future<void> createReview({
    required ReviewModel review,
  }) async {
    try {
      await _service.createReview(
        salonId: review.salonId,
        review: review,
      );

      _salonId = review.salonId;

      await refresh();
    } catch (e, s) {
      _handleError(e, s);
      rethrow;
    }
  }

  //==============================================================
  // UPDATE
  //==============================================================

  Future<void> updateReview({
    required ReviewModel review,
  }) async {
    try {
      await _service.updateReview(
        salonId: review.salonId,
        review: review,
      );

      await refresh();
    } catch (e, s) {
      _handleError(e, s);
      rethrow;
    }
  }

  //==============================================================
  // DELETE
  //==============================================================

  Future<void> deleteReview({
    required String reviewId,
  }) async {
    if (_salonId == null) return;

    try {
      await _service.deleteReview(
        salonId: _salonId!,
        reviewId: reviewId,
      );

      await refresh();
    } catch (e, s) {
      _handleError(e, s);
      rethrow;
    }
  }

  //==============================================================
  // GET REVIEW APPOINTMENT
  //==============================================================

  Future<ReviewModel?> getAppointmentReview({
    required String salonId,
    required String appointmentId,
  }) {
    if (salonId.isEmpty) {
      return Future.value(null);
    }

    return _service.getAppointmentReview(
      salonId: salonId,
      appointmentId: appointmentId,
    );
  }

  Future<bool> hasReview({
    required String salonId,
    required String appointmentId,
  }) async {
    final review = await getAppointmentReview(
      salonId: salonId,
      appointmentId: appointmentId,
    );

    return review != null;
  }

  Future<List<ReviewModel>> getEmployeeReviews({
    required String salonId,
    required String employeeId,
  }) {
    return _service.getEmployeeReviews(
      salonId: salonId,
      employeeId: employeeId,
    );
  }

  Future<List<ReviewModel>> getUserReviews({
    required String salonId,
    required String userId,
  }) {
    return _service.getUserReviews(
      salonId: salonId,
      userId: userId,
    );
  }

  //==============================================================
  // CLEAR
  //==============================================================

  void clearReviews() {
    _reviews = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  //==============================================================
  // PRIVATE
  //==============================================================

  void _setLoading(bool value) {
    if (_loading == value) return;

    _loading = value;

    notifyListeners();
  }

  void _handleError(
      Object error,
      StackTrace stack,
      ) {
    _error = error.toString();

    debugPrint(
      'REVIEW ERROR: $error',
    );

    debugPrintStack(
      stackTrace: stack,
    );

    notifyListeners();
  }
}