import 'package:cloud_firestore/cloud_firestore.dart';

/// Stati ufficiali del ciclo di vita di un Appointment.
///
/// Manteniamo intenzionalmente le String per compatibilità con
/// Firestore, Rules e codice esistente.
abstract final class AppointmentStatus {
  static const String pending = 'Prenotata';
  static const String confirmed = 'Confermata';
  static const String completed = 'Completata';
  static const String cancelled = 'Annullata';

  static const Set<String> values = <String>{
    pending,
    confirmed,
    completed,
    cancelled,
  };

  static bool isKnown(String status) {
    return values.contains(
      status.trim().toLowerCase() == pending.toLowerCase()
          ? pending
          : status.trim().toLowerCase() == confirmed.toLowerCase()
          ? confirmed
          : status.trim().toLowerCase() == completed.toLowerCase()
          ? completed
          : status.trim().toLowerCase() == cancelled.toLowerCase()
          ? cancelled
          : status,
    );
  }
}

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

  // =========================================================
  // IDENTITÀ
  // =========================================================

  final String id;

  final String userId;

  final String salonId;

  // =========================================================
  // SALONE
  // =========================================================

  final String salonName;
  final String salonAddress;

  // =========================================================
  // CLIENTE
  // =========================================================

  final String customerName;
  final String customerPhone;

  // =========================================================
  // DIPENDENTE
  // =========================================================

  final String employeeId;
  final String employeeName;
  final String employeePhone;
  final String employeeSpecialization;
  final double employeeRating;

  // =========================================================
  // SERVIZIO
  // =========================================================

  final String serviceId;
  final String serviceName;
  final int serviceDuration;
  final double price;

  // =========================================================
  // APPUNTAMENTO
  // =========================================================

  final int duration;

  final Timestamp date;

  final String status;

  final Timestamp createdAt;
  final Timestamp updatedAt;

  final String notes;

  // =========================================================
  // RECENSIONE
  // =========================================================

  final String? reviewId;
  final bool hasReview;

  // =========================================================
  // REQUEST INTEGRATION
  // =========================================================

  /// ID della Request che ha prodotto l'ultimo aggiornamento
  /// accettato dell'appuntamento.
  ///
  /// È opzionale per mantenere compatibilità con gli
  /// appuntamenti creati prima dell'introduzione del workflow
  /// Request -> Appointment.
  final String? acceptedRequestId;

  // =========================================================
  // FIRESTORE -> MODEL
  // =========================================================

  factory AppointmentModel.fromMap(
      String id,
      Map<String, dynamic> json,
      ) {
    final int parsedServiceDuration = _int(
      json['serviceDuration'] ?? json['duration'],
    );

    final int parsedDuration = _int(
      json['duration'] ?? json['serviceDuration'],
    );

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

      serviceDuration: parsedServiceDuration,

      duration: parsedDuration,

      price: _double(json['price']),

      date: _timestamp(
        json['date'],
        fieldName: 'date',
      ),

      status: json['status']?.toString() ?? AppointmentStatus.pending,

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

  // =========================================================
  // MODEL -> FIRESTORE
  // =========================================================

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

  // =========================================================
  // COPY
  // =========================================================

  AppointmentModel copyWith({
    String? status,
    Timestamp? updatedAt,
    String? notes,
    String? reviewId,
    bool? hasReview,
    bool clearReview = false,

    Timestamp? date,

    String? employeeId,
    String? employeeName,
    String? employeePhone,
    String? employeeSpecialization,
    double? employeeRating,

    String? serviceId,
    String? serviceName,
    int? serviceDuration,

    int? duration,

    double? price,

    String? acceptedRequestId,
    bool clearAcceptedRequest = false,
  }) {
    final int resolvedDuration =
        duration ?? this.duration;

    final int resolvedServiceDuration =
        serviceDuration ??
            (duration != null
                ? resolvedDuration
                : this.serviceDuration);

    return AppointmentModel(
      id: id,

      userId: userId,

      salonId: salonId,
      salonName: salonName,
      salonAddress: salonAddress,

      customerName: customerName,
      customerPhone: customerPhone,

      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeePhone:
      employeePhone ?? this.employeePhone,
      employeeSpecialization:
      employeeSpecialization ??
          this.employeeSpecialization,
      employeeRating:
      employeeRating ?? this.employeeRating,

      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceDuration: resolvedServiceDuration,

      duration: resolvedDuration,

      price: price ?? this.price,

      date: date ?? this.date,

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
          : acceptedRequestId ??
          this.acceptedRequestId,
    );
  }

  // =========================================================
  // DATE / TIME
  // =========================================================

  DateTime get appointmentDate => date.toDate();

  DateTime get appointmentStart => date.toDate();

  DateTime get appointmentEnd =>
      appointmentStart.add(
        Duration(
          minutes: duration,
        ),
      );

  // =========================================================
  // STATUS
  // =========================================================

  String get normalizedStatus =>
      status.trim().toLowerCase();

  bool get isPending =>
      normalizedStatus ==
          AppointmentStatus.pending.toLowerCase();

  bool get isConfirmed =>
      normalizedStatus ==
          AppointmentStatus.confirmed.toLowerCase();

  bool get isCompleted =>
      normalizedStatus ==
          AppointmentStatus.completed.toLowerCase();

  bool get isCancelled =>
      normalizedStatus ==
          AppointmentStatus.cancelled.toLowerCase();

  bool get isFinal =>
      isCompleted || isCancelled;

  bool get isActive =>
      isPending || isConfirmed;

  bool get isKnownStatus =>
      isPending ||
          isConfirmed ||
          isCompleted ||
          isCancelled;

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

  // =========================================================
  // DOMAIN VALIDATION HELPERS
  // =========================================================

  /// Verifica che gli identificativi fondamentali
  /// dell'Appointment siano valorizzati.
  ///
  /// Non sostituisce le Firestore Rules.
  bool get hasValidIdentity =>
      id.trim().isNotEmpty &&
          userId.trim().isNotEmpty &&
          salonId.trim().isNotEmpty &&
          employeeId.trim().isNotEmpty &&
          serviceId.trim().isNotEmpty;

  /// Verifica che i dati temporali siano utilizzabili.
  ///
  /// Non sostituisce il controllo di disponibilità
  /// effettuato dal workflow di prenotazione.
  bool get hasValidSchedule =>
      duration > 0;

  /// Verifica la struttura minima del documento Appointment.
  ///
  /// Non esegue controlli di ownership o appartenenza
  /// employee/service -> salon: quelli appartengono
  /// al dominio applicativo e alle Security Rules.
  bool get isStructurallyValid =>
      hasValidIdentity &&
          hasValidSchedule &&
          isKnownStatus;

  // =========================================================
  // FIRESTORE PARSING HELPERS
  // =========================================================

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