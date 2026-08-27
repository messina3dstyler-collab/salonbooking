import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review_model.dart';

class ReviewRepository {
  ReviewRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _reviews(
      String salonId,
      ) =>
      _firestore
          .collection('salons')
          .doc(salonId)
          .collection('reviews');

  CollectionReference<Map<String, dynamic>> _appointments() =>
      _firestore.collection('appointments');

  CollectionReference<Map<String, dynamic>> _employees(
      String salonId,
      ) =>
      _firestore
          .collection('salons')
          .doc(salonId)
          .collection('employees');

  CollectionReference<Map<String, dynamic>> _users() =>
      _firestore.collection('users');

  //==============================================================
  // MAP
  //==============================================================

  Future<ReviewModel> _map(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) async {
    final review = ReviewModel.fromMap(
      doc.id,
      doc.data()!,
    );

    if (review.userName.isNotEmpty) {
      return review;
    }

    try {
      final userDoc =
      await _users().doc(review.userId).get();

      if (!userDoc.exists) {
        return review;
      }

      final data = userDoc.data()!;

      return review.copyWith(
        userName: data['name']?.toString() ?? '',
      );
    } catch (_) {
      return review;
    }
  }

  Future<List<ReviewModel>> _list(
      QuerySnapshot<Map<String, dynamic>> snap,
      ) async {
    final list = <ReviewModel>[];

    for (final doc in snap.docs) {
      list.add(await _map(doc));
    }

    return list;
  }

  //==============================================================
  // CREATE
  //==============================================================

  Future<void> createReview({
    required String salonId,
    required ReviewModel review,
  }) async {
    final batch = _firestore.batch();

    batch.set(
      _reviews(salonId).doc(review.id),
      review.toMap(),
      SetOptions(
        merge: true,
      ),
    );

    batch.set(
      _appointments().doc(review.appointmentId),
      {
        'reviewId': review.id,
        'hasReview': true,
        'updatedAt': Timestamp.now(),
      },
      SetOptions(
        merge: true,
      ),
    );

    await batch.commit();

    await _refreshRating(
      salonId,
      review.employeeId,
    );
  }

  //==============================================================
  // UPDATE
  //==============================================================

  Future<void> updateReview({
    required String salonId,
    required ReviewModel review,
  }) async {
    await _reviews(salonId).doc(review.id).set(
      review.toMap(),
      SetOptions(
        merge: true,
      ),
    );

    await _refreshRating(
      salonId,
      review.employeeId,
    );
  }

  //==============================================================
  // DELETE
  //==============================================================

  Future<void> deleteReview({
    required String salonId,
    required String reviewId,
  }) async {
    final review = await getReview(
      salonId: salonId,
      reviewId: reviewId,
    );

    final batch = _firestore.batch();

    batch.delete(
      _reviews(salonId).doc(reviewId),
    );

    if (review != null) {
      batch.set(
        _appointments().doc(review.appointmentId),
        {
          'reviewId': null,
          'hasReview': false,
          'updatedAt': Timestamp.now(),
        },
        SetOptions(
          merge: true,
        ),
      );
    }

    await batch.commit();

    await _refreshRating(
      salonId,
      review?.employeeId,
    );
  }

  //==============================================================
  // GET
  //==============================================================

  Future<ReviewModel?> getReview({
    required String salonId,
    required String reviewId,
  }) async {
    final doc =
    await _reviews(salonId).doc(reviewId).get();

    if (!doc.exists) {
      return null;
    }

    return await _map(doc);
  }

  Future<ReviewModel?> getAppointmentReview({
    required String salonId,
    required String appointmentId,
  }) async {
    final snap = await _reviews(salonId)
        .where(
      'appointmentId',
      isEqualTo: appointmentId,
    )
        .limit(1)
        .get();

    if (snap.docs.isEmpty) {
      return null;
    }

    return await _map(
      snap.docs.first,
    );
  }

  Future<List<ReviewModel>> getReviews({
    required String salonId,
  }) async {
    final snap = await _reviews(salonId)
        .orderBy(
      'createdAt',
      descending: true,
    )
        .get();

    return _list(snap);
  }

  Stream<List<ReviewModel>> watchReviews({
    required String salonId,
  }) {
    return _reviews(salonId)
        .orderBy(
      'createdAt',
      descending: true,
    )
        .snapshots()
        .asyncMap(_list);
  }

  Future<List<ReviewModel>> getEmployeeReviews({
    required String salonId,
    required String employeeId,
  }) async {
    final snap = await _reviews(salonId)
        .where(
      'employeeId',
      isEqualTo: employeeId,
    )
        .orderBy(
      'createdAt',
      descending: true,
    )
        .get();

    return _list(snap);
  }

  Future<List<ReviewModel>> getUserReviews({
    required String salonId,
    required String userId,
  }) async {
    final snap = await _reviews(salonId)
        .where(
      'userId',
      isEqualTo: userId,
    )
        .orderBy(
      'createdAt',
      descending: true,
    )
        .get();

    return _list(snap);
  }

  //==============================================================
  // RATING DIPENDENTE
  //==============================================================

  Future<void> updateEmployeeRating({
    required String salonId,
    required String employeeId,
  }) async {
    final snap = await _reviews(salonId)
        .where(
      'employeeId',
      isEqualTo: employeeId,
    )
        .get();

    double rating = 0;

    if (snap.docs.isNotEmpty) {
      final total = snap.docs.fold<double>(
        0,
            (totalRating, doc) {
          final value = doc.data()['rating'];

          if (value is num) {
            return totalRating + value.toDouble();
          }

          return totalRating;
        },
      );

      rating = total / snap.docs.length;
    }

    await _employees(salonId).doc(employeeId).set(
      {
        'rating': rating,
        'reviewCount': snap.docs.length,
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void> _refreshRating(
      String salonId,
      String? employeeId,
      ) async {
    if (employeeId == null || employeeId.isEmpty) {
      return;
    }

    await updateEmployeeRating(
      salonId: salonId,
      employeeId: employeeId,
    );
  }
}