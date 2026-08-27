import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Le tue statistiche', style: AppTextStyles.titleMedium),

        const SizedBox(height: AppSpacing.lg),

        Row(
          children: const [
            Expanded(
              child: _StatCard(
                value: '12',
                label: 'Prenotazioni',
                icon: Icons.calendar_today,
              ),
            ),

            SizedBox(width: AppSpacing.md),

            Expanded(
              child: _StatCard(value: '5', label: 'Saloni', icon: Icons.store),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(icon, size: 30, color: AppColors.primary),

            const SizedBox(height: AppSpacing.md),

            Text(value, style: AppTextStyles.titleLarge),

            const SizedBox(height: 4),

            Text(label),
          ],
        ),
      ),
    );
  }
}
