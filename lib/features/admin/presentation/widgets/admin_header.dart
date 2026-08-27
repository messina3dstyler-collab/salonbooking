import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({
    super.key,
    required this.adminName,
    required this.salonName,
  });

  final String adminName;
  final String salonName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(
          AppRadius.xl,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Text(
            "Buongiorno 👋",
            style:
            AppTextStyles.body.copyWith(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            adminName,
            style:
            AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            salonName,
            style:
            AppTextStyles.body.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}