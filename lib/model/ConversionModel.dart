class ConversionModel {
  String base;
  String symbol;
  double rate;

  ConversionModel(
      {required this.base, required this.symbol, required this.rate});

  factory ConversionModel.fromJson(Map<String, dynamic> json) {
    final rates = json['rates'] as Map<String, dynamic>;

    final entry = rates.entries.first;
    final targetCurrency = entry.key;
    final rateValue = (entry.value as num).toDouble();

    return ConversionModel(
      base: json['base'],
      symbol: targetCurrency,
      rate: rateValue,
    );
  }
}
