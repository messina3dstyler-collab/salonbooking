import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

class SalonClosedDaysSection extends StatelessWidget {
  const SalonClosedDaysSection({
    super.key,
    required this.closedWeekdays,
    required this.onChanged,
  });

  final List<int> closedWeekdays;
  final ValueChanged<List<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Giorni di chiusura',
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _dayChip(1, 'Lun'),
            _dayChip(2, 'Mar'),
            _dayChip(3, 'Mer'),
            _dayChip(4, 'Gio'),
            _dayChip(5, 'Ven'),
            _dayChip(6, 'Sab'),
            _dayChip(7, 'Dom'),
          ],
        ),
      ],
    );
  }

  Widget _dayChip(
      int day,
      String label,
      ) {
    final selected = closedWeekdays.contains(day);

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        final updated = List<int>.from(closedWeekdays);

        if (selected) {
          updated.remove(day);
        } else {
          updated.add(day);
          updated.sort();
        }

        onChanged(updated);
      },
    );
  }
}