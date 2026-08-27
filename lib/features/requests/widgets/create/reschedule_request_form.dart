import 'package:flutter/material.dart';

import '../../../shared/widgets/sheets/app_bottom_sheet.dart';

class RescheduleRequestForm extends StatefulWidget {
  const RescheduleRequestForm({
    super.key,
    required this.initialStart,
    required this.initialEnd,
    required this.onConfirm,
  });

  final DateTime initialStart;
  final DateTime initialEnd;

  final void Function(
      DateTime newStart,
      DateTime newEnd,
      String? message,
      ) onConfirm;

  static Future<void> show(
      BuildContext context, {
        required DateTime initialStart,
        required DateTime initialEnd,
        required void Function(
            DateTime newStart,
            DateTime newEnd,
            String? message,
            )
        onConfirm,
      }) {
    return AppBottomSheet.show(
      context,
      title: "Cambio orario",
      subtitle: "Proponi un nuovo appuntamento",
      showCloseButton: true,
      child: RescheduleRequestForm(
        initialStart: initialStart,
        initialEnd: initialEnd,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<RescheduleRequestForm> createState() =>
      _RescheduleRequestFormState();
}

class _RescheduleRequestFormState
    extends State<RescheduleRequestForm> {
  late DateTime _start;
  late DateTime _end;

  final _messageController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_start),
    );

    if (time == null) return;

    final duration = _end.difference(_start);

    final newStart = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _start = newStart;
      _end = newStart.add(duration);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text("Nuovo appuntamento"),
          subtitle: Text(
            "${_start.day}/${_start.month}/${_start.year} "
                "${_start.hour.toString().padLeft(2, "0")}:${_start.minute.toString().padLeft(2, "0")}",
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _pickDate,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _messageController,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: "Messaggio (facoltativo)",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          icon: const Icon(Icons.send),
          label: const Text("Crea richiesta"),
          onPressed: () {
            widget.onConfirm(
              _start,
              _end,
              _messageController.text.trim().isEmpty
                  ? null
                  : _messageController.text.trim(),
            );

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}