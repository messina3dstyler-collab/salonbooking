import 'package:flutter/material.dart';

class RequestPayloadCard extends StatelessWidget {
  const RequestPayloadCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  final String title;
  final String value;
  final String? subtitle;

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: .06,
        ),

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: color.withValues(
            alpha: .18,
          ),
        ),
      ),

      child: Row(
        children: [

          //--------------------------------------------------
          // ICONA
          //--------------------------------------------------

          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: color.withValues(
                alpha: .12,
              ),
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 16),

          //--------------------------------------------------
          // TESTO
          //--------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                if (subtitle != null) ...[

                  const SizedBox(height: 4),

                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}