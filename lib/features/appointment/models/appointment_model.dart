import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  const AppointmentModel({
    required this.id,
    required this.userId,
    required this.salonId,
    required this.employeeId,
    required this.serviceId,
    required this.date,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.duration,
    this.salonName = '',
    this.salonAddress = '',
    this.customerName = '',
    this.customerPhone = '',
    this.employeeName = '',
    this.employeePhone = '',
    this.employeeSpecialization = '',
    this.employeeRating = 0,
    this.serviceName = '',
    this.serviceDuration = 0,
    this.price = 0,
    this.notes = '',
    this.reviewId,
    this.hasReview = false,
    this.acceptedRequestId,
  });

  final String id;

  final String userId;

  final String salonId;
  final String salonName;
  final String salonAddress;

  final String customerName;
  final String customerPhone;

  final String employeeId;
  final String employeeName;
  final String employeePhone;
  final String employeeSpecialization;
  final double employeeRating;

  final String serviceId;
  final String serviceName;
  final int serviceDuration;
  final double price;

  final int duration;

  final Timestamp date;

  final String status;

  final Timestamp createdAt;
  final Timestamp updatedAt;

  final String notes;

  final String? reviewId;
  final bool hasReview;

  /// ID della Request che ha prodotto l'ultimo aggiornamento
  /// accettato dell'appuntamento.
  ///
  /// È opzionale per mantenere compatibilità con gli
  /// appuntamenti creati prima dell'introduzione del workflow
  /// Request -> Appointment.
  final String? acceptedRequestId;

  factory AppointmentModel.fromMap(
      String id,
      Map<String, dynamic> json,
      ) {
    return AppointmentModel(
      id: id,

      userId: json['userId']?.toString() ?? '',

      salonId: json['salonId']?.toString() ?? '',
      salonName: json['salonName']?.toString() ?? '',
      salonAddress: json['salonAddress']?.toString() ?? '',

      customerName: json['customerName']?.toString() ?? '',
      customerPhone: json['customerPhone']?.toString() ?? '',

      employeeId: json['employeeId']?.toString() ?? '',
      employeeName: json['employeeName']?.toString() ?? '',
      employeePhone: json['employeePhone']?.toString() ?? '',
      employeeSpecialization:
      json['employeeSpecialization']?.toString() ?? '',
      employeeRating: _double(json['employeeRating']),

      serviceId: json['serviceId']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',

      serviceDuration: _int(
        json['serviceDuration'] ?? json['duration'],
      ),

      duration: _int(
        json['duration'] ?? json['serviceDuration'],
      ),

      price: _double(json['price']),

      date: _timestamp(
        json['date'],
        fieldName: 'date',
      ),

      status: json['status']?.toString() ?? 'Prenotata',

      createdAt: _timestamp(
        json['createdAt'],
        fieldName: 'createdAt',
      ),

      updatedAt: _timestamp(
        json['updatedAt'],
        fieldName: 'updatedAt',
      ),

      notes: json['notes']?.toString() ?? '',

      reviewId: json['reviewId']?.toString(),

      hasReview: _bool(json['hasReview']),

      acceptedRequestId:
      json['acceptedRequestId']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,

      'salonId': salonId,
      'salonName': salonName,
      'salonAddress': salonAddress,

      'customerName': customerName,
      'customerPhone': customerPhone,

      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeePhone': employeePhone,
      'employeeSpecialization': employeeSpecialization,
      'employeeRating': employeeRating,

      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceDuration': serviceDuration,

      'duration': duration,

      'price': price,

      'date': date,

      'status': status,

      'createdAt': createdAt,
      'updatedAt': updatedAt,

      'notes': notes,

      'reviewId': reviewId,
      'hasReview': hasReview,

      'acceptedRequestId': acceptedRequestId,
    };
  }

  AppointmentModel copyWith({
    String? status,
    Timestamp? updatedAt,
    String? notes,
    String? reviewId,
    bool? hasReview,
    bool clearReview = false,
    int? duration,
    String? acceptedRequestId,
    bool clearAcceptedRequest = false,
  }) {
    return AppointmentModel(
      id: id,

      userId: userId,

      salonId: salonId,
      salonName: salonName,
      salonAddress: salonAddress,

      customerName: customerName,
      customerPhone: customerPhone,

      employeeId: employeeId,
      employeeName: employeeName,
      employeePhone: employeePhone,
      employeeSpecialization: employeeSpecialization,
      employeeRating: employeeRating,

      serviceId: serviceId,
      serviceName: serviceName,
      serviceDuration: serviceDuration,

      duration: duration ?? this.duration,

      price: price,

      date: date,

      status: status ?? this.status,

      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,

      notes: notes ?? this.notes,

      reviewId: clearReview
          ? null
          : reviewId ?? this.reviewId,

      hasReview: hasReview ?? this.hasReview,

      acceptedRequestId: clearAcceptedRequest
          ? null
          : acceptedRequestId ?? this.acceptedRequestId,
    );
  }

  DateTime get appointmentDate => date.toDate();

  DateTime get appointmentStart => date.toDate();

  DateTime get appointmentEnd =>
      appointmentStart.add(
        Duration(
          minutes: duration,
        ),
      );

  String get normalizedStatus =>
      status.trim().toLowerCase();

  bool get isPending =>
      normalizedStatus == 'prenotata';

  bool get isConfirmed =>
      normalizedStatus == 'confermata';

  bool get isCompleted =>
      normalizedStatus == 'completata';

  bool get isCancelled =>
      normalizedStatus == 'annullata';

  String get displayStatus {
    switch (normalizedStatus) {
      case 'prenotata':
        return 'In attesa';

      case 'confermata':
        return 'Confermata';

      case 'completata':
        return 'Completata';

      case 'annullata':
        return 'Annullata';

      default:
        return status;
    }
  }

  static Timestamp _timestamp(
      dynamic value, {
        required String fieldName,
      }) {
    if (value is Timestamp) {
      return value;
    }

    if (value is DateTime) {
      return Timestamp.fromDate(value);
    }

    throw StateError(
      "Il campo '$fieldName' dell'Appointment non contiene "
          "un Timestamp valido.",
    );
  }

  static int _int(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    final parsed = int.tryParse(
      value?.toString() ?? '',
    );

    return parsed ?? 0;
  }

  static double _double(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    final parsed = double.tryParse(
      (value?.toString() ?? '').replaceAll(',', '.'),
    );

    return parsed ?? 0;
  }

  static bool _bool(dynamic value) {
    if (value is bool) {
      return value;
    }

    return value?.toString().toLowerCase() == 'true';
  }
}