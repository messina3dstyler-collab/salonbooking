import 'package:flutter/material.dart';

import '../../../app/theme/theme.dart';

class AnimatedLoadingDots extends StatefulWidget {
  const AnimatedLoadingDots({
    super.key,
    this.dotSize = 10,
    this.spacing = 8,
    this.color = AppColors.primary,
  });

  final double dotSize;
  final double spacing;
  final Color color;

  @override
  State<AnimatedLoadingDots> createState() => _AnimatedLoadingDotsState();
}

class _AnimatedLoadingDotsState extends State<AnimatedLoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _scaleForDot(int index) {
    final value = (_controller.value + index * 0.2) % 1.0;

    if (value < 0.5) {
      return 0.8 + value * 0.8;
    }

    return 1.2 - ((value - 0.5) * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              child: Transform.scale(
                scale: _scaleForDot(index),
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
