import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.padding = const EdgeInsets.all(20),
    this.showDragHandle = true,
    this.showCloseButton = false,
    this.scrollable = true,
    this.initialChildSize = .72,
    this.minChildSize = .45,
    this.maxChildSize = .95,
  });

  final Widget child;

  final Widget? footer;

  final String? title;
  final String? subtitle;

  final Widget? leading;
  final Widget? trailing;

  final EdgeInsetsGeometry padding;

  final bool showDragHandle;
  final bool showCloseButton;
  final bool scrollable;

  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    Widget? footer,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    bool showCloseButton = false,
    bool scrollable = true,
    bool isDismissible = true,
    bool enableDrag = true,
    double initialChildSize = .72,
    double minChildSize = .45,
    double maxChildSize = .95,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (_) {
        return AppBottomSheet(
          child: child,
          footer: footer,
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          showCloseButton: showCloseButton,
          scrollable: scrollable,
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
        );
      },
    );
  }
  Widget _buildHeader(BuildContext context) {
    if (title == null &&
        subtitle == null &&
        leading == null &&
        trailing == null &&
        !showCloseButton) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        16,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          //--------------------------------------------------
          // LEADING
          //--------------------------------------------------

          if (leading != null) ...[
            leading!,
            const SizedBox(width: 14),
          ],

          //--------------------------------------------------
          // TITLE
          //--------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                if (subtitle != null) ...[
                  const SizedBox(height: 4),

                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          //--------------------------------------------------
          // ACTIONS
          //--------------------------------------------------

          Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [

              if (trailing != null)
                trailing!,

              if (showCloseButton) ...[

                if (trailing != null)
                  const SizedBox(width: 6),

                IconButton(
                  tooltip: "Chiudi",

                  splashRadius: 22,

                  onPressed: () {
                    Navigator.of(context).pop();
                  },

                  icon: const Icon(
                    Icons.close_rounded,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(
        milliseconds: 220,
      ),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: bottomInset,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (
          context,
          scrollController,
        ) {

          final Widget content;

          if (scrollable) {
            content = SingleChildScrollView(
              controller: scrollController,
              physics:
                  const BouncingScrollPhysics(),
              padding: padding,
              child: child,
            );
          } else {
            content = Padding(
              padding: padding,
              child: child,
            );
          }

          return AnimatedContainer(
            duration: const Duration(
              milliseconds: 220,
            ),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(30),
              ),

              border: Border.all(
                color: Colors.black.withValues(
                  alpha: .04,
                ),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: .10,
                  ),
                  blurRadius: 24,
                  offset: const Offset(
                    0,
                    -6,
                  ),
                ),
              ],
            ),

            child: Column(
              children: [
                //--------------------------------------------------
                // HANDLE
                //--------------------------------------------------

                if (showDragHandle) ...[
                  const SizedBox(height: 12),

                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(
                        100,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                ],

                //--------------------------------------------------
                // HEADER
                //--------------------------------------------------

                _buildHeader(context),

                if (title != null ||
                    subtitle != null ||
                    leading != null ||
                    trailing != null ||
                    showCloseButton)
                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),

                //--------------------------------------------------
                // BODY
                //--------------------------------------------------

                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    child: content,
                  ),
                ),

                //--------------------------------------------------
                // FOOTER
                //--------------------------------------------------

                if (footer != null) ...[
                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),

                  SafeArea(
                    top: false,

                    child: Container(
                      width: double.infinity,

                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        16,
                        20,
                        20,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(
                              alpha: .04,
                            ),
                            blurRadius: 10,
                            offset: const Offset(
                              0,
                              -2,
                            ),
                          ),
                        ],
                      ),

                      child: footer!,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}