import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPrimaryAction extends StatelessWidget {
  const AppPrimaryAction({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.subtitle,
    this.loading = false,
    this.enabled = true,
    this.color,
  });

  final String label;
  final String? subtitle;

  final IconData icon;

  final VoidCallback? onPressed;

  final bool loading;
  final bool enabled;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actionColor =
        color ??
            theme.colorScheme.primary;

    final canTap =
        enabled &&
            !loading &&
            onPressed != null;

    return Material(
      color: Colors.transparent,
      borderRadius:
      BorderRadius.circular(18),

      child: InkWell(
        borderRadius:
        BorderRadius.circular(18),

        onTap: canTap
            ? () {
          HapticFeedback.lightImpact();
          onPressed!.call();
        }
            : null,

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 220,
          ),

          curve: Curves.easeOut,

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),

          decoration: BoxDecoration(
            color: canTap
                ? actionColor
                : Colors.grey.shade300,

            borderRadius:
            BorderRadius.circular(18),

            boxShadow: canTap
                ? [
              BoxShadow(
                color: actionColor.withValues(
                  alpha: .22,
                ),
                blurRadius: 16,
                offset: const Offset(
                  0,
                  6,
                ),
              ),
            ]
                : null,
          ),

          child: Row(
            children: [

              AnimatedSwitcher(
                duration:
                const Duration(
                  milliseconds: 220,
                ),

                child: loading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
                    : Icon(
                  icon,
                  key: ValueKey(icon),
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [

                    Text(
                      label,
                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    if (subtitle != null) ...[

                      const SizedBox(
                        height: 2,
                      ),

                      Text(
                        subtitle!,
                        style:
                        TextStyle(
                          color: Colors.white
                              .withValues(
                            alpha: .92,
                          ),
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}