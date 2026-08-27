import 'package:cloud_firestore/cloud_firestore.dart';

class AdminServiceModel {
  const AdminServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.duration,
    required this.price,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String category;
  final int duration;
  final double price;
  final bool active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AdminServiceModel.fromMap(
      String id,
      Map<String, dynamic> json,
      ) {
    return AdminServiceModel(
      id: id,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Altro',
      duration: _parseInt(json['duration']),
      price: _parseDouble(json['price']),
      active: _parseBool(json['active']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'duration': duration,
      'price': price,
      'active': active,
      if (createdAt != null)
        'createdAt': Timestamp.fromDate(createdAt!),
      if (updatedAt != null)
        'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  AdminServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? duration,
    double? price,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedPrice => '€ ${price.toStringAsFixed(2)}';

  String get formattedDuration => '$duration minuti';

  bool get isActive => active;

  static int _parseInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString().replaceAll(',', '.'),
    ) ??
        0;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    return value.toString().toLowerCase().trim() == 'true';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }
}