import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bentornato 👋', style: AppTextStyles.body),
              const SizedBox(height: 4),
              Text(
                userName.isEmpty ? 'Cliente' : userName,
                style: AppTextStyles.titleLarge,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}
