import 'package:flutter/material.dart';

import '../models/request_timeline_event.dart';
import '../extensions/request_author_extension.dart';
import '../extensions/request_timeline_event_extension.dart';
import '../extensions/request_timeline_event_type_extension.dart';

class RequestTimelineTile extends StatelessWidget {
  const RequestTimelineTile({
    super.key,
    required this.event,
    this.isFirst = false,
    this.isLast = false,
  });

  final RequestTimelineEvent event;

  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = event.type.color;
    final icon = event.type.icon;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //--------------------------------------------
          // Timeline
          //--------------------------------------------

          SizedBox(
            width: 42,
            child: Column(
              children: [

                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : Colors.grey.shade300,
                  ),
                ),

                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(
                      alpha: .12,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(
                        alpha: .25,
                      ),
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: color,
                  ),
                ),

                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          //--------------------------------------------
          // Contenuto
          //--------------------------------------------

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    event.type.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    event.author.label,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (event.message != null &&
                      event.message!.isNotEmpty) ...[

                    const SizedBox(height: 8),

                    Text(
                      event.message!,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      Icon(
                        Icons.schedule,
                        size: 15,
                        color: Colors.grey.shade500,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        event.createdAtLabel,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}