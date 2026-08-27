import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class NextBookingCard extends StatelessWidget {
  const NextBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.calendar_today, color: Colors.white),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Prossimo appuntamento',
            style: AppTextStyles.body.copyWith(color: Colors.white70),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Sabato 15 Marzo',
            style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
          ),

          const SizedBox(height: 6),

          Text(
            'Ore 15:30',
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
