import 'package:flutter/material.dart';

import '../../../../app/theme/theme.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.md,
      ),
      child: Text(
        title,
        style: AppTextStyles.titleLarge,
      ),
    );
  }
}