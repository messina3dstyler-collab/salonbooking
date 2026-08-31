class RevenueOverviewModel {
  const RevenueOverviewModel({
    this.expectedRevenue = 0,
    this.today = 0,
    this.collectedRevenue = 0,
  });

  /// Incasso previsto complessivo.
  final double expectedRevenue;

  /// Incasso previsto per oggi.
  ///
  /// Attualmente il RevenueBuilder lavora sugli appuntamenti
  /// ricevuti e quindi questo valore rappresenta il totale
  /// degli appuntamenti non annullati considerati dal builder.
  final double today;

  /// Incasso effettivamente raccolto.
  ///
  /// Il modello degli appuntamenti attuale non espone ancora
  /// un'informazione affidabile sul pagamento effettuato,
  /// quindi il RevenueBuilder lo lascia a 0.
  final double collectedRevenue;

  factory RevenueOverviewModel.empty() {
    return const RevenueOverviewModel();
  }

  RevenueOverviewModel copyWith({
    double? expectedRevenue,
    double? today,
    double? collectedRevenue,
  }) {
    return RevenueOverviewModel(
      expectedRevenue: expectedRevenue ?? this.expectedRevenue,
      today: today ?? this.today,
      collectedRevenue:
      collectedRevenue ?? this.collectedRevenue,
    );
  }

  bool get hasExpectedRevenue =>
      expectedRevenue > 0;

  bool get hasCollectedRevenue =>
      collectedRevenue > 0;

  String get expectedRevenueFormatted =>
      '€ ${expectedRevenue.toStringAsFixed(2)}';

  String get todayFormatted =>
      '€ ${today.toStringAsFixed(2)}';

  String get collectedRevenueFormatted =>
      '€ ${collectedRevenue.toStringAsFixed(2)}';
}