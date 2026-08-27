import 'package:cloud_firestore/cloud_firestore.dart';

import '../../requests/models/appointment_request.dart';
import '../repositories/appointment_repository.dart';
import 'appointment_request_service_base.dart';

class AppointmentRequestService
    implements AppointmentRequestServiceBase {
  AppointmentRequestService(
      this._repository,
      );

  final AppointmentRepository _repository;

  //--------------------------------------------------
  // PUBLIC
  //--------------------------------------------------

  @override
  Future<void> applyAcceptedRequest({
    required AppointmentRequest request,
    required Transaction transaction,
  }) async {
    switch (request.type) {
      case AppointmentRequestType.reschedule:
        await _applyReschedule(
          request,
          transaction,
        );
        break;

      case AppointmentRequestType.changeEmployee:
        await _applyEmployeeChange(
          request,
          transaction,
        );
        break;

      case AppointmentRequestType.changeServices:
        await _applyServicesChange(
          request,
          transaction,
        );
        break;

      case AppointmentRequestType.cancelAppointment:
        await _applyCancellation(
          request,
          transaction,
        );
        break;

      case AppointmentRequestType.custom:
        await _applyCustom(
          request,
          transaction,
        );
        break;
    }
  }

  //--------------------------------------------------
  // RESCHEDULE
  //--------------------------------------------------

  Future<void> _applyReschedule(
      AppointmentRequest request,
      Transaction transaction,
      ) async {
    final newStart =
    request.payload["newStart"];

    if (newStart == null) {
      return;
    }

    await _repository.patchAppointment(
      appointmentId: request.appointmentId,
      transaction: transaction,
      changes: {
        "date": Timestamp.fromDate(
          DateTime.parse(
            newStart.toString(),
          ),
        ),
      },
    );
  }

  //--------------------------------------------------
  // EMPLOYEE
  //--------------------------------------------------

  Future<void> _applyEmployeeChange(
      AppointmentRequest request,
      Transaction transaction,
      ) async {
    final employeeId =
        request.payload["newEmployeeId"] ??
            request.payload["newEmployee"];

    if (employeeId == null) {
      return;
    }

    await _repository.patchAppointment(
      appointmentId: request.appointmentId,
      transaction: transaction,
      changes: {
        "employeeId": employeeId,
      },
    );
  }

  //--------------------------------------------------
  // SERVICES
  //--------------------------------------------------

  Future<void> _applyServicesChange(
      AppointmentRequest request,
      Transaction transaction,
      ) async {
    final serviceId =
        request.payload["newServiceId"] ??
            request.payload["serviceId"];

    if (serviceId == null) {
      return;
    }

    await _repository.patchAppointment(
      appointmentId: request.appointmentId,
      transaction: transaction,
      changes: {
        "serviceId": serviceId,
      },
    );
  }

  //--------------------------------------------------
  // CANCEL
  //--------------------------------------------------

  Future<void> _applyCancellation(
      AppointmentRequest request,
      Transaction transaction,
      ) async {
    await _repository.patchAppointment(
      appointmentId: request.appointmentId,
      transaction: transaction,
      changes: const {
        "status": "Annullata",
      },
    );
  }

  //--------------------------------------------------
  // CUSTOM
  //--------------------------------------------------

  Future<void> _applyCustom(
      AppointmentRequest request,
      Transaction transaction,
      ) async {
    // Estensione futura.
  }
}