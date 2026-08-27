import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../../models/next_appointment_model.dart';

class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({
    super.key,
    required this.model,
    this.onTap,
  });

  final NextAppointmentModel model;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        onTap: model.hasAppointment
            ? onTap
            : null,
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
          child: Row(
            children: [
              Container(
                width: 6,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                  const BorderRadius.only(
                    topLeft: Radius.circular(
                      AppRadius.lg,
                    ),
                    bottomLeft:
                    Radius.circular(
                      AppRadius.lg,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    AppSpacing.xl,
                  ),
                  child: model.hasAppointment
                      ? _AppointmentContent(
                    model: model,
                  )
                      : const _EmptyContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentContent
    extends StatelessWidget {
  const _AppointmentContent({
    required this.model,
  });

  final NextAppointmentModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          "PROSSIMO APPUNTAMENTO",
          style: AppTextStyles.labelMedium
              .copyWith(
            color: AppColors.primary,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(
          height: AppSpacing.lg,
        ),

        Row(
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withValues(
                  alpha: .12,
                ),
                borderRadius:
                BorderRadius.circular(
                  AppRadius.md,
                ),
              ),
              child: Text(
                model.time,
                style: AppTextStyles
                    .headlineMedium
                    .copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),

            const Spacer(),

            if (model.countdown.isNotEmpty)
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius:
                  BorderRadius.circular(
                    50,
                  ),
                ),
                child: Text(
                  model.countdown,
                  style: AppTextStyles
                      .labelMedium
                      .copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(
          height: AppSpacing.xl,
        ),

        Text(
          model.customer,
          style: AppTextStyles
              .headlineMedium
              .copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(
          height: AppSpacing.sm,
        ),

        Text(
          model.service,
          style: AppTextStyles.bodyLarge
              .copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(
          height: AppSpacing.lg,
        ),

        Row(
          children: [
            Icon(
              Icons.badge_rounded,
              color: AppColors.primary,
              size: 18,
            ),

            const SizedBox(
              width: AppSpacing.sm,
            ),

            Expanded(
              child: Text(
                model.employee,
                style: AppTextStyles
                    .titleMedium
                    .copyWith(
                  color:
                  AppColors.textPrimary,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right,
              color:
              AppColors.textSecondary,
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyContent
    extends StatelessWidget {
  const _EmptyContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available,
              size: 40,
              color: AppColors.primary,
            ),

            const SizedBox(
              height: AppSpacing.md,
            ),

            Text(
              "Nessun appuntamento imminente",
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: AppSpacing.sm,
            ),

            Text(
              "La giornata è libera.",
              style: AppTextStyles.bodyMedium
                  .copyWith(
                color:
                AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}