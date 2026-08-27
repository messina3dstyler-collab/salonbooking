import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSecondaryAction extends StatelessWidget {
  const AppSecondaryAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.loading = false,
    this.enabled = true,
    this.color,
  });

  final String label;

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
      BorderRadius.circular(16),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(16),
        onTap: canTap
            ? () {
          HapticFeedback.selectionClick();
          onPressed!.call();
        }
            : null,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 220,
          ),
          curve: Curves.easeOut,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: canTap
                ? actionColor.withValues(
              alpha: .10,
            )
                : Colors.grey.shade100,
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: canTap
                  ? actionColor.withValues(
                alpha: .20,
              )
                  : Colors.grey.shade300,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 200,
            ),
            child: loading
                ? SizedBox(
              key: const ValueKey(
                'loading',
              ),
              width: 18,
              height: 18,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
                color: actionColor,
              ),
            )
                : Row(
              key: const ValueKey(
                'content',
              ),
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [

                Icon(
                  icon,
                  size: 18,
                  color: canTap
                      ? actionColor
                      : Colors.grey,
                ),

                const SizedBox(
                  width: 8,
                ),

                Flexible(
                  child: Text(
                    label,
                    overflow:
                    TextOverflow
                        .ellipsis,
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      color: canTap
                          ? actionColor
                          : Colors.grey,
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}