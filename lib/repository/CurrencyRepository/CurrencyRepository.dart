
import '../../model/ConversionInfo.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyInfo>> getDataApi();
}
