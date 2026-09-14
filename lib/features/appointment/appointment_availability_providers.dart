import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'repositories/appointment_availability_repository.dart';

final appointmentAvailabilityRepositoryProvider =
Provider<AppointmentAvailabilityRepository>((ref) {
  return AppointmentAvailabilityRepository(
    FirebaseFirestore.instance,
  );
});