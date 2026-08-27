import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.compact = false,
    this.showIcon = true,
  });

  final String label;
  final Color color;
  final IconData? icon;

  final bool compact;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 220,
      ),
      curve: Curves.easeOut,

      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 5 : 6,
      ),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: .10,
        ),

        borderRadius:
        BorderRadius.circular(999),

        border: Border.all(
          color: color.withValues(
            alpha: .20,
          ),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          if (showIcon && icon != null) ...[
            Container(
              width: compact ? 18 : 22,
              height: compact ? 18 : 22,

              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: .12,
                ),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                color: color,
                size: compact ? 11 : 13,
              ),
            ),

            const SizedBox(width: 6),
          ],

          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w700,
              letterSpacing: .15,
            ),
          ),
        ],
      ),
    );
  }
}