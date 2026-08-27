import 'appointment_request_payload.dart';

class ServicesRequestPayload extends AppointmentRequestPayload {
  const ServicesRequestPayload({
    required this.oldServiceIds,
    required this.newServiceIds,
    required this.oldServiceNames,
    required this.newServiceNames,
    this.oldTotalPrice = 0,
    this.newTotalPrice = 0,
    this.oldDuration = 0,
    this.newDuration = 0,
    this.employeeId = '',
    this.employeeName = '',
    this.message,
  });

  final List<String> oldServiceIds;
  final List<String> newServiceIds;

  final List<String> oldServiceNames;
  final List<String> newServiceNames;

  final double oldTotalPrice;
  final double newTotalPrice;

  final int oldDuration;
  final int newDuration;

  final String employeeId;
  final String employeeName;

  final String? message;

  bool get changed =>
      oldServiceIds.join('|') !=
          newServiceIds.join('|');

  bool get hasMessage =>
      (message ?? '').trim().isNotEmpty;

  @override
  Map<String, dynamic> toMap() {
    return {
      "oldServiceIds": oldServiceIds,
      "newServiceIds": newServiceIds,

      "oldServiceNames": oldServiceNames,
      "newServiceNames": newServiceNames,

      "oldTotalPrice": oldTotalPrice,
      "newTotalPrice": newTotalPrice,

      "oldDuration": oldDuration,
      "newDuration": newDuration,

      "employeeId": employeeId,
      "employeeName": employeeName,

      "message": message,
    };
  }

  factory ServicesRequestPayload.fromMap(
      Map<String, dynamic> map,
      ) {
    return ServicesRequestPayload(
      oldServiceIds: List<String>.from(
        map["oldServiceIds"] ?? [],
      ),

      newServiceIds: List<String>.from(
        map["newServiceIds"] ?? [],
      ),

      oldServiceNames: List<String>.from(
        map["oldServiceNames"] ?? [],
      ),

      newServiceNames: List<String>.from(
        map["newServiceNames"] ?? [],
      ),

      oldTotalPrice:
      (map["oldTotalPrice"] as num?)
          ?.toDouble() ??
          0,

      newTotalPrice:
      (map["newTotalPrice"] as num?)
          ?.toDouble() ??
          0,

      oldDuration:
      (map["oldDuration"] as num?)
          ?.toInt() ??
          0,

      newDuration:
      (map["newDuration"] as num?)
          ?.toInt() ??
          0,

      employeeId:
      map["employeeId"]?.toString() ??
          '',

      employeeName:
      map["employeeName"]?.toString() ??
          '',

      message:
      map["message"]?.toString(),
    );
  }

  ServicesRequestPayload copyWith({
    List<String>? oldServiceIds,
    List<String>? newServiceIds,
    List<String>? oldServiceNames,
    List<String>? newServiceNames,
    double? oldTotalPrice,
    double? newTotalPrice,
    int? oldDuration,
    int? newDuration,
    String? employeeId,
    String? employeeName,
    String? message,
  }) {
    return ServicesRequestPayload(
      oldServiceIds:
      oldServiceIds ??
          this.oldServiceIds,

      newServiceIds:
      newServiceIds ??
          this.newServiceIds,

      oldServiceNames:
      oldServiceNames ??
          this.oldServiceNames,

      newServiceNames:
      newServiceNames ??
          this.newServiceNames,

      oldTotalPrice:
      oldTotalPrice ??
          this.oldTotalPrice,

      newTotalPrice:
      newTotalPrice ??
          this.newTotalPrice,

      oldDuration:
      oldDuration ??
          this.oldDuration,

      newDuration:
      newDuration ??
          this.newDuration,

      employeeId:
      employeeId ??
          this.employeeId,

      employeeName:
      employeeName ??
          this.employeeName,

      message:
      message ??
          this.message,
    );
  }
}