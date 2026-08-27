import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSectionCard extends StatefulWidget {
  const AppSectionCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor = Colors.white,
    this.borderRadius = 22,
    this.heroTag,
    this.animateOnAppear = true,
    this.elevation = true,
  });

  final Widget child;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final EdgeInsetsGeometry padding;

  final Color backgroundColor;

  final double borderRadius;

  final Object? heroTag;

  final bool animateOnAppear;

  final bool elevation;

  @override
  State<AppSectionCard> createState() =>
      _AppSectionCardState();
}

class _AppSectionCardState
    extends State<AppSectionCard> {

  bool _visible = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget card = AnimatedOpacity(
      duration: Duration(
        milliseconds:
        widget.animateOnAppear ? 220 : 0,
      ),
      opacity: widget.animateOnAppear
          ? (_visible ? 1 : 0)
          : 1,

      child: AnimatedScale(
        duration: Duration(
          milliseconds:
          widget.animateOnAppear ? 220 : 0,
        ),
        curve: Curves.easeOutBack,
        scale: widget.animateOnAppear
            ? (_visible ? 1 : .97)
            : 1,

        child: Material(
          color: Colors.transparent,

          borderRadius:
          BorderRadius.circular(
            widget.borderRadius,
          ),

          child: InkWell(
            borderRadius:
            BorderRadius.circular(
              widget.borderRadius,
            ),

            onTapDown: (_) {
              setState(() {
                _pressed = true;
              });
            },

            onTapCancel: () {
              setState(() {
                _pressed = false;
              });
            },

            onTapUp: (_) {
              setState(() {
                _pressed = false;
              });

              HapticFeedback.lightImpact();

              widget.onTap?.call();
            },

            onLongPress: () {
              HapticFeedback.mediumImpact();

              widget.onLongPress?.call();
            },

            child: AnimatedScale(
              duration: const Duration(
                milliseconds: 110,
              ),
              scale: _pressed ? .985 : 1,

              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 180,
                ),

                curve: Curves.easeOut,

                padding: widget.padding,

                decoration: BoxDecoration(
                  color: widget.backgroundColor,

                  borderRadius:
                  BorderRadius.circular(
                    widget.borderRadius,
                  ),

                  border: Border.all(
                    color: Colors.black
                        .withValues(alpha: .05),
                  ),

                  boxShadow: widget.elevation
                      ? [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: _pressed
                            ? .03
                            : .07,
                      ),
                      blurRadius:
                      _pressed
                          ? 6
                          : 16,
                      offset: Offset(
                        0,
                        _pressed
                            ? 2
                            : 6,
                      ),
                    ),
                  ]
                      : null,
                ),

                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.heroTag != null) {
      card = Hero(
        tag: widget.heroTag!,
        child: card,
      );
    }

    return card;
  }
}