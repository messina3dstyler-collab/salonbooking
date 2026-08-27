import 'package:flutter/material.dart';

class ScaleAnimation extends StatelessWidget {
  const ScaleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutBack,
    this.begin = 0.85,
    this.end = 1.0,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double begin;
  final double end;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: child,
    );
  }
}
