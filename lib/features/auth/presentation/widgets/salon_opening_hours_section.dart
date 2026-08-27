import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

class SalonOpeningHoursSection extends StatelessWidget {
  const SalonOpeningHoursSection({
    super.key,
    required this.openingHour,
    required this.closingHour,
    required this.onOpeningChanged,
    required this.onClosingChanged,
  });

  final int openingHour;
  final int closingHour;

  final ValueChanged<int> onOpeningChanged;
  final ValueChanged<int> onClosingChanged;

  List<int> get _hours => List.generate(
    15,
        (index) => index + 7,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            initialValue: openingHour,
            decoration: const InputDecoration(
              labelText: 'Apertura',
              border: OutlineInputBorder(),
            ),
            items: _hours
                .map(
                  (hour) => DropdownMenuItem(
                value: hour,
                child: Text(
                  '${hour.toString().padLeft(2, '0')}:00',
                ),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onOpeningChanged(value);
              }
            },
          ),
        ),
        const SizedBox(
          width: AppSpacing.lg,
        ),
        Expanded(
          child: DropdownButtonFormField<int>(
            initialValue: closingHour,
            decoration: const InputDecoration(
              labelText: 'Chiusura',
              border: OutlineInputBorder(),
            ),
            items: _hours
                .where(
                  (hour) => hour > openingHour,
            )
                .map(
                  (hour) => DropdownMenuItem(
                value: hour,
                child: Text(
                  '${hour.toString().padLeft(2, '0')}:00',
                ),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onClosingChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}