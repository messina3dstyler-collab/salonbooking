import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../../../shared/widgets/cards/app_dashboard_card.dart';

class DashboardHero extends StatelessWidget {
  const DashboardHero({
    super.key,
    required this.employeeName,
    required this.todayAppointments,
    required this.todayRevenue,
    required this.pendingRequests,
  });

  final String employeeName;
  final int todayAppointments;
  final double todayRevenue;
  final int pendingRequests;

  @override
  Widget build(BuildContext context) {
    return AppDashboardCard(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(
            AppRadius.xl,
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withValues(alpha: .15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                  ),
                ),

                const Spacer(),

                Icon(
                  Icons.insights_rounded,
                  color: Colors.white.withValues(
                    alpha: .30,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: AppSpacing.xl,
            ),

            Text(
              "Buongiorno",
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            Text(
              employeeName,
              style:
              AppTextStyles.headlineMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(
              height: AppSpacing.sm,
            ),

            Text(
              "Ecco la situazione del salone in questo momento.",
              style:
              AppTextStyles.bodyMedium.copyWith(
                color: Colors.white70,
              ),
            ),

            const SizedBox(
              height: AppSpacing.xl,
            ),

            Row(
              children: [

                Expanded(
                  child: _HeroStat(
                    value:
                    todayAppointments.toString(),
                    label: "Appuntamenti",
                  ),
                ),

                Expanded(
                  child: _HeroStat(
                    value:
                    "€ ${todayRevenue.toStringAsFixed(0)}",
                    label: "Incasso",
                  ),
                ),

                Expanded(
                  child: _HeroStat(
                    value:
                    pendingRequests.toString(),
                    label: "Richieste",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          value,
          style:
          AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        Text(
          label,
          textAlign: TextAlign.center,
          style:
          AppTextStyles.bodySmall.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}