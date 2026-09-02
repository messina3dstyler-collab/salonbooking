import 'package:cloud_firestore/cloud_firestore.dart';

class SalonModel {
  const SalonModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.phone,
    required this.description,
    required this.openingHour,
    required this.closingHour,
    required this.closedWeekdays,
    required this.closedDates,
    required this.active,
    required this.taxIdType,
    required this.taxId,
  });

  final String id;
  final String name;
  final String address;
  final String city;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String phone;
  final String description;

  final int openingHour;
  final int closingHour;

  final List<int> closedWeekdays;
  final List<DateTime> closedDates;

  final bool active;

  /// Tipo di identificativo fiscale dell'attività.
  ///
  /// Valori previsti:
  /// - vat
  /// - fiscalCode
  final String taxIdType;

  /// Partita IVA oppure Codice Fiscale dell'attività.
  final String taxId;

  factory SalonModel.fromMap(
      String id,
      Map<String, dynamic> json,
      ) {
    return SalonModel(
      id: id,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      openingHour: json['openingHour'] ?? 9,
      closingHour: json['closingHour'] ?? 19,
      active: json['active'] ?? true,
      closedWeekdays: json['closedWeekdays'] is List
          ? List<int>.from(json['closedWeekdays'])
          : [],
      closedDates: json['closedDates'] is List
          ? (json['closedDates'] as List)
          .whereType<Timestamp>()
          .map((e) => e.toDate())
          .toList()
          : [],
      taxIdType: json['taxIdType'] ?? '',
      taxId: json['taxId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'phone': phone,
      'description': description,
      'openingHour': openingHour,
      'closingHour': closingHour,
      'active': active,
      'closedWeekdays': closedWeekdays,
      'closedDates': closedDates
          .map((e) => Timestamp.fromDate(e))
          .toList(),
      'taxIdType': taxIdType,
      'taxId': taxId,
    };
  }
}