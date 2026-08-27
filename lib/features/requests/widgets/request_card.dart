import 'package:flutter/material.dart';

import '../../shared/widgets/cards/app_section_card.dart';
import '../extensions/appointment_request_display_extension.dart';
import '../extensions/appointment_request_status_extension.dart';
import '../models/appointment_request.dart';
import 'request_status_chip.dart';
import 'request_type_chip.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    this.onTap,
  });

  final AppointmentRequest request;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final display = request.display;

    return AppSectionCard(
      heroTag: request.id,
      onTap: onTap,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: RequestStatusChip(
                  status: request.status,
                ),
              ),
              const SizedBox(width: 10),
              RequestTypeChip(
                type: request.type,
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            display.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.person,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  request.customerName.isEmpty
                      ? "Cliente"
                      : request.customerName,
                  style: TextStyle(
                    color:
                    Colors.grey.shade700,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          if (request.salonName.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.store,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    request.salonName,
                    style: TextStyle(
                      color: Colors
                          .grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Icon(
                display.icon,
                size: 16,
                color: display.color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  display.subtitle,
                  style: TextStyle(
                    color: Colors
                        .grey.shade600,
                  ),
                ),
              ),
            ],
          ),

          if (display.description
              .trim()
              .isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              display.description,
              style: TextStyle(
                color:
                Colors.grey.shade500,
                fontSize: 13,
              ),
            ),
          ],

          if (request.priority !=
              RequestPriority.normal) ...[
            const SizedBox(height: 16),
            _PriorityBanner(
              priority: request.priority,
            ),
          ],

          const SizedBox(height: 18),

          Divider(
            color: Colors.grey.shade200,
            height: 1,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Icon(
                request.status.icon,
                size: 16,
                color: request.status.color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  request.status.label,
                  style: TextStyle(
                    color:
                    request.status.color,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriorityBanner
    extends StatelessWidget {
  const _PriorityBanner({
    required this.priority,
  });

  final RequestPriority priority;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final IconData icon;
    late final String text;

    switch (priority) {
      case RequestPriority.low:
        color = Colors.green;
        icon = Icons.south;
        text = "Priorità bassa";
        break;

      case RequestPriority.normal:
        color = Colors.blue;
        icon = Icons.remove;
        text = "Priorità normale";
        break;

      case RequestPriority.high:
        color = Colors.orange;
        icon = Icons.priority_high;
        text = "Priorità alta";
        break;

      case RequestPriority.urgent:
        color = Colors.red;
        icon =
            Icons.warning_amber_rounded;
        text = "Priorità urgente";
        break;
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: .10,
        ),
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}