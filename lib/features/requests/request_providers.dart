import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/request_controller.dart';
import 'repository/appointment_request_repository.dart';
import 'request_module.dart';
import 'services/request_service.dart';

final appointmentRequestRepositoryProvider =
Provider<AppointmentRequestRepository>(
      (ref) => RequestModule.repository,
);

final requestServiceProvider =
Provider<RequestService>(
      (ref) {
    return RequestService(
      ref.watch(
        appointmentRequestRepositoryProvider,
      ),
    );
  },
);

final requestControllerProvider =
ChangeNotifierProvider<RequestController>(
      (ref) {
    return RequestController(
      ref.watch(
        requestServiceProvider,
      ),
    );
  },
);