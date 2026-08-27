import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.salonId,
    required this.userId,
    required this.appointmentId,
    required this.rating,
    required this.createdAt,

    this.userName = '',
    this.userPhoto = '',

    this.employeeId = '',
    this.employeeName = '',
    this.employeePhone = '',
    this.employeeSpecialization = '',
    this.employeeRating = 0,

    this.serviceId = '',
    this.serviceName = '',

    this.comment = '',

    this.updatedAt,
  });

  final String id;

  final String salonId;
  final String userId;
  final String appointmentId;

  /// Cliente
  final String userName;
  final String userPhoto;

  /// Operatore
  final String employeeId;
  final String employeeName;
  final String employeePhone;
  final String employeeSpecialization;
  final double employeeRating;

  /// Servizio
  final String serviceId;
  final String serviceName;

  /// Recensione
  final double rating;
  final String comment;

  final Timestamp createdAt;
  final Timestamp? updatedAt;

  factory ReviewModel.fromMap(
      String id,
      Map<String, dynamic> data,
      ) {
    return ReviewModel(
      id: id,

      salonId: data['salonId']?.toString() ?? '',
      userId: data['userId']?.toString() ?? '',
      appointmentId: data['appointmentId']?.toString() ?? '',

      userName: data['userName']?.toString() ?? '',
      userPhoto: data['userPhoto']?.toString() ?? '',

      employeeId: data['employeeId']?.toString() ?? '',
      employeeName: data['employeeName']?.toString() ?? '',
      employeePhone: data['employeePhone']?.toString() ?? '',
      employeeSpecialization:
      data['employeeSpecialization']?.toString() ?? '',

      employeeRating: _double(data['employeeRating']),

      serviceId: data['serviceId']?.toString() ?? '',
      serviceName: data['serviceName']?.toString() ?? '',

      rating: _double(data['rating']),
      comment: data['comment']?.toString() ?? '',

      createdAt: _timestamp(data['createdAt']),

      updatedAt: data['updatedAt'] == null
          ? null
          : _timestamp(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'salonId': salonId,
      'userId': userId,
      'appointmentId': appointmentId,

      'userName': userName,
      'userPhoto': userPhoto,

      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeePhone': employeePhone,
      'employeeSpecialization': employeeSpecialization,
      'employeeRating': employeeRating,

      'serviceId': serviceId,
      'serviceName': serviceName,

      'rating': rating,
      'comment': comment,

      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ReviewModel copyWith({
    String? id,

    String? salonId,
    String? userId,
    String? appointmentId,

    String? userName,
    String? userPhoto,

    String? employeeId,
    String? employeeName,
    String? employeePhone,
    String? employeeSpecialization,
    double? employeeRating,

    String? serviceId,
    String? serviceName,

    double? rating,
    String? comment,

    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,

      salonId: salonId ?? this.salonId,
      userId: userId ?? this.userId,
      appointmentId: appointmentId ?? this.appointmentId,

      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,

      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeePhone: employeePhone ?? this.employeePhone,
      employeeSpecialization:
      employeeSpecialization ?? this.employeeSpecialization,
      employeeRating:
      employeeRating ?? this.employeeRating,

      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,

      rating: rating ?? this.rating,
      comment: comment ?? this.comment,

      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  DateTime get reviewDate => createdAt.toDate();

  String get displayRating =>
      '${rating.toStringAsFixed(1)} / 5';

  bool get hasComment => comment.trim().isNotEmpty;

  bool get hasUserName => userName.trim().isNotEmpty;

  bool get hasEmployeeName =>
      employeeName.trim().isNotEmpty;

  bool get hasServiceName =>
      serviceName.trim().isNotEmpty;

  static Timestamp _timestamp(dynamic value) {
    if (value is Timestamp) return value;

    if (value is DateTime) {
      return Timestamp.fromDate(value);
    }

    return Timestamp.now();
  }

  static double _double(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString().replaceAll(',', '.') ?? '',
    ) ??
        0;
  }
}