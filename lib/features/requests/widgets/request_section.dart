import 'package:flutter/material.dart';

class RequestSection extends StatelessWidget {
  const RequestSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.spacing = 16,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        SizedBox(height: spacing),
        child,
      ],
    );
  }
}