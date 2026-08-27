import 'package:flutter/material.dart';

import '../models/request_timeline_event.dart';
import 'request_timeline_tile.dart';

class RequestTimeline extends StatelessWidget {
  const RequestTimeline({
    super.key,
    required this.events,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    this.padding,
  });

  final List<RequestTimelineEvent> events;

  final bool shrinkWrap;

  final ScrollPhysics physics;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const _EmptyTimeline();
    }

    final sorted = [...events]
      ..sort(
            (a, b) => a.createdAt.compareTo(
          b.createdAt,
        ),
      );

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,

      itemCount: sorted.length,

      separatorBuilder: (_, _) =>
      const SizedBox(height: 2),

      itemBuilder: (_, index) {
        return RequestTimelineTile(
          event: sorted[index],
          isFirst: index == 0,
          isLast: index == sorted.length - 1,
        );
      },
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [

          Icon(
            Icons.history,
            size: 36,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          Text(
            "Nessun evento disponibile",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "La cronologia verrà popolata automaticamente.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}