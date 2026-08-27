import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

import '../../models/admin_dashboard_model.dart';

class DashboardStatisticsGrid extends StatelessWidget {
  const DashboardStatisticsGrid({
    super.key,
    required this.dashboard,
    this.onAppointments,
    this.onEmployees,
  });

  final AdminDashboardModel dashboard;
  final VoidCallback? onAppointments;
  final VoidCallback? onEmployees;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.lg,
      mainAxisSpacing: AppSpacing.lg,
      childAspectRatio: 1.25,
      children: [
        _StatisticCard(
          icon: Icons.people_alt_rounded,
          color: Colors.blue,
          title: 'Clienti',
          value: dashboard.totalCustomers.toString(),
        ),
        _StatisticCard(
          icon: Icons.event_available_rounded,
          color: AppColors.primary,
          title: 'Appuntamenti',
          value: dashboard.totalAppointments.toString(),
          onTap: onAppointments,
        ),
        _StatisticCard(
          icon: Icons.payments_rounded,
          color: AppColors.success,
          title: 'Incasso',
          value: dashboard.formattedRevenue,
        ),
        _StatisticCard(
          icon: Icons.badge_rounded,
          color: Colors.deepPurple,
          title: 'Operatori',
          value: dashboard.totalEmployees.toString(),
          onTap: onEmployees,
        ),
      ],
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(
              AppRadius.lg,
            ),
            border: Border.all(
              color: AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: .04,
                ),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withValues(
                    alpha: .12,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}