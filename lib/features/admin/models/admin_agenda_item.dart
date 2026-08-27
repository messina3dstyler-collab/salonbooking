import 'package:flutter/material.dart';

import '../../employee/models/employee_calendar_model.dart';
import 'admin_appointment_model.dart';

enum AdminAgendaItemType {
  appointment,
  vacation,
  sick,
  breakTime,
  meeting,
  blocked,
}

class AdminAgendaItem {
  const AdminAgendaItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.start,
    required this.end,
    required this.type,
    required this.title,
    this.subtitle = '',
    this.note = '',
    this.appointment,
    this.calendarEvent,
  });

  final String id;
  final String employeeId;
  final String employeeName;

  final DateTime start;
  final DateTime end;

  final String title;
  final String subtitle;
  final String note;

  final AdminAgendaItemType type;

  final AdminAppointmentModel? appointment;
  final EmployeeCalendarModel? calendarEvent;

  Duration get duration => end.difference(start);

  bool get isAppointment => appointment != null;

  bool get isCalendarEvent => calendarEvent != null;

  bool get isEditable => isAppointment || isCalendarEvent;

  IconData get icon {
    switch (type) {
      case AdminAgendaItemType.appointment:
        return Icons.content_cut;
      case AdminAgendaItemType.vacation:
        return Icons.beach_access;
      case AdminAgendaItemType.sick:
        return Icons.sick;
      case AdminAgendaItemType.breakTime:
        return Icons.restaurant;
      case AdminAgendaItemType.meeting:
        return Icons.groups;
      case AdminAgendaItemType.blocked:
        return Icons.block;
    }
  }

  Color get color {
    switch (type) {
      case AdminAgendaItemType.appointment:
        return Colors.green;
      case AdminAgendaItemType.vacation:
        return Colors.orange;
      case AdminAgendaItemType.sick:
        return Colors.red;
      case AdminAgendaItemType.breakTime:
        return Colors.brown;
      case AdminAgendaItemType.meeting:
        return Colors.blue;
      case AdminAgendaItemType.blocked:
        return Colors.black87;
    }
  }

  String get timeLabel {
    String f(DateTime d) =>
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return '${f(start)} - ${f(end)}';
  }
}