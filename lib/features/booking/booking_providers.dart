import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../appointment/appointment_providers.dart';
import '../appointment/controller/appointment_controller.dart';
import 'controller/service_controller.dart';
import 'repositories/service_repository.dart';
import 'services/service_service.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>(
      (ref) => ServiceRepository(
    FirebaseFirestore.instance,
  ),
);

final serviceServiceProvider = Provider<ServiceService>(
      (ref) => ServiceService(
    ref.read(serviceRepositoryProvider),
  ),
);

final bookingServiceControllerProvider =
ChangeNotifierProvider<ServiceController>(
      (ref) => ServiceController(
    ref.read(serviceServiceProvider),
  ),
);

final bookingAppointmentControllerProvider =
ChangeNotifierProvider<AppointmentController>(
      (ref) => ref.read(appointmentControllerProvider),
);