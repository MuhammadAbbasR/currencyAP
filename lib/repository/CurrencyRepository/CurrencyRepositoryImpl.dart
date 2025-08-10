
import '../../data/Network/NetworkService.dart';
import '../../model/ConversionInfo.dart';
import 'currencyrepository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<List<CurrencyInfo>> getDataApi() async {
    final response = await _apiService.fetchCurrencies();
    return (response as Map<String, dynamic>)
        .entries
        .map((entry) => CurrencyInfo.fromMap(entry.key, entry.value))
        .toList();
  }
}
