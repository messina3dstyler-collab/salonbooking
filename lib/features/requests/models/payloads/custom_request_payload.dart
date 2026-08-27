import 'appointment_request_payload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomRequestPayload extends AppointmentRequestPayload {
  const CustomRequestPayload({
    this.title,
    this.message,
    this.data = const {},

    required this.appointmentStart,
    required this.appointmentEnd,

    this.employeeId = '',
    this.employeeName = '',

    this.serviceId = '',
    this.serviceName = '',
  });

  final String? title;
  final String? message;

  final Map<String, dynamic> data;

  final DateTime appointmentStart;
  final DateTime appointmentEnd;

  final String employeeId;
  final String employeeName;

  final String serviceId;
  final String serviceName;

  bool get hasTitle =>
      (title ?? '').trim().isNotEmpty;

  bool get hasMessage =>
      (message ?? '').trim().isNotEmpty;

  @override
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "message": message,
      "data": data,

      "appointmentStart":
      appointmentStart.toIso8601String(),

      "appointmentEnd":
      appointmentEnd.toIso8601String(),

      "employeeId": employeeId,
      "employeeName": employeeName,

      "serviceId": serviceId,
      "serviceName": serviceName,
    };
  }

  factory CustomRequestPayload.fromMap(
      Map<String, dynamic> map,
      ) {
    return CustomRequestPayload(
      title:
      map["title"]?.toString(),

      message:
      map["message"]?.toString(),

      data: Map<String, dynamic>.from(
        map["data"] ?? const {},
      ),

      appointmentStart: DateTime.parse(
        map["appointmentStart"],
      ),

      appointmentEnd: DateTime.parse(
        map["appointmentEnd"],
      ),

      employeeId:
      map["employeeId"]?.toString() ?? '',

      employeeName:
      map["employeeName"]?.toString() ?? '',

      serviceId:
      map["serviceId"]?.toString() ?? '',

      serviceName:
      map["serviceName"]?.toString() ?? '',
    );
  }

  CustomRequestPayload copyWith({
    String? title,
    String? message,
    Map<String, dynamic>? data,
    DateTime? appointmentStart,
    DateTime? appointmentEnd,
    String? employeeId,
    String? employeeName,
    String? serviceId,
    String? serviceName,
  }) {
    return CustomRequestPayload(
      title:
      title ?? this.title,

      message:
      message ?? this.message,

      data:
      data ?? this.data,

      appointmentStart:
      appointmentStart ??
          this.appointmentStart,

      appointmentEnd:
      appointmentEnd ??
          this.appointmentEnd,

      employeeId:
      employeeId ?? this.employeeId,

      employeeName:
      employeeName ?? this.employeeName,

      serviceId:
      serviceId ?? this.serviceId,

      serviceName:
      serviceName ?? this.serviceName,
    );
  }
}