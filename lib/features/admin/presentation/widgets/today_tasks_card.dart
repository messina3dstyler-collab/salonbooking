import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../../models/today_tasks_model.dart';

class TodayTasksCard extends StatelessWidget {
  const TodayTasksCard({
    super.key,
    required this.model,
    this.onTap,
  });

  final TodayTasksModel model;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final completed = !model.hasTasks;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: model.hasTasks ? onTap : null,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        child: Ink(
          padding: const EdgeInsets.all(
            AppSpacing.xl,
          ),
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
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                "DA FARE OGGI",
                style:
                AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              if (completed)
                const _CompletedState()
              else ...[
                if (model.pendingRequests > 0) ...[
                  _TaskTile(
                    icon:
                    Icons.mark_email_unread_rounded,
                    color: Colors.orange,
                    title: "Richieste",
                    value: model.pendingRequests,
                    description:
                    "in attesa di risposta",
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                ],

                if (model.unconfirmedAppointments >
                    0) ...[
                  _TaskTile(
                    icon:
                    Icons.access_time_filled_rounded,
                    color: Colors.green,
                    title: "Conferme",
                    value: model
                        .unconfirmedAppointments,
                    description:
                    "appuntamenti da confermare",
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                ],

                if (model.expiringRequests > 0) ...[
                  _TaskTile(
                    icon:
                    Icons.timer_outlined,
                    color: Colors.red,
                    title: "Richieste",
                    value:
                    model.expiringRequests,
                    description:
                    "in scadenza",
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                ],

                if (model.pendingReviews > 0) ...[
                  _TaskTile(
                    icon: Icons.star_rounded,
                    color: Colors.amber,
                    title: "Recensioni",
                    value:
                    model.pendingReviews,
                    description:
                    "da moderare",
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                ],

                if (model.missingPayments > 0)
                  _TaskTile(
                    icon:
                    Icons.payments_rounded,
                    color: Colors.deepOrange,
                    title: "Pagamenti",
                    value:
                    model.missingPayments,
                    description:
                    "da incassare",
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final int value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor:
          color.withValues(alpha: .12),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),

        const SizedBox(
          width: AppSpacing.md,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                AppTextStyles.titleMedium,
              ),

              const SizedBox(height: 2),

              Text(
                description,
                style: AppTextStyles.bodySmall
                    .copyWith(
                  color:
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color:
            color.withValues(alpha: .12),
            borderRadius:
            BorderRadius.circular(30),
          ),
          child: Text(
            value.toString(),
            style: AppTextStyles.titleMedium
                .copyWith(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _CompletedState
    extends StatelessWidget {
  const _CompletedState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor:
            AppColors.success.withValues(
              alpha: .12,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 34,
            ),
          ),

          const SizedBox(
            height: AppSpacing.lg,
          ),

          Text(
            "Tutto sotto controllo",
            style:
            AppTextStyles.titleLarge,
          ),

          const SizedBox(
            height: AppSpacing.sm,
          ),

          Text(
            "Non ci sono attività urgenti per oggi.",
            style:
            AppTextStyles.bodyMedium.copyWith(
              color:
              AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}