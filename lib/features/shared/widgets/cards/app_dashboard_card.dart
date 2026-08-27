import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

class AppDashboardCard extends StatelessWidget {
  const AppDashboardCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,

      padding: padding ??
          const EdgeInsets.all(
            AppSpacing.lg,
          ),

      decoration: BoxDecoration(
        color: AppColors.surface,

        borderRadius: BorderRadius.circular(
          AppRadius.xl,
        ),

        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .035,
            ),
            blurRadius: 20,
            offset: const Offset(
              0,
              8,
            ),
          ),
        ],
      ),

      child: child,
    );

    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            AppRadius.xl,
          ),
          child: content,
        ),
      ),
    );
  }
}