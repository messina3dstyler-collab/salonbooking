class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
  });

  final String id;

  final String name;

  final String description;

  final double price;

  final int duration;

  // =====================================================
  // FROM FIRESTORE
  // =====================================================

  factory ServiceModel.fromMap(
      String id,
      Map<String, dynamic> json,
      ) {
    return ServiceModel(
      id: id,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _parseDouble(
        json['price'],
      ),
      duration: _parseInt(
        json['duration'],
      ),
    );
  }

  // =====================================================
  // TO FIRESTORE
  // =====================================================

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
    };
  }

  // =====================================================
  // COPY WITH
  // =====================================================

  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? duration,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
    );
  }

  // =====================================================
  // FORMATTERS
  // =====================================================

  String get formattedPrice {
    return '€ ${price.toStringAsFixed(2)}';
  }

  String get formattedDuration {
    return '$duration min';
  }

  // =====================================================
  // PARSER
  // =====================================================

  static int _parseInt(
      dynamic value,
      ) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }

  static double _parseDouble(
      dynamic value,
      ) {
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
}