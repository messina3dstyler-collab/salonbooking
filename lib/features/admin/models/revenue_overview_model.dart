class RevenueOverviewModel {
  const RevenueOverviewModel({
    this.expectedRevenue = 0,
  });

  final double expectedRevenue;

  factory RevenueOverviewModel.empty() {
    return const RevenueOverviewModel();
  }

  RevenueOverviewModel copyWith({
    double? expectedRevenue,
  }) {
    return RevenueOverviewModel(
      expectedRevenue: expectedRevenue ?? this.expectedRevenue,
    );
  }

  bool get hasExpectedRevenue => expectedRevenue > 0;

  String get expectedRevenueFormatted =>
      '€ ${expectedRevenue.toStringAsFixed(2)}';
}