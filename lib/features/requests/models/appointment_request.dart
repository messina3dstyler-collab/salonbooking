import 'payloads/appointment_request_payload.dart';
import 'payloads/cancel_request_payload.dart';
import 'payloads/custom_request_payload.dart';
import 'payloads/employee_request_payload.dart';
import 'payloads/reschedule_request_payload.dart';
import 'payloads/services_request_payload.dart';

enum AppointmentRequestType {
  reschedule,
  changeEmployee,
  changeServices,
  cancelAppointment,
  custom,
}

enum AppointmentRequestStatus {
  draft,
  pendingCustomer,
  accepted,
  rejected,
  expired,
  cancelled,
}

/// Chi ha creato la proposta oppure chi ha generato
/// un evento nella timeline.
enum RequestAuthor {
  admin,
  employee,
  customer,
  system,
}

/// Chi deve compiere la prossima azione.
enum RequestActionOwner {
  salon,
  customer,
  system,
  none,
}

enum RequestPriority {
  low,
  normal,
  high,
  urgent,
}

class AppointmentRequest {
  const AppointmentRequest({
    required this.id,
    required this.appointmentId,
    required this.salonId,
    this.salonName = "",
    required this.customerId,
    this.customerName = "",
    this.customerPhone = "",
    required this.createdBy,
    this.createdByName = "",
    required this.priority,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.payload,
  });

  final String id;

  /// Appuntamento sul quale viene proposta la modifica.
  final String appointmentId;

  final String salonId;
  final String salonName;

  final String customerId;
  final String customerName;
  final String customerPhone;

  /// Chi ha creato la proposta.
  ///
  /// Nel modello applicativo il customer non crea Request.
  /// La proposta può essere creata dal salone/admin,
  /// da un dipendente operativo del salone oppure dal sistema.
  final RequestAuthor createdBy;
  final String createdByName;

  final RequestPriority priority;

  final AppointmentRequestType type;

  final AppointmentRequestStatus status;

  final DateTime createdAt;

  final DateTime updatedAt;

  /// Dati specifici della proposta.
  final Map<String, dynamic> payload;

  AppointmentRequest copyWith({
    String? id,
    String? appointmentId,
    String? salonId,
    String? salonName,
    String? customerId,
    String? customerName,
    String? customerPhone,
    RequestAuthor? createdBy,
    String? createdByName,
    RequestPriority? priority,
    AppointmentRequestType? type,
    AppointmentRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? payload,
  }) {
    return AppointmentRequest(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      salonId: salonId ?? this.salonId,
      salonName: salonName ?? this.salonName,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      priority: priority ?? this.priority,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "appointmentId": appointmentId,
      "salonId": salonId,
      "salonName": salonName,
      "customerId": customerId,
      "customerName": customerName,
      "customerPhone": customerPhone,
      "createdBy": createdBy.name,
      "createdByName": createdByName,
      "priority": priority.name,
      "type": type.name,
      "status": status.name,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "payload": payload,
    };
  }

  factory AppointmentRequest.fromMap(
      Map<String, dynamic> map,
      ) {
    return AppointmentRequest(
      id: map["id"] ?? "",
      appointmentId: map["appointmentId"] ?? "",
      salonId: map["salonId"] ?? "",
      salonName: map["salonName"] ?? "",
      customerId: map["customerId"] ?? "",
      customerName: map["customerName"] ?? "",
      customerPhone: map["customerPhone"] ?? "",
      createdBy: RequestAuthor.values.byName(
        map["createdBy"] ?? "admin",
      ),
      createdByName: map["createdByName"] ?? "",
      priority: RequestPriority.values.byName(
        map["priority"] ?? "normal",
      ),
      type: AppointmentRequestType.values.byName(
        map["type"] ?? "custom",
      ),
      status: AppointmentRequestStatus.values.byName(
        map["status"] ?? "draft",
      ),
      createdAt: DateTime.parse(
        map["createdAt"],
      ),
      updatedAt: DateTime.parse(
        map["updatedAt"],
      ),
      payload: Map<String, dynamic>.from(
        map["payload"] ?? {},
      ),
    );
  }

  // --------------------------------------------------
  // TYPE
  // --------------------------------------------------

  bool get isReschedule =>
      type == AppointmentRequestType.reschedule;

  bool get isEmployeeChange =>
      type == AppointmentRequestType.changeEmployee;

  bool get isServicesChange =>
      type == AppointmentRequestType.changeServices;

  bool get isCancellation =>
      type == AppointmentRequestType.cancelAppointment;

  bool get isCustom =>
      type == AppointmentRequestType.custom;

  // --------------------------------------------------
  // STATUS
  // --------------------------------------------------

  bool get isDraft =>
      status == AppointmentRequestStatus.draft;

  bool get isPending =>
      status == AppointmentRequestStatus.pendingCustomer;

  bool get isAccepted =>
      status == AppointmentRequestStatus.accepted;

  bool get isRejected =>
      status == AppointmentRequestStatus.rejected;

  bool get isExpired =>
      status == AppointmentRequestStatus.expired;

  bool get isCancelled =>
      status == AppointmentRequestStatus.cancelled;

  bool get isClosed =>
      isAccepted ||
          isRejected ||
          isExpired ||
          isCancelled;

  // --------------------------------------------------
  // AUTHOR
  // --------------------------------------------------

  bool get createdByAdmin =>
      createdBy == RequestAuthor.admin;

  bool get createdByEmployee =>
      createdBy == RequestAuthor.employee;

  bool get createdBySystem =>
      createdBy == RequestAuthor.system;

  // --------------------------------------------------
  // PRIORITY
  // --------------------------------------------------

  bool get isLowPriority =>
      priority == RequestPriority.low;

  bool get isNormalPriority =>
      priority == RequestPriority.normal;

  bool get isHighPriority =>
      priority == RequestPriority.high;

  bool get isUrgentPriority =>
      priority == RequestPriority.urgent;

  // --------------------------------------------------
  // PAYLOAD
  // --------------------------------------------------

  bool get hasPayload => payload.isNotEmpty;

  AppointmentRequestPayload get payloadObject {
    switch (type) {
      case AppointmentRequestType.reschedule:
        return RescheduleRequestPayload.fromMap(
          payload,
        );

      case AppointmentRequestType.changeEmployee:
        return EmployeeRequestPayload.fromMap(
          payload,
        );

      case AppointmentRequestType.changeServices:
        return ServicesRequestPayload.fromMap(
          payload,
        );

      case AppointmentRequestType.cancelAppointment:
        return CancelRequestPayload.fromMap(
          payload,
        );

      case AppointmentRequestType.custom:
        return CustomRequestPayload.fromMap(
          payload,
        );
    }
  }

  RescheduleRequestPayload get reschedulePayload =>
      payloadObject as RescheduleRequestPayload;

  EmployeeRequestPayload get employeePayload =>
      payloadObject as EmployeeRequestPayload;

  ServicesRequestPayload get servicesPayload =>
      payloadObject as ServicesRequestPayload;

  CancelRequestPayload get cancelPayload =>
      payloadObject as CancelRequestPayload;

  CustomRequestPayload get customPayload =>
      payloadObject as CustomRequestPayload;

  T payloadAs<T extends AppointmentRequestPayload>() {
    return payloadObject as T;
  }
}