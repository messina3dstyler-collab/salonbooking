import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/appointment_controller.dart';
import 'repositories/appointment_repository.dart';
import 'services/appointment_service.dart';

final appointmentRepositoryProvider=Provider<AppointmentRepository>((ref){
  return AppointmentRepository(
    FirebaseFirestore.instance,
  );
});

final appointmentServiceProvider=Provider<AppointmentService>((ref){
  return AppointmentService(
    ref.watch(appointmentRepositoryProvider),
  );
});

final appointmentControllerProvider=ChangeNotifierProvider<AppointmentController>((ref){
  return AppointmentController(
    ref.watch(appointmentServiceProvider),
  );
});