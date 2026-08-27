import 'package:flutter/material.dart';

import '../presentation/widgets/common/status_chip.dart';

extension AppointmentStatusExtension on String {
  StatusChipType get chipType {
    switch (toLowerCase()) {
      case 'confermata':
      case 'confirmed':
        return StatusChipType.success;

      case 'completata':
      case 'completed':
        return StatusChipType.info;

      case 'annullata':
      case 'cancelled':
        return StatusChipType.error;

      case 'in attesa':
      case 'pending':
        return StatusChipType.warning;

      default:
        return StatusChipType.neutral;
    }
  }

  IconData get icon {
    switch (toLowerCase()) {
      case 'confermata':
      case 'confirmed':
        return Icons.check_circle;

      case 'completata':
      case 'completed':
        return Icons.task_alt;

      case 'annullata':
      case 'cancelled':
        return Icons.cancel;

      case 'in attesa':
      case 'pending':
        return Icons.schedule;

      default:
        return Icons.info;
    }
  }
}