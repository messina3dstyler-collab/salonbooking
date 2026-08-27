import 'package:flutter/material.dart';

import '../../shared/widgets/chips/app_chip.dart';
import '../extensions/appointment_request_status_extension.dart';
import '../models/appointment_request.dart';

class RequestStatusChip extends StatelessWidget {
  const RequestStatusChip({
    super.key,
    required this.status,
    this.compact = false,
    this.showIcon = true,
    this.expanded = false,
  });

  final AppointmentRequestStatus status;
  final bool compact;
  final bool showIcon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final chip = AppChip(
      label: status.label,
      color: status.color,
      icon: status.icon,
      compact: compact,
      showIcon: showIcon,
    );

    if (!expanded) {
      return chip;
    }

    return SizedBox(
      width: double.infinity,
      child: chip,
    );
  }
}