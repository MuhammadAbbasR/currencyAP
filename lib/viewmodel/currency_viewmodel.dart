import 'package:flutter/foundation.dart';
import '../data/response/Api_response.dart';
import '../data/response/Status.dart';

import '../model/ConversionInfo.dart';
import '../repository/CurrencyRepository/CurrencyRepository.dart';
import '../repository/CurrencyRepository/CurrencyRepositoryImpl.dart';

class CurrencyViewModel extends ChangeNotifier {
  CurrencyRepositoryImpl currencyRepository;
  CurrencyViewModel({required this.currencyRepository});

  ApiResponse<List<CurrencyInfo>> currencyList = ApiResponse.loading();
  String _fromcurrency = 'USD';
  String _tocurrency = "PKR";
  String get fromcurrency => _fromcurrency;
  String get tocurrency => _tocurrency;

  void setFromCurrency(String currency) {
    _fromcurrency = currency;
    notifyListeners();
  }

  void setToCurrency(String currency) {
    _tocurrency = currency;
    notifyListeners();
  }

  setcurrencyList(ApiResponse<List<CurrencyInfo>> response) {
    currencyList = response;
    notifyListeners();
  }

  Future<void> fetchMoviesListApi() async {
    if (currencyList.status == Status.completed &&
        currencyList.data != null &&
        currencyList.data!.isNotEmpty) {
      return;
    }
    setcurrencyList(ApiResponse.loading());
    notifyListeners();
    try {
      final value = await currencyRepository.getDataApi();

      if (value != null && value.isNotEmpty) {
        print('Fetched currencies: $value');
        setcurrencyList(ApiResponse.completed(value));
      } else {
        setcurrencyList(ApiResponse.error('No data found'));
      }
    } catch (error, stackTrace) {
      debugPrint('Error fetching currencies: $error');
      debugPrintStack(stackTrace: stackTrace);
      setcurrencyList(ApiResponse.error(error.toString()));
    }
    notifyListeners();
  }
}
