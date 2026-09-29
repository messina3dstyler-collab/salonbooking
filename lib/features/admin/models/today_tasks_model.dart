class TodayTasksModel {
  const TodayTasksModel({
    this.pendingRequests = 0,
    this.unconfirmedAppointments = 0,
    this.expiringAppointments = 0,
  });

  //--------------------------------------------------
  // DASHBOARD TASKS
  //--------------------------------------------------

  /// Richieste che richiedono un'azione da parte del salone.
  final int pendingRequests;

  /// Appuntamenti ancora da confermare.
  final int unconfirmedAppointments;

  /// Appuntamenti prossimi all'orario di inizio.
  final int expiringAppointments;

  //--------------------------------------------------
  // FACTORY
  //--------------------------------------------------

  factory TodayTasksModel.empty() {
    return const TodayTasksModel();
  }

  //--------------------------------------------------
  // COPY
  //--------------------------------------------------

  TodayTasksModel copyWith({
    int? pendingRequests,
    int? unconfirmedAppointments,
    int? expiringAppointments,
  }) {
    return TodayTasksModel(
      pendingRequests:
      pendingRequests ?? this.pendingRequests,
      unconfirmedAppointments:
      unconfirmedAppointments ??
          this.unconfirmedAppointments,
      expiringAppointments:
      expiringAppointments ??
          this.expiringAppointments,
    );
  }

  //--------------------------------------------------
  // MAP
  //--------------------------------------------------

  Map<String, dynamic> toMap() {
    return {
      'pendingRequests': pendingRequests,
      'unconfirmedAppointments':
      unconfirmedAppointments,
      'expiringAppointments':
      expiringAppointments,
    };
  }

  factory TodayTasksModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return TodayTasksModel(
      pendingRequests:
      _parseInt(map['pendingRequests']),
      unconfirmedAppointments:
      _parseInt(
        map['unconfirmedAppointments'],
      ),
      expiringAppointments:
      _parseInt(
        map['expiringAppointments'],
      ),
    );
  }

  //--------------------------------------------------
  // HELPERS
  //--------------------------------------------------

  bool get hasTasks => totalTasks > 0;

  bool get isCompleted => totalTasks == 0;

  int get totalTasks {
    return pendingRequests +
        unconfirmedAppointments +
        expiringAppointments;
  }

  //--------------------------------------------------
  // PARSER
  //--------------------------------------------------

  static int _parseInt(dynamic value) {
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
}