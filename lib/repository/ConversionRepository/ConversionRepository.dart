

import '../../model/ConversionModel.dart';

abstract class ConversionRepository {
  Future<ConversionModel> getDataapi(String base, String symbol);
}
