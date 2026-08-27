class NextAppointmentModel {
  const NextAppointmentModel({
    required this.id,
    required this.time,
    required this.customer,
    required this.service,
    required this.employee,
    required this.countdown,
  });

  final String id;

  final String time;

  final String customer;

  final String service;

  final String employee;

  /// es. "Tra 18 min"
  final String countdown;

  factory NextAppointmentModel.empty() {
    return const NextAppointmentModel(
      id: '',
      time: '--:--',
      customer: '',
      service: '',
      employee: '',
      countdown: '',
    );
  }

  NextAppointmentModel copyWith({
    String? id,
    String? time,
    String? customer,
    String? service,
    String? employee,
    String? countdown,
  }) {
    return NextAppointmentModel(
      id: id ?? this.id,
      time: time ?? this.time,
      customer: customer ?? this.customer,
      service: service ?? this.service,
      employee: employee ?? this.employee,
      countdown: countdown ?? this.countdown,
    );
  }

  //--------------------------------------------------
  // HELPERS
  //--------------------------------------------------

  bool get isEmpty => id.isEmpty;

  bool get hasAppointment => !isEmpty;

  bool get hasCustomer => customer.isNotEmpty;

  bool get hasEmployee => employee.isNotEmpty;

  bool get hasService => service.isNotEmpty;

  String get displayTitle =>
      hasCustomer ? customer : "Nessun appuntamento";

  String get displaySubtitle {
    if (!hasService && !hasEmployee) {
      return "";
    }

    if (hasService && hasEmployee) {
      return "$service • $employee";
    }

    return hasService ? service : employee;
  }

  //--------------------------------------------------
  // MAP
  //--------------------------------------------------

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'customer': customer,
      'service': service,
      'employee': employee,
      'countdown': countdown,
    };
  }

  factory NextAppointmentModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return NextAppointmentModel(
      id: map['id']?.toString() ?? '',
      time: map['time']?.toString() ?? '--:--',
      customer: map['customer']?.toString() ?? '',
      service: map['service']?.toString() ?? '',
      employee: map['employee']?.toString() ?? '',
      countdown: map['countdown']?.toString() ?? '',
    );
  }
}