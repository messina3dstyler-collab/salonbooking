import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories/user_repository.dart';
import 'services/user_service.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(FirebaseFirestore.instance),
);

final userServiceProvider = Provider<UserService>(
  (ref) => UserService(ref.read(userRepositoryProvider)),
);
