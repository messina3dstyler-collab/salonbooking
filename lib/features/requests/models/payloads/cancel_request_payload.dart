import 'appointment_request_payload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CancelRequestPayload extends AppointmentRequestPayload {
  const CancelRequestPayload({
    required this.appointmentStart,
    required this.appointmentEnd,
    this.employeeId = '',
    this.employeeName = '',
    this.serviceId = '',
    this.serviceName = '',
    this.price = 0,
    this.reason,
    this.message,
    this.refund = false,
  });

  final DateTime appointmentStart;
  final DateTime appointmentEnd;

  final String employeeId;
  final String employeeName;

  final String serviceId;
  final String serviceName;

  final double price;

  final String? reason;
  final String? message;

  final bool refund;

  bool get hasReason =>
      (reason ?? '').trim().isNotEmpty;

  bool get hasMessage =>
      (message ?? '').trim().isNotEmpty;

  @override
  Map<String, dynamic> toMap() {
    return {
      "appointmentStart":
      appointmentStart.toIso8601String(),

      "appointmentEnd":
      appointmentEnd.toIso8601String(),

      "employeeId": employeeId,
      "employeeName": employeeName,

      "serviceId": serviceId,
      "serviceName": serviceName,

      "price": price,

      "reason": reason,
      "message": message,
      "refund": refund,
    };
  }

  factory CancelRequestPayload.fromMap(
      Map<String, dynamic> map,
      ) {
    return CancelRequestPayload(
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

      price:
      (map["price"] as num?)?.toDouble() ??
          0,

      reason:
      map["reason"]?.toString(),

      message:
      map["message"]?.toString(),

      refund:
      map["refund"] as bool? ?? false,
    );
  }

  CancelRequestPayload copyWith({
    DateTime? appointmentStart,
    DateTime? appointmentEnd,
    String? employeeId,
    String? employeeName,
    String? serviceId,
    String? serviceName,
    double? price,
    String? reason,
    String? message,
    bool? refund,
  }) {
    return CancelRequestPayload(
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

      price:
      price ?? this.price,

      reason:
      reason ?? this.reason,

      message:
      message ?? this.message,

      refund:
      refund ?? this.refund,
    );
  }
}