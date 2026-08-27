import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/review_controller.dart';
import 'repositories/review_repository.dart';
import 'services/review_service.dart';


final reviewRepositoryProvider=
Provider<ReviewRepository>((ref){
  return ReviewRepository(
    FirebaseFirestore.instance,
  );
});


final reviewServiceProvider=
Provider<ReviewService>((ref){
  return ReviewService(
    ref.watch(reviewRepositoryProvider),
  );
});


final reviewControllerProvider=
ChangeNotifierProvider<ReviewController>((ref){
  return ReviewController(
    ref.watch(reviewServiceProvider),
  );
});