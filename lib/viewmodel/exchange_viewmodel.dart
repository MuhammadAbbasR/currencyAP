import 'package:flutter/foundation.dart';
import '../data/response/Api_response.dart';

import '../services/CurrencyServices.dart';

class CurrencyExchangeViewModel extends ChangeNotifier {
  ApiResponse<double> _exchangeRate = ApiResponse.notStarted();
  ApiResponse<double> get exchangeRateResponse => _exchangeRate;
  double? _convertedAmount = 0;

  double? get convertedAmount => _convertedAmount;
  void setamount(double amount) {
    _convertedAmount = amount;
    notifyListeners();
  }

  Future<void> fetchExchangeRate(String from, String to) async {
    _exchangeRate = ApiResponse.loading();
    notifyListeners();

    try {
      final rate = await CurrencyService.getExchangeRate(from, to);
      if (rate != null) {
        _exchangeRate = ApiResponse.completed(rate);
      } else {
        _exchangeRate = ApiResponse.error('Rate not found');
      }
    } catch (e) {
      _exchangeRate = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }
}
