import 'employee_status.dart';

class TeamMemberModel {
  const TeamMemberModel({
    required this.id,
    required this.name,
    this.avatarUrl = "",

    // Dashboard V2
    this.status = EmployeeStatus.available,
    this.subtitle = "",

    // Compatibilità
    this.isWorkingToday = true,
    this.isBusy = false,
    this.currentCustomer = "",
    this.nextAppointmentTime = "",
    this.completedAppointments = 0,
    this.todayRevenue = 0,
  });

  final String id;

  final String name;

  final String avatarUrl;

  //--------------------------------------------------
  // DASHBOARD V2
  //--------------------------------------------------

  final EmployeeStatus status;

  final String subtitle;

  //--------------------------------------------------
  // COMPATIBILITÀ
  //--------------------------------------------------

  final bool isWorkingToday;

  final bool isBusy;

  final String currentCustomer;

  final String nextAppointmentTime;

  final int completedAppointments;

  final double todayRevenue;

  //--------------------------------------------------
  // FACTORY
  //--------------------------------------------------

  factory TeamMemberModel.empty() {
    return const TeamMemberModel(
      id: "",
      name: "",
    );
  }

  factory TeamMemberModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return TeamMemberModel(
      id: map["id"]?.toString() ?? "",
      name: map["name"]?.toString() ?? "",
      avatarUrl: map["avatarUrl"]?.toString() ?? "",

      status: _parseStatus(
        map["status"],
      ),

      subtitle: map["subtitle"]?.toString() ?? "",

      isWorkingToday:
      map["isWorkingToday"] ?? true,

      isBusy:
      map["isBusy"] ?? false,

      currentCustomer:
      map["currentCustomer"]?.toString() ?? "",

      nextAppointmentTime:
      map["nextAppointmentTime"]?.toString() ?? "",

      completedAppointments:
      _parseInt(
        map["completedAppointments"],
      ),

      todayRevenue:
      _parseDouble(
        map["todayRevenue"],
      ),
    );
  }

  //--------------------------------------------------
  // COPY
  //--------------------------------------------------

  TeamMemberModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    EmployeeStatus? status,
    String? subtitle,
    bool? isWorkingToday,
    bool? isBusy,
    String? currentCustomer,
    String? nextAppointmentTime,
    int? completedAppointments,
    double? todayRevenue,
  }) {
    return TeamMemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      subtitle: subtitle ?? this.subtitle,
      isWorkingToday:
      isWorkingToday ?? this.isWorkingToday,
      isBusy: isBusy ?? this.isBusy,
      currentCustomer:
      currentCustomer ?? this.currentCustomer,
      nextAppointmentTime:
      nextAppointmentTime ??
          this.nextAppointmentTime,
      completedAppointments:
      completedAppointments ??
          this.completedAppointments,
      todayRevenue:
      todayRevenue ?? this.todayRevenue,
    );
  }

  //--------------------------------------------------
  // SERIALIZATION
  //--------------------------------------------------

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "avatarUrl": avatarUrl,

      "status": status.name,
      "subtitle": subtitle,

      "isWorkingToday": isWorkingToday,
      "isBusy": isBusy,
      "currentCustomer": currentCustomer,
      "nextAppointmentTime":
      nextAppointmentTime,
      "completedAppointments":
      completedAppointments,
      "todayRevenue": todayRevenue,
    };
  }

  //--------------------------------------------------
  // HELPERS
  //--------------------------------------------------

  bool get hasAvatar =>
      avatarUrl.trim().isNotEmpty;

  bool get hasCurrentCustomer =>
      currentCustomer.trim().isNotEmpty;

  bool get hasNextAppointment =>
      nextAppointmentTime.trim().isNotEmpty;

  String get revenueFormatted =>
      "€ ${todayRevenue.toStringAsFixed(2)}";

  bool get isAvailable =>
      status == EmployeeStatus.available;

  bool get isPaused =>
      status == EmployeeStatus.pause;

  bool get isOffline =>
      status == EmployeeStatus.offline;

  //--------------------------------------------------
  // PARSER
  //--------------------------------------------------

  static EmployeeStatus _parseStatus(
      dynamic value,
      ) {
    final raw =
        value?.toString().trim().toLowerCase() ??
            "";

    switch (raw) {
      case "busy":
        return EmployeeStatus.busy;

      case "pause":
        return EmployeeStatus.pause;

      case "offline":
        return EmployeeStatus.offline;

      case "available":
      default:
        return EmployeeStatus.available;
    }
  }

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
      value.toString(),
    ) ??
        0;
  }
}