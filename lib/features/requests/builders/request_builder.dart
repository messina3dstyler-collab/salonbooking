import 'package:uuid/uuid.dart';

import '../../appointment/models/appointment_model.dart';

import '../models/appointment_request.dart';

import '../models/payloads/reschedule_request_payload.dart';
import '../models/payloads/employee_request_payload.dart';
import '../models/payloads/services_request_payload.dart';
import '../models/payloads/cancel_request_payload.dart';
import '../models/payloads/custom_request_payload.dart';

class RequestBuilder {
  RequestBuilder._(
    this._appointment,
  );

  static const Uuid _uuid = Uuid();

  final AppointmentModel _appointment;

  //--------------------------------------------------
  // FACTORY
  //--------------------------------------------------

  static RequestBuilder fromAppointment(
    AppointmentModel appointment,
  ) {
    return RequestBuilder._(
      appointment,
    );
  }

  //--------------------------------------------------
  // HELPERS
  //--------------------------------------------------

  DateTime get _start =>
      _appointment.appointmentDate;

  DateTime get _end => _start.add(
        Duration(
          minutes: _appointment.duration,
        ),
      );

  //--------------------------------------------------
  // RESCHEDULE
  //--------------------------------------------------

  AppointmentRequest reschedule({
    required DateTime newStart,
    required DateTime newEnd,
    String? message,
    RequestPriority priority =
        RequestPriority.normal,
  }) {
    final payload =
        RescheduleRequestPayload(
      oldStart: _start,
      newStart: newStart,

      oldEnd: _end,
      newEnd: newEnd,

      oldEmployeeId:
          _appointment.employeeId,

      newEmployeeId:
          _appointment.employeeId,

      message: message,
    );

    return _build(
      type:
          AppointmentRequestType
              .reschedule,
      priority: priority,
      payload: payload.toMap(),
    );
  }

  //--------------------------------------------------
  // CHANGE EMPLOYEE
  //--------------------------------------------------

  AppointmentRequest changeEmployee({
    required String employeeId,
    required String employeeName,
    String? message,
    RequestPriority priority =
        RequestPriority.normal,
  }) {
    final payload =
        EmployeeRequestPayload(
      oldEmployeeId:
          _appointment.employeeId,

      newEmployeeId: employeeId,

      oldEmployeeName:
          _appointment.employeeName,

      newEmployeeName:
          employeeName,

      appointmentStart: _start,

      appointmentEnd: _end,

      serviceId:
          _appointment.serviceId,

      serviceName:
          _appointment.serviceName,

      employeeAvailable: true,

      message: message,
    );

    return _build(
      type:
          AppointmentRequestType
              .changeEmployee,
      priority: priority,
      payload: payload.toMap(),
    );
  }

  //--------------------------------------------------
  // CHANGE SERVICES
  //--------------------------------------------------
  AppointmentRequest changeServices({
    required List<String> serviceIds,
    required List<String> serviceNames,
    required double newTotalPrice,
    required int newDuration,
    String? message,
    RequestPriority priority =
        RequestPriority.normal,
  }) {
    final payload =
        ServicesRequestPayload(
      oldServiceIds: [
        _appointment.serviceId,
      ],

      newServiceIds: serviceIds,

      oldServiceNames: [
        _appointment.serviceName,
      ],

      newServiceNames: serviceNames,

      oldTotalPrice:
          _appointment.price,

      newTotalPrice:
          newTotalPrice,

      oldDuration:
          _appointment.duration,

      newDuration:
          newDuration,

      employeeId:
          _appointment.employeeId,

      employeeName:
          _appointment.employeeName,

      message: message,
    );

    return _build(
      type:
          AppointmentRequestType
              .changeServices,
      priority: priority,
      payload: payload.toMap(),
    );
  }

  //--------------------------------------------------
  // CANCEL
  //--------------------------------------------------

  AppointmentRequest cancel({
    required String reason,
    String? message,
    bool refund = false,
    RequestPriority priority =
        RequestPriority.high,
  }) {
    final payload =
        CancelRequestPayload(
      appointmentStart: _start,

      appointmentEnd: _end,

      employeeId:
          _appointment.employeeId,

      employeeName:
          _appointment.employeeName,

      serviceId:
          _appointment.serviceId,

      serviceName:
          _appointment.serviceName,

      price:
          _appointment.price,

      reason: reason,

      message: message,

      refund: refund,
    );

    return _build(
      type:
          AppointmentRequestType
              .cancelAppointment,
      priority: priority,
      payload: payload.toMap(),
    );
  }

  //--------------------------------------------------
  // CUSTOM
  //--------------------------------------------------

  AppointmentRequest custom({
    required String title,
    required String message,
    Map<String, dynamic> data =
        const {},
    RequestPriority priority =
        RequestPriority.normal,
  }) {
    final payload =
        CustomRequestPayload(
      title: title,

      message: message,

      data: data,

      appointmentStart: _start,

      appointmentEnd: _end,

      employeeId:
          _appointment.employeeId,

      employeeName:
          _appointment.employeeName,

      serviceId:
          _appointment.serviceId,

      serviceName:
          _appointment.serviceName,
    );

    return _build(
      type:
          AppointmentRequestType
              .custom,
      priority: priority,
      payload: payload.toMap(),
    );
  }

  //--------------------------------------------------
  // CORE
  //--------------------------------------------------

  AppointmentRequest _build({
    required AppointmentRequestType
        type,
    required RequestPriority priority,
    required Map<String, dynamic>
        payload,
  }) {
    final now = DateTime.now();

    return AppointmentRequest(
      id: _uuid.v4(),

      appointmentId:
          _appointment.id,

      salonId:
          _appointment.salonId,

      salonName:
          _appointment.salonName,

      customerId:
          _appointment.userId,

      customerName:
          _appointment.customerName,

      customerPhone:
          _appointment.customerPhone,

      createdBy:
          RequestAuthor.admin,

      createdByName: "Salon",

      priority: priority,

      type: type,

      status:
          AppointmentRequestStatus
              .draft,

      createdAt: now,

      updatedAt: now,

      payload: payload,
    );
  }
}