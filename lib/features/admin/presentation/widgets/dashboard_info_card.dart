import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

class DashboardInfoCard extends StatelessWidget {
  const DashboardInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;

  final String title;

  final String value;

  final Color color;


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),

        child: Column(
          children: [

            CircleAvatar(
              radius: 24,

              backgroundColor:
              color.withValues(
                alpha: 0.12,
              ),

              child: Icon(
                icon,
                color: color,
              ),
            ),


            const SizedBox(
              height: AppSpacing.md,
            ),


            Text(
              value,

              style:
              AppTextStyles.titleLarge,
            ),


            const SizedBox(
              height: AppSpacing.xs,
            ),


            Text(
              title,

              style:
              AppTextStyles.bodySmall,

              textAlign:
              TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }
}