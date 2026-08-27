import 'package:flutter/material.dart';

class RequestPayloadArrow extends StatelessWidget {
  const RequestPayloadArrow({
    super.key,
    this.color,
    this.label,
  });

  final Color? color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final arrowColor = color ?? Colors.grey.shade400;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
      child: Column(
        children: [

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: arrowColor.withValues(
                alpha: .10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_downward_rounded,
              color: arrowColor,
              size: 24,
            ),
          ),

          if (label != null) ...[

            const SizedBox(height: 8),

            Text(
              label!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}