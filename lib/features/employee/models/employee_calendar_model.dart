import 'package:cloud_firestore/cloud_firestore.dart';

enum CalendarEventType {
  vacation,
  sick,
  breakTime,
  meeting,
  blocked,
}

class EmployeeCalendarModel {
  const EmployeeCalendarModel({
    required this.id,
    required this.employeeId,
    required this.salonId,
    required this.start,
    required this.end,
    required this.type,
    required this.createdAt,
    this.title = '',
    this.note = '',
    this.allDay = false,
  });

  final String id;
  final String employeeId;
  final String salonId;

  final Timestamp start;
  final Timestamp end;

  final CalendarEventType type;

  final String title;
  final String note;

  final bool allDay;

  final Timestamp createdAt;

  factory EmployeeCalendarModel.fromMap(
      String id,
      Map<String, dynamic> json,
      ) {
    return EmployeeCalendarModel(
      id: id,
      employeeId: json['employeeId']?.toString() ?? '',
      salonId: json['salonId']?.toString() ?? '',
      start: json['start'] as Timestamp,
      end: json['end'] as Timestamp,
      type: _parseType(json['type']),
      title: json['title']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      allDay: json['allDay'] == true,
      createdAt: json['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'salonId': salonId,
      'start': start,
      'end': end,
      'type': type.name,
      'title': title,
      'note': note,
      'allDay': allDay,
      'createdAt': createdAt,
    };
  }

  EmployeeCalendarModel copyWith({
    String? employeeId,
    String? salonId,
    Timestamp? start,
    Timestamp? end,
    CalendarEventType? type,
    String? title,
    String? note,
    bool? allDay,
  }) {
    return EmployeeCalendarModel(
      id: id,
      employeeId: employeeId ?? this.employeeId,
      salonId: salonId ?? this.salonId,
      start: start ?? this.start,
      end: end ?? this.end,
      type: type ?? this.type,
      title: title ?? this.title,
      note: note ?? this.note,
      allDay: allDay ?? this.allDay,
      createdAt: createdAt,
    );
  }

  DateTime get startDate => start.toDate();

  DateTime get endDate => end.toDate();

  Duration get duration => endDate.difference(startDate);

  int get durationMinutes => duration.inMinutes;

  bool get isAllDay => allDay;

  bool overlaps(
      DateTime start,
      DateTime end,
      ) {
    return startDate.isBefore(end) && endDate.isAfter(start);
  }

  EmployeeCalendarModel moveByMinutes(
      int minutes,
      ) {
    return copyWith(
      start: Timestamp.fromDate(
        startDate.add(
          Duration(minutes: minutes),
        ),
      ),
      end: Timestamp.fromDate(
        endDate.add(
          Duration(minutes: minutes),
        ),
      ),
    );
  }

  EmployeeCalendarModel resizeToMinutes(
      int durationMinutes,
      ) {
    return copyWith(
      end: Timestamp.fromDate(
        startDate.add(
          Duration(minutes: durationMinutes),
        ),
      ),
    );
  }

  static CalendarEventType _parseType(
      dynamic value,
      ) {
    switch (value) {
      case 'vacation':
        return CalendarEventType.vacation;

      case 'sick':
        return CalendarEventType.sick;

      case 'breakTime':
        return CalendarEventType.breakTime;

      case 'meeting':
        return CalendarEventType.meeting;

      case 'blocked':
        return CalendarEventType.blocked;

      default:
        return CalendarEventType.blocked;
    }
  }
}