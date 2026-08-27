import 'package:flutter/material.dart';

class AppointmentStatusChip extends StatelessWidget {
  const AppointmentStatusChip({
    super.key,
    required this.status,
  });

  final String status;

  Color get _backgroundColor {
    switch (status.toLowerCase()) {
      case 'confermata':
      case 'confirmed':
        return Colors.green.shade100;

      case 'in attesa':
      case 'pending':
        return Colors.orange.shade100;

      case 'completata':
      case 'completed':
        return Colors.blue.shade100;

      case 'annullata':
      case 'cancelled':
        return Colors.red.shade100;

      default:
        return Colors.grey.shade200;
    }
  }

  Color get _textColor {
    switch (status.toLowerCase()) {
      case 'confermata':
      case 'confirmed':
        return Colors.green.shade800;

      case 'in attesa':
      case 'pending':
        return Colors.orange.shade800;

      case 'completata':
      case 'completed':
        return Colors.blue.shade800;

      case 'annullata':
      case 'cancelled':
        return Colors.red.shade800;

      default:
        return Colors.grey.shade800;
    }
  }

  IconData get _icon {
    switch (status.toLowerCase()) {
      case 'confermata':
      case 'confirmed':
        return Icons.check_circle;

      case 'in attesa':
      case 'pending':
        return Icons.schedule;

      case 'completata':
      case 'completed':
        return Icons.task_alt;

      case 'annullata':
      case 'cancelled':
        return Icons.cancel;

      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        _icon,
        size: 18,
        color: _textColor,
      ),
      backgroundColor: _backgroundColor,
      side: BorderSide.none,
      label: Text(
        status,
        style: TextStyle(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
    );
  }
}