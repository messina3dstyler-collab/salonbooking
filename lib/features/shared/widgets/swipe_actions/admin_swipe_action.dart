import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminSwipeAction extends StatefulWidget {
  const AdminSwipeAction({
    super.key,
    required this.child,
    this.leftColor = Colors.green,
    this.rightColor = Colors.orange,
    this.leftIcon = Icons.check_circle,
    this.rightIcon = Icons.edit,
    this.leftText = "Check-in",
    this.rightText = "Modifica",
    this.onLeftAction,
    this.onRightAction,
  });

  final Widget child;

  final Color leftColor;
  final Color rightColor;

  final IconData leftIcon;
  final IconData rightIcon;

  final String leftText;
  final String rightText;
  final VoidCallback? onLeftAction;
  final VoidCallback? onRightAction;

  @override
  State<AdminSwipeAction> createState() =>
      _AdminSwipeActionState();
}

class _AdminSwipeActionState
    extends State<AdminSwipeAction>
    with SingleTickerProviderStateMixin {
  double _drag = 0;
  bool _thresholdReached = false;
  static const double _triggerDistance = 90;
  static const double _maxDrag = 140;
  double get _progress {
    return (_drag.abs() / _triggerDistance)
        .clamp(0.0, 1.0);
  }

  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 260,
      ),
    );
  }

  void _animateBack() {
    _animation = Tween<double>(
      begin: _drag,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _animation.addListener(() {
      if (!mounted) return;

      setState(() {
        _drag = _animation.value;
      });
    });

    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,

      onHorizontalDragUpdate: (details) {
        setState(() {

          double delta = details.delta.dx;

          // -------------------------------------------------
          // Elasticità progressiva
          // -------------------------------------------------

          final resistance =
              1 - (_drag.abs() / 180).clamp(0.0, .55);

          delta *= resistance;

          // Movimento elastico
          _drag += delta;

// Snap magnetico
          if (_drag.abs() > _triggerDistance) {

            final direction = _drag.sign;

            final extra =
            (_drag.abs() - _triggerDistance)
                .clamp(0.0, 30.0);

            _drag =
                (direction * _triggerDistance) +
                    (extra * .35 * direction);
          }

          // -------------------------------------------------
          // Limite massimo
          // -------------------------------------------------

          if (_drag > _maxDrag) {
            _drag = _maxDrag;
          }

          if (_drag < -_maxDrag) {
            _drag = -_maxDrag;
          }

          // -------------------------------------------------
          // Feedback aptico
          // -------------------------------------------------

          final reached =
              _drag.abs() >= _triggerDistance;

          if (reached != _thresholdReached) {
            _thresholdReached = reached;

            if (reached) {
              HapticFeedback.mediumImpact();
            }
          }

        });
      },

      onHorizontalDragEnd: (_) {

        if (_drag >= 125) {

          HapticFeedback.heavyImpact();

          widget.onLeftAction?.call();

        } else if (_drag <= -125) {

          HapticFeedback.heavyImpact();

          widget.onRightAction?.call();
        }

        _animateBack();
      },

      onHorizontalDragCancel: () {
        _animateBack();
      },

      child: Stack(
        children: [

          //--------------------------------------------------
          // BACKGROUND
          //--------------------------------------------------

          Positioned.fill(
            child: Row(
              children: [

                Expanded(
                  child: _SwipeBackground(
                    visible: _drag > 0,
                    progress: _progress,
                    thresholdReached:
                    _thresholdReached && _drag > 0,
                    color: widget.leftColor,
                    icon: widget.leftIcon,
                    text: widget.leftText,
                    left: true,
                  ),
                ),

                Expanded(
                  child: _SwipeBackground(
                    visible: _drag < 0,
                    progress: _progress,
                    thresholdReached:
                    _thresholdReached && _drag < 0,
                    color: widget.rightColor,
                    icon: widget.rightIcon,
                    text: widget.rightText,
                    left: false,
                  ),
                ),

              ],
            ),
          ),

          //--------------------------------------------------
          // CARD
          //--------------------------------------------------

          Transform.translate(
            offset: Offset(_drag, 0),
            child: widget.child,
          ),

        ],
      ),
    );
  }

}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.visible,
    required this.progress,
    required this.thresholdReached,
    required this.color,
    required this.icon,
    required this.text,
    required this.left,
  });

  final bool visible;
  final bool thresholdReached;
  final double progress;

  final Color color;
  final IconData icon;
  final String text;

  final bool left;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 120,
      ),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: .35 + (.65 * progress),
        ),

        borderRadius:
        BorderRadius.circular(18),

        boxShadow: thresholdReached
            ? [
          BoxShadow(
            color: color.withValues(
              alpha: .35,
            ),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ]
            : null,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 22,
      ),

      alignment: left
          ? Alignment.centerLeft
          : Alignment.centerRight,

      child: Opacity(
        opacity: visible ? progress : 0,

        child: Transform.scale(
          scale: .8 + (.2 * progress),

          child: Row(
            mainAxisAlignment: left
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,

            children: left
                ? [
              Icon(
                icon,
                color: Colors.white,
                size: 22 + (8 * progress),
              ),

              const SizedBox(width: 10),

              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]
                : [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                icon,
                color: Colors.white,
                size: 22 + (8 * progress),
              ),
            ],
          ),
        ),
      ),
    );
  }
}