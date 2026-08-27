class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.salonId,
    required this.name,
    required this.photoUrl,
    required this.phone,
    required this.active,
    required this.rating,
    required this.reviewCount,
    required this.specialization,
    required this.workingDays,
    required this.startHour,
    required this.endHour,
    required this.breakStart,
    required this.breakEnd,
  });

  final String id;
  final String salonId;

  final String name;
  final String photoUrl;
  final String phone;

  final bool active;

  final double rating;
  final int reviewCount;

  final String specialization;

  final List<int> workingDays;

  final int startHour;
  final int endHour;

  /// Minuti dall'inizio della giornata.
  /// 13:00 = 780
  final int breakStart;

  /// Minuti dall'inizio della giornata.
  /// 14:00 = 840
  final int breakEnd;

  factory EmployeeModel.fromMap(
      String id,
      Map<String, dynamic> json,
      ) {
    return EmployeeModel(
      id: id,
      salonId: json['salonId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      active: _bool(json['active']),
      rating: _double(json['rating']),
      reviewCount: _int(json['reviewCount']),
      specialization:
      json['specialization']?.toString() ?? '',
      workingDays:
      (json['workingDays'] as List?)
          ?.cast<int>() ??
          [1, 2, 3, 4, 5],
      startHour:
      _int(json['startHour']) == 0
          ? 9
          : _int(json['startHour']),
      endHour:
      _int(json['endHour']) == 0
          ? 18
          : _int(json['endHour']),
      breakStart:
      _int(json['breakStart']) == 0
          ? 13 * 60
          : _int(json['breakStart']),
      breakEnd:
      _int(json['breakEnd']) == 0
          ? 14 * 60
          : _int(json['breakEnd']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'salonId': salonId,
      'name': name,
      'photoUrl': photoUrl,
      'phone': phone,
      'active': active,
      'rating': rating,
      'reviewCount': reviewCount,
      'specialization': specialization,
      'workingDays': workingDays,
      'startHour': startHour,
      'endHour': endHour,
      'breakStart': breakStart,
      'breakEnd': breakEnd,
    };
  }

  EmployeeModel copyWith({
    String? salonId,
    String? name,
    String? photoUrl,
    String? phone,
    bool? active,
    double? rating,
    int? reviewCount,
    String? specialization,
    List<int>? workingDays,
    int? startHour,
    int? endHour,
    int? breakStart,
    int? breakEnd,
  }) {
    return EmployeeModel(
      id: id,
      salonId: salonId ?? this.salonId,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      active: active ?? this.active,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      specialization:
      specialization ?? this.specialization,
      workingDays:
      workingDays ?? this.workingDays,
      startHour:
      startHour ?? this.startHour,
      endHour:
      endHour ?? this.endHour,
      breakStart:
      breakStart ?? this.breakStart,
      breakEnd:
      breakEnd ?? this.breakEnd,
    );
  }

  bool get isAvailable => active;

  bool get hasReviews => reviewCount > 0;

  bool get hasBreak => breakEnd > breakStart;

  String get displayRating =>
      hasReviews
          ? '${rating.toStringAsFixed(1)} / 5'
          : 'Nessuna recensione';

  static double _double(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString().replaceAll(',', '.') ?? '',
    ) ??
        0;
  }

  static int _int(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static bool _bool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return true;
  }
}