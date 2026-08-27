import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../../main/presentation/pages/main_page.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Azioni rapide', style: AppTextStyles.titleMedium),

        const SizedBox(height: AppSpacing.lg),

        Row(
          children: [
            Expanded(
              child: _QuickCard(
                icon: Icons.add,
                title: 'Prenota',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainPage(initialIndex: 1),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: _QuickCard(
                icon: Icons.history,
                title: 'Storico',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainPage(initialIndex: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Icon(icon, size: 34, color: AppColors.primary),

              const SizedBox(height: AppSpacing.md),

              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
