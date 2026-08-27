import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/theme.dart';

class TodayHeader extends StatelessWidget {
  const TodayHeader({
    super.key,
    required this.date,
    required this.appointments,
    required this.pendingRequests,
    required this.expectedRevenue,
  });

  final DateTime date;
  final int appointments;
  final int pendingRequests;
  final double expectedRevenue;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat(
      "EEEE d MMMM",
      "it_IT",
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "OGGI",
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primary,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          _capitalize(
            formatter.format(date),
          ),
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        Row(
          children: [
            Expanded(
              child: _InfoTile(
                icon: Icons.calendar_today_rounded,
                value: appointments.toString(),
                label: "Appuntamenti",
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: _InfoTile(
                icon: Icons.mark_email_unread_rounded,
                value: pendingRequests.toString(),
                label: "Richieste",
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: _InfoTile(
                icon: Icons.payments_rounded,
                value:
                "€${expectedRevenue.toStringAsFixed(0)}",
                label: "Previsto",
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() +
        value.substring(1);
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 26,
          ),

          const SizedBox(
            height: AppSpacing.md,
          ),

          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(
            height: AppSpacing.xs,
          ),

          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}