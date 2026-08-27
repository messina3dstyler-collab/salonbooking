import 'package:flutter/material.dart';

class RequestDisplay {
  const RequestDisplay({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    this.highlight = false,
  });

  final String title;
  final String subtitle;
  final String description;

  final IconData icon;
  final Color color;

  final bool highlight;
}