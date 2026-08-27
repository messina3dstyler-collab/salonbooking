import 'package:flutter/material.dart';

class RequestPayloadBadge extends StatelessWidget {
  const RequestPayloadBadge({
    super.key,
    required this.label,
    this.icon,
    this.color = Colors.green,
  });

  final String label;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: color.withValues(
            alpha: .10,
          ),
          borderRadius:
          BorderRadius.circular(50),
          border: Border.all(
            color: color.withValues(
              alpha: .20,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: color,
              ),

              const SizedBox(width: 6),
            ],

            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}