import 'package:flutter/material.dart';

import '../../shared/widgets/actions/app_primary_action.dart';
import '../../shared/widgets/actions/app_secondary_action.dart';

import '../builders/request_action_builder.dart';
import '../models/appointment_request.dart';
import '../models/request_action.dart';
import '../models/request_action_type.dart';

class RequestActionBar extends StatelessWidget {
  const RequestActionBar({
    super.key,
    required this.request,
    this.onSend,
    this.onRemind,
    this.onCancel,
    this.onOpenAppointment,
    this.onCreateNewProposal,
  });

  final AppointmentRequest request;

  final VoidCallback? onSend;
  final VoidCallback? onRemind;
  final VoidCallback? onCancel;
  final VoidCallback? onOpenAppointment;
  final VoidCallback? onCreateNewProposal;

  @override
  Widget build(BuildContext context) {
    final RequestActions actions =
    RequestActionBuilder.build(request);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPrimaryAction(
          icon: actions.primary.icon,
          label: actions.primary.label,
          subtitle: actions.primary.subtitle,
          color: actions.primary.color,
          enabled: actions.primary.enabled,
          onPressed: actions.primary.enabled
              ? _primaryCallback(request.status)
              : null,
        ),
        if (actions.secondary.isNotEmpty) ...[
          const SizedBox(height: 14),
          Row(
            children: actions.secondary
                .asMap()
                .entries
                .map(
                  (entry) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: entry.key ==
                        actions.secondary.length - 1
                        ? 0
                        : 12,
                  ),
                  child: AppSecondaryAction(
                    icon: entry.value.icon,
                    label: entry.value.label,
                    color: entry.value.color,
                    onPressed: _secondaryCallback(
                      entry.value.action,
                    ),
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ],
      ],
    );
  }

  VoidCallback? _primaryCallback(
      AppointmentRequestStatus status,
      ) {
    switch (status) {
      case AppointmentRequestStatus.draft:
        return onSend;

      case AppointmentRequestStatus.accepted:
        return onOpenAppointment;

      case AppointmentRequestStatus.rejected:
      case AppointmentRequestStatus.expired:
        return onCreateNewProposal;

      case AppointmentRequestStatus.pendingCustomer:
      case AppointmentRequestStatus.cancelled:
        return null;
    }
  }

  VoidCallback? _secondaryCallback(
      RequestActionType action,
      ) {
    switch (action) {
      case RequestActionType.send:
        return onSend;

      case RequestActionType.remind:
        return onRemind;

      case RequestActionType.cancel:
        return onCancel;

      case RequestActionType.openAppointment:
        return onOpenAppointment;

      case RequestActionType.newProposal:
        return onCreateNewProposal;
    }
  }
}