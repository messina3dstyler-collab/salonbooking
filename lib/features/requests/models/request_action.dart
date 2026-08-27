import 'package:flutter/material.dart';

import 'request_action_type.dart';

class RequestAction {
  const RequestAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.color,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color? color;
  final bool enabled;

  RequestAction copyWith({
    IconData? icon,
    String? label,
    String? subtitle,
    Color? color,
    bool? enabled,
  }) {
    return RequestAction(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      subtitle: subtitle ?? this.subtitle,
      color: color ?? this.color,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RequestAction &&
            icon == other.icon &&
            label == other.label &&
            subtitle == other.subtitle &&
            color == other.color &&
            enabled == other.enabled;
  }

  @override
  int get hashCode => Object.hash(
    icon,
    label,
    subtitle,
    color,
    enabled,
  );

  @override
  String toString() {
    return 'RequestAction('
        'label: $label, '
        'enabled: $enabled'
        ')';
  }
}

class RequestActions {
  const RequestActions({
    required this.primary,
    this.secondary = const [],
  });

  final RequestAction primary;
  final List<RequestActionButton> secondary;

  RequestActions copyWith({
    RequestAction? primary,
    List<RequestActionButton>? secondary,
  }) {
    return RequestActions(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RequestActions &&
            primary == other.primary &&
            _listEquals(secondary, other.secondary);
  }

  @override
  int get hashCode => Object.hash(
    primary,
    Object.hashAll(secondary),
  );
}

class RequestActionButton {
  const RequestActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.action,
  });

  final IconData icon;
  final String label;
  final Color color;
  final RequestActionType action;

  RequestActionButton copyWith({
    IconData? icon,
    String? label,
    Color? color,
    RequestActionType? action,
  }) {
    return RequestActionButton(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      color: color ?? this.color,
      action: action ?? this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RequestActionButton &&
            icon == other.icon &&
            label == other.label &&
            color == other.color &&
            action == other.action;
  }

  @override
  int get hashCode => Object.hash(
    icon,
    label,
    color,
    action,
  );

  @override
  String toString() {
    return 'RequestActionButton('
        'label: $label, '
        'action: $action'
        ')';
  }
}

bool _listEquals<T>(
    List<T> a,
    List<T> b,
    ) {
  if (identical(a, b)) return true;

  if (a.length != b.length) {
    return false;
  }

  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }

  return true;
}