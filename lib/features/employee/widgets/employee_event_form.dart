import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/employee_calendar_model.dart';

class EmployeeEventForm extends StatefulWidget {
  const EmployeeEventForm({
    super.key,
    required this.employeeId,
    this.event,
    required this.onSaved,
    required this.onCancel,
  });

  final String employeeId;
  final EmployeeCalendarModel? event;

  final ValueChanged<EmployeeCalendarModel> onSaved;
  final VoidCallback onCancel;

  @override
  State<EmployeeEventForm> createState() =>
      _EmployeeEventFormState();
}

class _EmployeeEventFormState
    extends State<EmployeeEventForm> {
  final _formKey = GlobalKey<FormState>();

  late CalendarEventType _type;

  late DateTime _date;

  late TimeOfDay _start;

  late TimeOfDay _end;

  bool _allDay = false;

  late TextEditingController _titleController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    final event = widget.event;

    if (event != null) {
      _type = event.type;

      _date = event.startDate;

      _start = TimeOfDay.fromDateTime(
        event.startDate,
      );

      _end = TimeOfDay.fromDateTime(
        event.endDate,
      );

      _allDay = event.allDay;

      _titleController = TextEditingController(
        text: event.title,
      );

      _noteController = TextEditingController(
        text: event.note,
      );
    } else {
      final now = DateTime.now();

      _type = CalendarEventType.blocked;

      _date = DateTime(
        now.year,
        now.month,
        now.day,
      );

      _start = const TimeOfDay(
        hour: 9,
        minute: 0,
      );

      _end = const TimeOfDay(
        hour: 10,
        minute: 0,
      );

      _titleController =
          TextEditingController();

      _noteController =
          TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked == null) return;

    setState(() {
      _date = picked;
    });
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _start,
    );

    if (picked == null) return;

    setState(() {
      _start = picked;
    });
  }

  Future<void> _pickEnd() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _end,
    );

    if (picked == null) return;

    setState(() {
      _end = picked;
    });
  }

  void _save() {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final startDate = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _allDay ? 0 : _start.hour,
      _allDay ? 0 : _start.minute,
    );

    final endDate = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _allDay ? 23 : _end.hour,
      _allDay ? 59 : _end.minute,
    );

    if (endDate.isBefore(startDate)) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'L\'orario finale deve essere successivo.',
          ),
        ),
      );

      return;
    }

    final model = EmployeeCalendarModel(

      id: widget.event?.id ??
          FirebaseFirestore.instance
              .collection(
                'employee_calendar',
              )
              .doc()
              .id,

      employeeId: widget.employeeId,

      start: Timestamp.fromDate(
        startDate,
      ),

      end: Timestamp.fromDate(
        endDate,
      ),

      type: _type,

      title: _titleController.text.trim(),

      note: _noteController.text.trim(),

      allDay: _allDay,

      createdAt:
          widget.event?.createdAt ??
              Timestamp.now(),
    );

    widget.onSaved(model);
  }

  @override
  Widget build(BuildContext context) {

    return Form(

      key: _formKey,

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.stretch,

        children: [
          DropdownButtonFormField<CalendarEventType>(
            initialValue: _type,
            decoration: const InputDecoration(
              labelText: 'Tipo evento',
            ),
            items: CalendarEventType.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(_label(e)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _type = value;
              });
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Titolo',
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note',
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 20),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Evento giornata intera',
            ),
            value: _allDay,
            onChanged: (v) {
              setState(() {
                _allDay = v;
              });
            },
          ),

          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
              '${_date.day}/${_date.month}/${_date.year}',
            ),
            trailing: const Icon(Icons.edit),
            onTap: _pickDate,
          ),

          if (!_allDay) ...[
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(
                'Inizio ${_start.format(context)}',
              ),
              trailing: const Icon(Icons.edit),
              onTap: _pickStart,
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(
                'Fine ${_end.format(context)}',
              ),
              trailing: const Icon(Icons.edit),
              onTap: _pickEnd,
            ),
          ],

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: const Text(
                    'Annulla',
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Salva',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _label(CalendarEventType type) {
    switch (type) {
      case CalendarEventType.vacation:
        return 'Ferie';

      case CalendarEventType.sick:
        return 'Malattia';

      case CalendarEventType.breakTime:
        return 'Pausa';

      case CalendarEventType.meeting:
        return 'Riunione';

      case CalendarEventType.blocked:
        return 'Bloccato';
    }
  }
}