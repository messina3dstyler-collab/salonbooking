import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 220,
    this.semanticLabel = 'SalonBooking Logo',
  });

  final double size;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'salonbooking-logo',
      child: Image.asset(
        'assets/logos/logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        semanticLabel: semanticLabel,
      ),
    );
  }
}
