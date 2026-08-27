import 'package:flutter/material.dart';

import '../../models/appointment_request.dart';

import 'cancel_payload.dart';
import 'change_employee_payload.dart';
import 'change_services_payload.dart';
import 'custom_payload.dart';
import 'reschedule_payload.dart';

class RequestPayloadBuilder {
  const RequestPayloadBuilder._();

  static Widget build(
      AppointmentRequest request,
      ) {
    switch (request.type) {
      case AppointmentRequestType.reschedule:
        return ReschedulePayload(
          payload: request.reschedulePayload,
        );

      case AppointmentRequestType.changeEmployee:
        return ChangeEmployeePayload(
          payload: request.employeePayload,
        );

      case AppointmentRequestType.changeServices:
        return ChangeServicesPayload(
          payload: request.servicesPayload,
        );

      case AppointmentRequestType.cancelAppointment:
        return CancelPayload(
          payload: request.cancelPayload,
        );

      case AppointmentRequestType.custom:
        return CustomPayload(
          payload: request.customPayload,
        );
    }
  }
}