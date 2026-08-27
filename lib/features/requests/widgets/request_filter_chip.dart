import 'package:flutter/material.dart';

class RequestFilterChip extends StatelessWidget {
  const RequestFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onTap(),
      avatar: icon != null ? Icon(icon, size: 18) : null,
      label: Text(label),
    );
  }
}