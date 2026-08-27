import 'package:cloud_firestore/cloud_firestore.dart';

import 'appointment_request_payload.dart';

class RescheduleRequestPayload extends AppointmentRequestPayload {
  const RescheduleRequestPayload({
    required this.oldStart,
    required this.newStart,
    required this.oldEnd,
    required this.newEnd,
    required this.oldEmployeeId,
    required this.newEmployeeId,
    this.oldEmployeeName = '',
    this.newEmployeeName = '',
    this.message,
  });

  final DateTime oldStart;
  final DateTime newStart;

  final DateTime oldEnd;
  final DateTime newEnd;

  final String oldEmployeeId;
  final String newEmployeeId;

  final String oldEmployeeName;
  final String newEmployeeName;

  /// Messaggio opzionale del salone.
  final String? message;

  bool get hasEmployeeChange =>
      oldEmployeeId != newEmployeeId;

  bool get hasMessage =>
      (message ?? '').trim().isNotEmpty;

  bool get durationChanged =>
      oldEnd.difference(oldStart) !=
          newEnd.difference(newStart);

  @override
  Map<String, dynamic> toMap() {
    return {
      "oldStart": oldStart.toIso8601String(),
      "newStart": newStart.toIso8601String(),
      "oldEnd": oldEnd.toIso8601String(),
      "newEnd": newEnd.toIso8601String(),
      "oldEmployeeId": oldEmployeeId,
      "newEmployeeId": newEmployeeId,
      "oldEmployeeName": oldEmployeeName,
      "newEmployeeName": newEmployeeName,
      "message": message,
    };
  }

  factory RescheduleRequestPayload.fromMap(
      Map<String, dynamic> map,
      ) {
    return RescheduleRequestPayload(
      oldStart: _date(map["oldStart"]),
      newStart: _date(map["newStart"]),
      oldEnd: _date(map["oldEnd"]),
      newEnd: _date(map["newEnd"]),
      oldEmployeeId:
      map["oldEmployeeId"]?.toString() ?? '',
      newEmployeeId:
      map["newEmployeeId"]?.toString() ?? '',
      oldEmployeeName:
      map["oldEmployeeName"]?.toString() ?? '',
      newEmployeeName:
      map["newEmployeeName"]?.toString() ?? '',
      message: map["message"]?.toString(),
    );
  }

  RescheduleRequestPayload copyWith({
    DateTime? oldStart,
    DateTime? newStart,
    DateTime? oldEnd,
    DateTime? newEnd,
    String? oldEmployeeId,
    String? newEmployeeId,
    String? oldEmployeeName,
    String? newEmployeeName,
    String? message,
  }) {
    return RescheduleRequestPayload(
      oldStart: oldStart ?? this.oldStart,
      newStart: newStart ?? this.newStart,
      oldEnd: oldEnd ?? this.oldEnd,
      newEnd: newEnd ?? this.newEnd,
      oldEmployeeId:
      oldEmployeeId ?? this.oldEmployeeId,
      newEmployeeId:
      newEmployeeId ?? this.newEmployeeId,
      oldEmployeeName:
      oldEmployeeName ?? this.oldEmployeeName,
      newEmployeeName:
      newEmployeeName ?? this.newEmployeeName,
      message: message ?? this.message,
    );
  }

  static DateTime _date(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String &&
        value.isNotEmpty) {
      return DateTime.parse(value);
    }

    return DateTime.now();
  }
}