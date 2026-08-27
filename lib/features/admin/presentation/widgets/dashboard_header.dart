import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/theme.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.salonName,
  });

  final String salonName;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final date = DateFormat(
      "EEEE d MMMM",
      "it_IT",
    ).format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dashboard",
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(
          height: AppSpacing.xs,
        ),

        Text(
          salonName,
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(
          height: AppSpacing.sm,
        ),

        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: Colors.grey.shade600,
            ),

            const SizedBox(
              width: AppSpacing.sm,
            ),

            Text(
              _capitalize(date),
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }
}