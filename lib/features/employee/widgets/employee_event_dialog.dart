import 'package:flutter/material.dart';

import '../models/employee_calendar_model.dart';
import 'employee_event_form.dart';

class EmployeeEventDialog extends StatelessWidget {
  const EmployeeEventDialog({
    super.key,
    required this.employeeId,
    this.event,
  });

  final String employeeId;
  final EmployeeCalendarModel? event;

  bool get isEditing => event != null;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
          maxHeight: 700,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
              ),
              child: Row(
                children: [
                  Icon(
                    isEditing
                        ? Icons.edit_calendar
                        : Icons.event_available,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Modifica evento'
                          : 'Nuovo evento',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: EmployeeEventForm(
                  employeeId: employeeId,
                  event: event,
                  onSaved: (
                      EmployeeCalendarModel result,
                      ) {
                    Navigator.pop(
                      context,
                      result,
                    );
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}