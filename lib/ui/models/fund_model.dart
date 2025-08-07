class FundModel {
  final int id;
  final String name;
  final String description;
  final double currentValue;
  final String currency;
  final String riskLevel;
  final DateTime createdAt;

  FundModel({
    required this.id,
    required this.name,
    required this.description,
    required this.currentValue,
    required this.currency,
    required this.riskLevel,
    required this.createdAt,
  });

}
