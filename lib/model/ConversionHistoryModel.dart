class ConversionHistory {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double result;
  final double rate;
  final DateTime date;

  ConversionHistory({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.result,
    required this.rate,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'amount': amount,
      'result': result,
      'rate': rate,
      'date': date.toIso8601String(),
    };
  }

  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      fromCurrency: json['fromCurrency'],
      toCurrency: json['toCurrency'],
      amount: (json['amount'] as num).toDouble(),
      result: (json['result'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}
