import 'package:flutter/material.dart';

import '../models/request_timeline_event.dart';
import 'request_section.dart';
import 'request_timeline_tile.dart';

class RequestActivityFeed extends StatelessWidget {
  const RequestActivityFeed({
    super.key,
    required this.events,
    this.maxItems,
    this.onViewAll,
  });

  final List<RequestTimelineEvent> events;
  final int? maxItems;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return RequestSection(
        title: "Attività recenti",
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 42,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  "Nessuna attività disponibile.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final visibleEvents = maxItems == null
        ? events
        : events.take(maxItems!).toList();

    return RequestSection(
      title: "Attività recenti",
      subtitle:
      "${events.length} evento${events.length == 1 ? "" : "i"}",
      trailing: onViewAll == null
          ? null
          : TextButton(
        onPressed: onViewAll,
        child: const Text("Mostra tutto"),
      ),
      child: Column(
        children: [
          ...visibleEvents.map(
                (event) => Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              child: RequestTimelineTile(
                event: event,
              ),
            ),
          ),
        ],
      ),
    );
  }
}