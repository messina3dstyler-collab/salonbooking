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

  factory ServiceModel.fromMap(String id, Map<String, dynamic> json) {
    return ServiceModel(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
    };
  }
}
