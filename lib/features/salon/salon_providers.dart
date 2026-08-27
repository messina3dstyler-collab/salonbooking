import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/salon_controller.dart';
import 'repositories/salon_repository.dart';
import 'services/salon_service.dart';

final salonRepositoryProvider = Provider<SalonRepository>(
  (ref) => SalonRepository(FirebaseFirestore.instance),
);

final salonServiceProvider = Provider<SalonService>(
  (ref) => SalonService(ref.read(salonRepositoryProvider)),
);

final salonControllerProvider = ChangeNotifierProvider<SalonController>(
  (ref) => SalonController(ref.read(salonServiceProvider)),
);
