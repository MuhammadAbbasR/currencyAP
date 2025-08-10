class CurrencyInfo {
  final String code;
  final String name;

  CurrencyInfo({required this.code, required this.name});

  factory CurrencyInfo.fromMap(String code, dynamic name) {
    return CurrencyInfo(
      code: code,
      name: name.toString(),
    );
  }
}
