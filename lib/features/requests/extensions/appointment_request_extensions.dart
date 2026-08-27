import '../models/appointment_request.dart';

import '../models/payloads/appointment_request_payload.dart';
import '../models/payloads/cancel_request_payload.dart';
import '../models/payloads/custom_request_payload.dart';
import '../models/payloads/employee_request_payload.dart';
import '../models/payloads/reschedule_request_payload.dart';
import '../models/payloads/services_request_payload.dart';

extension AppointmentRequestTypeExtension on AppointmentRequest {
  bool get isReschedule =>
      type == AppointmentRequestType.reschedule;

  bool get isEmployeeChange =>
      type == AppointmentRequestType.changeEmployee;

  bool get isServicesChange =>
      type == AppointmentRequestType.changeServices;

  bool get isCancellation =>
      type == AppointmentRequestType.cancelAppointment;

  bool get isCustom =>
      type == AppointmentRequestType.custom;
}

extension AppointmentRequestStatusExtension on AppointmentRequest {
  bool get isDraft =>
      status == AppointmentRequestStatus.draft;

  bool get isPending =>
      status == AppointmentRequestStatus.pendingCustomer;

  bool get isAccepted =>
      status == AppointmentRequestStatus.accepted;

  bool get isRejected =>
      status == AppointmentRequestStatus.rejected;

  bool get isExpired =>
      status == AppointmentRequestStatus.expired;

  bool get isCancelled =>
      status == AppointmentRequestStatus.cancelled;

  bool get isClosed =>
      isAccepted ||
          isRejected ||
          isExpired ||
          isCancelled;
}

extension AppointmentRequestAuthorExtension on AppointmentRequest {
  bool get createdByAdmin =>
      createdBy == RequestAuthor.admin;

  bool get createdByEmployee =>
      createdBy == RequestAuthor.employee;

  bool get createdByCustomer =>
      createdBy == RequestAuthor.customer;

  bool get createdBySystem =>
      createdBy == RequestAuthor.system;
}

extension AppointmentRequestPriorityExtension on AppointmentRequest {
  bool get isLowPriority =>
      priority == RequestPriority.low;

  bool get isNormalPriority =>
      priority == RequestPriority.normal;

  bool get isHighPriority =>
      priority == RequestPriority.high;

  bool get isUrgentPriority =>
      priority == RequestPriority.urgent;
}

extension AppointmentRequestPayloadExtension on AppointmentRequest {
  bool get hasPayload => payload.isNotEmpty;

  AppointmentRequestPayload get payloadObject {
    switch (type) {
      case AppointmentRequestType.reschedule:
        return RescheduleRequestPayload.fromMap(payload);

      case AppointmentRequestType.changeEmployee:
        return EmployeeRequestPayload.fromMap(payload);

      case AppointmentRequestType.changeServices:
        return ServicesRequestPayload.fromMap(payload);

      case AppointmentRequestType.cancelAppointment:
        return CancelRequestPayload.fromMap(payload);

      case AppointmentRequestType.custom:
        return CustomRequestPayload.fromMap(payload);
    }
  }

  RescheduleRequestPayload get reschedulePayload =>
      payloadObject as RescheduleRequestPayload;

  EmployeeRequestPayload get employeePayload =>
      payloadObject as EmployeeRequestPayload;

  ServicesRequestPayload get servicesPayload =>
      payloadObject as ServicesRequestPayload;

  CancelRequestPayload get cancelPayload =>
      payloadObject as CancelRequestPayload;

  CustomRequestPayload get customPayload =>
      payloadObject as CustomRequestPayload;

  T payloadAs<T extends AppointmentRequestPayload>() {
    return payloadObject as T;
  }
}