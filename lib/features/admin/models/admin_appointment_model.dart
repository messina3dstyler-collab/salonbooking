import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAppointmentModel {
  const AdminAppointmentModel({
    required this.id,
    required this.salonId,
    required this.userId,
    required this.employeeId,
    required this.serviceId,
    required this.date,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.customerName = '',
    this.customerPhone = '',
    this.customerEmail = '',
    this.employeeName = '',
    this.employeePhone = '',
    this.employeeSpecialization = '',
    this.employeeRating = 0,
    this.serviceName = '',
    this.serviceDuration = 0,
    this.price = 0,
    this.notes = '',
  });

  final String id;
  final String salonId;
  final String userId;
  final String employeeId;
  final String serviceId;

  final Timestamp date;
  final String status;

  final Timestamp createdAt;
  final Timestamp? updatedAt;

  final String customerName;
  final String customerPhone;
  final String customerEmail;

  final String employeeName;
  final String employeePhone;
  final String employeeSpecialization;
  final double employeeRating;

  final String serviceName;
  final int serviceDuration;
  final double price;

  final String notes;

  factory AdminAppointmentModel.fromMap(
      String id,
      Map<String, dynamic> data,
      ) {
    return AdminAppointmentModel(
      id: id,
      salonId: data['salonId']?.toString() ?? '',
      userId: data['userId']?.toString() ?? '',
      employeeId: data['employeeId']?.toString() ?? '',
      serviceId: data['serviceId']?.toString() ?? '',
      date: _timestamp(data['date']),
      status: data['status']?.toString() ?? 'Prenotata',
      createdAt: _timestamp(data['createdAt']),
      updatedAt: data['updatedAt'] == null ? null : _timestamp(data['updatedAt']),
      customerName: data['customerName']?.toString() ?? '',
      customerPhone: data['customerPhone']?.toString() ?? '',
      customerEmail: data['customerEmail']?.toString() ?? '',
      employeeName: data['employeeName']?.toString() ?? '',
      employeePhone: data['employeePhone']?.toString() ?? '',
      employeeSpecialization: data['employeeSpecialization']?.toString() ?? '',
      employeeRating: _double(data['employeeRating']),
      serviceName: data['serviceName']?.toString() ?? '',
      serviceDuration: _int(data['serviceDuration'] ?? data['duration']),
      price: _double(data['price']),
      notes: data['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'salonId': salonId,
    'userId': userId,
    'employeeId': employeeId,
    'serviceId': serviceId,
    'date': date,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'customerEmail': customerEmail,
    'employeeName': employeeName,
    'employeePhone': employeePhone,
    'employeeSpecialization': employeeSpecialization,
    'employeeRating': employeeRating,
    'serviceName': serviceName,
    'serviceDuration': serviceDuration,
    'price': price,
    'notes': notes,
  };

  AdminAppointmentModel copyWith({
    String? status,
    Timestamp? updatedAt,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? employeeName,
    String? employeePhone,
    String? employeeSpecialization,
    double? employeeRating,
    String? serviceName,
    int? serviceDuration,
    double? price,
    String? notes,
  }) {
    return AdminAppointmentModel(
      id: id,
      salonId: salonId,
      userId: userId,
      employeeId: employeeId,
      serviceId: serviceId,
      date: date,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      employeeName: employeeName ?? this.employeeName,
      employeePhone: employeePhone ?? this.employeePhone,
      employeeSpecialization:
      employeeSpecialization ?? this.employeeSpecialization,
      employeeRating: employeeRating ?? this.employeeRating,
      serviceName: serviceName ?? this.serviceName,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      price: price ?? this.price,
      notes: notes ?? this.notes,
    );
  }

  DateTime get appointmentDate => date.toDate();

  String get formattedDate {
    final d = appointmentDate;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String get formattedTime {
    final d = appointmentDate;
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  String get normalizedStatus => status.trim().toLowerCase();

  String get statusKey {
    switch (normalizedStatus) {
      case 'confermata':
        return 'confirmed';
      case 'completata':
        return 'completed';
      case 'annullata':
        return 'cancelled';
      case 'prenotata':
      case 'in attesa':
      case 'pending':
        return 'pending';
      default:
        return 'unknown';
    }
  }

  String get displayStatus {
    switch (statusKey) {
      case 'confirmed':
        return 'Confermata';
      case 'completed':
        return 'Completata';
      case 'cancelled':
        return 'Annullata';
      case 'pending':
        return 'In attesa';
      default:
        return status.isEmpty ? 'Sconosciuto' : status;
    }
  }

  bool get isPending => statusKey == 'pending';
  bool get isConfirmed => statusKey == 'confirmed';
  bool get isCompleted => statusKey == 'completed';
  bool get isCancelled => statusKey == 'cancelled';

  bool get hasSnapshotData =>
      customerName.isNotEmpty ||
          employeeName.isNotEmpty ||
          serviceName.isNotEmpty;

  static Timestamp _timestamp(dynamic value) {
    if (value is Timestamp) return value;
    if (value is DateTime) return Timestamp.fromDate(value);
    return Timestamp.now();
  }

  static int _int(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _double(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(
      value?.toString().replaceAll(',', '.') ?? '',
    ) ??
        0;
  }
}