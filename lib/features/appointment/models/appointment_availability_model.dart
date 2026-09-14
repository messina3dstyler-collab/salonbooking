import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentAvailabilityModel {
  const AppointmentAvailabilityModel({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.start,
  });

  final String id;
  final String salonId;
  final String employeeId;
  final DateTime start;

  factory AppointmentAvailabilityModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    final rawStart = map['start'];

    DateTime? parsedStart;

    if (rawStart is Timestamp) {
      parsedStart = rawStart.toDate();
    } else if (rawStart is DateTime) {
      parsedStart = rawStart;
    } else if (rawStart is String) {
      parsedStart = DateTime.tryParse(rawStart);
    }

    if (parsedStart == null) {
      throw FormatException(
        'Il campo start non contiene una data valida.',
      );
    }

    return AppointmentAvailabilityModel(
      id: id,
      salonId: map['salonId']?.toString() ?? '',
      employeeId: map['employeeId']?.toString() ?? '',
      start: parsedStart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'salonId': salonId,
      'employeeId': employeeId,
      'start': Timestamp.fromDate(start),
    };
  }

  AppointmentAvailabilityModel copyWith({
    String? id,
    String? salonId,
    String? employeeId,
    DateTime? start,
  }) {
    return AppointmentAvailabilityModel(
      id: id ?? this.id,
      salonId: salonId ?? this.salonId,
      employeeId: employeeId ?? this.employeeId,
      start: start ?? this.start,
    );
  }

  bool get hasValidIdentity =>
      id.trim().isNotEmpty &&
          salonId.trim().isNotEmpty &&
          employeeId.trim().isNotEmpty;

  bool get hasValidStart =>
      start.year >= 2000;

  bool get isStructurallyValid =>
      hasValidIdentity &&
          hasValidStart;
}