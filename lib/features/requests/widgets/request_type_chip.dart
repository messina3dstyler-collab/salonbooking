import 'package:flutter/material.dart';

import '../../shared/widgets/chips/app_chip.dart';
import '../extensions/appointment_request_type_extension.dart';
import '../models/appointment_request.dart';

class RequestTypeChip extends StatelessWidget {
  const RequestTypeChip({
    super.key,
    required this.type,
    this.compact = false,
    this.showIcon = true,
    this.expanded = false,
  });

  final AppointmentRequestType type;
  final bool compact;
  final bool showIcon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final chip = AppChip(
      label: type.label,
      color: type.color,
      icon: type.icon,
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