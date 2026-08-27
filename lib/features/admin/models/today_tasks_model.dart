class TodayTasksModel {
  const TodayTasksModel({
    // Dashboard completa
    this.pendingRequests = 0,
    this.pendingReviews = 0,
    this.expiringRequests = 0,
    this.unconfirmedAppointments = 0,
    this.missingPayments = 0,

    // Today Overview
    this.arrivalsSoon = 0,
    this.confirmations = 0,
  });

  //--------------------------------------------------
  // DASHBOARD
  //--------------------------------------------------

  final int pendingRequests;

  final int pendingReviews;

  final int expiringRequests;

  final int unconfirmedAppointments;

  final int missingPayments;

  //--------------------------------------------------
  // TODAY OVERVIEW
  //--------------------------------------------------

  final int arrivalsSoon;

  final int confirmations;

  factory TodayTasksModel.empty() {
    return const TodayTasksModel();
  }

  TodayTasksModel copyWith({
    int? pendingRequests,
    int? pendingReviews,
    int? expiringRequests,
    int? unconfirmedAppointments,
    int? missingPayments,
    int? arrivalsSoon,
    int? confirmations,
  }) {
    return TodayTasksModel(
      pendingRequests:
      pendingRequests ?? this.pendingRequests,
      pendingReviews:
      pendingReviews ?? this.pendingReviews,
      expiringRequests:
      expiringRequests ?? this.expiringRequests,
      unconfirmedAppointments:
      unconfirmedAppointments ??
          this.unconfirmedAppointments,
      missingPayments:
      missingPayments ?? this.missingPayments,
      arrivalsSoon:
      arrivalsSoon ?? this.arrivalsSoon,
      confirmations:
      confirmations ?? this.confirmations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "pendingRequests": pendingRequests,
      "pendingReviews": pendingReviews,
      "expiringRequests": expiringRequests,
      "unconfirmedAppointments":
      unconfirmedAppointments,
      "missingPayments": missingPayments,

      "arrivalsSoon": arrivalsSoon,
      "confirmations": confirmations,
    };
  }

  factory TodayTasksModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return TodayTasksModel(
      pendingRequests:
      _parseInt(map["pendingRequests"]),

      pendingReviews:
      _parseInt(map["pendingReviews"]),

      expiringRequests:
      _parseInt(map["expiringRequests"]),

      unconfirmedAppointments:
      _parseInt(
        map["unconfirmedAppointments"],
      ),

      missingPayments:
      _parseInt(map["missingPayments"]),

      arrivalsSoon:
      _parseInt(map["arrivalsSoon"]),

      confirmations:
      _parseInt(map["confirmations"]),
    );
  }

  //--------------------------------------------------
  // HELPERS
  //--------------------------------------------------

  bool get hasTasks => totalTasks > 0;

  bool get isCompleted =>
      pendingRequests == 0 &&
          arrivalsSoon == 0 &&
          confirmations == 0;

  int get totalTasks {
    return pendingRequests +
        pendingReviews +
        expiringRequests +
        unconfirmedAppointments +
        missingPayments;
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