import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/home_user.dart';
import '../services/home_service.dart';

final homeServiceProvider = Provider<HomeService>((ref) => const HomeService());

final homeUserProvider = Provider<HomeUser>((ref) {
  return ref.read(homeServiceProvider).currentUser();
});
