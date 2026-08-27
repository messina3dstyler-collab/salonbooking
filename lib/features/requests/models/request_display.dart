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

  RequestDisplay copyWith({
    String? title,
    String? subtitle,
    String? description,
    IconData? icon,
    Color? color,
    bool? highlight,
  }) {
    return RequestDisplay(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      highlight: highlight ?? this.highlight,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RequestDisplay &&
            title == other.title &&
            subtitle == other.subtitle &&
            description == other.description &&
            icon == other.icon &&
            color == other.color &&
            highlight == other.highlight;
  }

  @override
  int get hashCode => Object.hash(
    title,
    subtitle,
    description,
    icon,
    color,
    highlight,
  );

  @override
  String toString() {
    return 'RequestDisplay('
        'title: $title, '
        'subtitle: $subtitle, '
        'description: $description, '
        'highlight: $highlight'
        ')';
  }
}