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
  // ACCEPTED REQUEST REFERENCE
  //--------------------------------------------------

  Map<String, dynamic> _withAcceptedRequest(
      AppointmentRequest request,
      Map<String, dynamic> changes,
      ) {
    return {
      ...changes,
      'acceptedRequestId': request.id,
    };
  }

  //--------------------------------------------------
  // RESCHEDULE
  //--------------------------------------------------

  Future<void> _applyReschedule(
      AppointmentRequest request,
      Transaction transaction,
      ) async {
    final newStart = request.payload['newStart'];

    if (newStart == null) {
      throw StateError(
        "La Request '${request.id}' non contiene newStart.",
      );
    }

    final parsedStart = DateTime.tryParse(
      newStart.toString(),
    );

    if (parsedStart == null) {
      throw StateError(
        "newStart della Request '${request.id}' "
            "non è una data valida.",
      );
    }

    await _repository.patchAppointmentAtomically(
      appointmentId: request.appointmentId,
      transaction: transaction,
      changes: _withAcceptedRequest(
        request,
        {
          'date': Timestamp.fromDate(
            parsedStart,
          ),
        },
      ),
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
        request.payload['newEmployeeId'] ??
            request.payload['newEmployee'];

    if (employeeId == null ||
        employeeId.toString().trim().isEmpty) {
      throw StateError(
        "La Request '${request.id}' non contiene "
            "un nuovo employeeId.",
      );
    }

    await _repository.patchAppointmentAtomically(
      appointmentId: request.appointmentId,
      transaction: transaction,
      changes: _withAcceptedRequest(
        request,
        {
          'employeeId': employeeId.toString().trim(),
        },
      ),
    );
  }

  //--------------------------------------------------
  // SERVICES
  //--------------------------------------------------

  Future<void> _applyServicesChange(
      AppointmentRequest request,
      Transaction transaction,
      ) async {
    final payload = request.servicesPayload;

    if (payload.newServiceIds.length != 1) {
      throw StateError(
        "La Request '${request.id}' deve contenere "
            "esattamente un nuovo servizio.",
      );
    }

    if (payload.newDuration <= 0) {
      throw StateError(
        "La Request '${request.id}' contiene una "
            "durata non valida.",
      );
    }

    if (payload.newTotalPrice < 0) {
      throw StateError(
        "La Request '${request.id}' contiene un "
            "prezzo non valido.",
      );
    }

    final newServiceId =
    payload.newServiceIds.first.trim();

    if (newServiceId.isEmpty) {
      throw StateError(
        "La Request '${request.id}' non contiene "
            "un nuovo serviceId valido.",
      );
    }

    await _repository.patchAppointmentAtomically(
      appointmentId: request.appointmentId,
      transaction: transaction,
      changes: _withAcceptedRequest(
        request,
        {
          'serviceId': newServiceId,
          'duration': payload.newDuration,
          'serviceDuration': payload.newDuration,
          'price': payload.newTotalPrice,
        },
      ),
    );
  }

  //--------------------------------------------------
  // CANCEL
  //--------------------------------------------------

  Future<void> _applyCancellation(
      AppointmentRequest request,
      Transaction transaction,
      ) async {
    await _repository.patchAppointmentAtomically(
      appointmentId: request.appointmentId,
      transaction: transaction,
      changes: _withAcceptedRequest(
        request,
        {
          'status': 'Annullata',
        },
      ),
    );
  }

  //--------------------------------------------------
  // CUSTOM
  //--------------------------------------------------

  Future<void> _applyCustom(
      AppointmentRequest request,
      Transaction transaction,
      ) async {
    await _repository.patchAppointmentAtomically(
      appointmentId: request.appointmentId,
      transaction: transaction,
      changes: _withAcceptedRequest(
        request,
        const {},
      ),
    );
  }
}