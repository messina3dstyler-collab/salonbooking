import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';
import '../../models/salon_model.dart';

class SalonCard extends StatelessWidget {
  const SalonCard({super.key, required this.salon, this.onTap});

  final SalonModel salon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.content_cut, size: 34),
              ),

              const SizedBox(width: AppSpacing.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(salon.name, style: AppTextStyles.titleMedium),

                    const SizedBox(height: 4),

                    Text(salon.address, style: AppTextStyles.body),

                    Text(salon.city, style: AppTextStyles.bodySmall),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),

                        const SizedBox(width: 4),

                        Text(salon.rating.toString()),

                        const SizedBox(width: 8),

                        Text(
                          "(${salon.reviewCount})",
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
