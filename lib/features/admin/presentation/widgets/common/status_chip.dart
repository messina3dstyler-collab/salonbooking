import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

enum StatusChipType {
  success,
  warning,
  error,
  info,
  neutral,
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.type = StatusChipType.neutral,
    this.icon,
  });

  final String label;
  final StatusChipType type;
  final IconData? icon;

  Color get _backgroundColor {
    switch (type) {
      case StatusChipType.success:
        return Colors.green.shade100;

      case StatusChipType.warning:
        return Colors.orange.shade100;

      case StatusChipType.error:
        return Colors.red.shade100;

      case StatusChipType.info:
        return Colors.blue.shade100;

      case StatusChipType.neutral:
        return Colors.grey.shade200;
    }
  }

  Color get _foregroundColor {
    switch (type) {
      case StatusChipType.success:
        return Colors.green.shade800;

      case StatusChipType.warning:
        return Colors.orange.shade900;

      case StatusChipType.error:
        return Colors.red.shade800;

      case StatusChipType.info:
        return Colors.blue.shade800;

      case StatusChipType.neutral:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: _foregroundColor,
            ),
            const SizedBox(
              width: AppSpacing.xs,
            ),
          ],
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: _foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}