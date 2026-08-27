import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment_request_payload.dart';

class EmployeeRequestPayload extends AppointmentRequestPayload {
  const EmployeeRequestPayload({
    required this.oldEmployeeId,
    required this.newEmployeeId,
    this.oldEmployeeName = '',
    this.newEmployeeName = '',
    required this.appointmentStart,
    required this.appointmentEnd,
    this.serviceId = '',
    this.serviceName = '',
    this.employeeAvailable = true,
    this.message,
  });

  final String oldEmployeeId;
  final String newEmployeeId;

  final String oldEmployeeName;
  final String newEmployeeName;

  final DateTime appointmentStart;
  final DateTime appointmentEnd;

  final String serviceId;
  final String serviceName;

  final bool employeeAvailable;

  final String? message;

  bool get changed =>
      oldEmployeeId != newEmployeeId;

  bool get hasMessage =>
      (message ?? '').trim().isNotEmpty;

  @override
  Map<String, dynamic> toMap() {
    return {
      "oldEmployeeId": oldEmployeeId,
      "newEmployeeId": newEmployeeId,

      "oldEmployeeName": oldEmployeeName,
      "newEmployeeName": newEmployeeName,

      "appointmentStart":
      appointmentStart.toIso8601String(),

      "appointmentEnd":
      appointmentEnd.toIso8601String(),

      "serviceId": serviceId,
      "serviceName": serviceName,

      "employeeAvailable": employeeAvailable,

      "message": message,
    };
  }

  factory EmployeeRequestPayload.fromMap(
      Map<String, dynamic> map,
      ) {
    return EmployeeRequestPayload(
      oldEmployeeId:
      map["oldEmployeeId"]?.toString() ?? '',

      newEmployeeId:
      map["newEmployeeId"]?.toString() ?? '',

      oldEmployeeName:
      map["oldEmployeeName"]?.toString() ??
          map["oldEmployee"]?.toString() ??
          '',

      newEmployeeName:
      map["newEmployeeName"]?.toString() ??
          map["newEmployee"]?.toString() ??
          '',

      appointmentStart: DateTime.parse(
        map["appointmentStart"],
      ),

      appointmentEnd: DateTime.parse(
        map["appointmentEnd"],
      ),

      serviceId:
      map["serviceId"]?.toString() ?? '',

      serviceName:
      map["serviceName"]?.toString() ?? '',

      employeeAvailable:
      map["employeeAvailable"] as bool? ??
          true,

      message:
      map["message"]?.toString(),
    );
  }

  EmployeeRequestPayload copyWith({
    String? oldEmployeeId,
    String? newEmployeeId,
    String? oldEmployeeName,
    String? newEmployeeName,
    DateTime? appointmentStart,
    DateTime? appointmentEnd,
    String? serviceId,
    String? serviceName,
    bool? employeeAvailable,
    String? message,
  }) {
    return EmployeeRequestPayload(
      oldEmployeeId:
      oldEmployeeId ?? this.oldEmployeeId,

      newEmployeeId:
      newEmployeeId ?? this.newEmployeeId,

      oldEmployeeName:
      oldEmployeeName ??
          this.oldEmployeeName,

      newEmployeeName:
      newEmployeeName ??
          this.newEmployeeName,

      appointmentStart:
      appointmentStart ??
          this.appointmentStart,

      appointmentEnd:
      appointmentEnd ??
          this.appointmentEnd,

      serviceId:
      serviceId ?? this.serviceId,

      serviceName:
      serviceName ?? this.serviceName,

      employeeAvailable:
      employeeAvailable ??
          this.employeeAvailable,

      message:
      message ?? this.message,
    );
  }
}