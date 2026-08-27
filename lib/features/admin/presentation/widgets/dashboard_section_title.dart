import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

class DashboardSectionTitle extends StatelessWidget {
  const DashboardSectionTitle({
    super.key,
    required this.title,
    this.subtitle = "",
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              if (subtitle.isNotEmpty) ...[
                const SizedBox(
                  height: AppSpacing.xs,
                ),

                Text(
                  subtitle,
                  style:
                  AppTextStyles.bodyMedium.copyWith(
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (trailing != null) trailing!,
      ],
    );
  }
}