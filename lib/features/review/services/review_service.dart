import '../models/review_model.dart';
import '../repositories/review_repository.dart';

class ReviewService {
  ReviewService(this._repository);

  final ReviewRepository _repository;

  //==============================================================
  // CREATE
  //==============================================================

  Future<void> createReview({
    required String salonId,
    required ReviewModel review,
  }) =>
      _repository.createReview(
        salonId: salonId,
        review: review,
      );

  //==============================================================
  // UPDATE
  //==============================================================

  Future<void> updateReview({
    required String salonId,
    required ReviewModel review,
  }) =>
      _repository.updateReview(
        salonId: salonId,
        review: review,
      );

  //==============================================================
  // DELETE
  //==============================================================

  Future<void> deleteReview({
    required String salonId,
    required String reviewId,
  }) =>
      _repository.deleteReview(
        salonId: salonId,
        reviewId: reviewId,
      );

  //==============================================================
  // GET
  //==============================================================

  Future<ReviewModel?> getReview({
    required String salonId,
    required String reviewId,
  }) =>
      _repository.getReview(
        salonId: salonId,
        reviewId: reviewId,
      );

  Future<ReviewModel?> getAppointmentReview({
    required String salonId,
    required String appointmentId,
  }) =>
      _repository.getAppointmentReview(
        salonId: salonId,
        appointmentId: appointmentId,
      );

  Future<List<ReviewModel>> getReviews({
    required String salonId,
  }) =>
      _repository.getReviews(
        salonId: salonId,
      );

  Stream<List<ReviewModel>> watchReviews({
    required String salonId,
  }) =>
      _repository.watchReviews(
        salonId: salonId,
      );

  Future<List<ReviewModel>> getEmployeeReviews({
    required String salonId,
    required String employeeId,
  }) =>
      _repository.getEmployeeReviews(
        salonId: salonId,
        employeeId: employeeId,
      );

  Future<List<ReviewModel>> getUserReviews({
    required String salonId,
    required String userId,
  }) =>
      _repository.getUserReviews(
        salonId: salonId,
        userId: userId,
      );

  //==============================================================
  // EMPLOYEE RATING
  //==============================================================

  Future<void> updateEmployeeRating({
    required String salonId,
    required String employeeId,
  }) =>
      _repository.updateEmployeeRating(
        salonId: salonId,
        employeeId: employeeId,
      );
}