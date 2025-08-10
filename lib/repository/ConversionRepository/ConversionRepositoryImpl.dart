

import 'package:currencyapp/data/Network/NetworkService.dart';

import '../../model/ConversionModel.dart';
import 'ConversionRepository.dart';

class ConversionRepositoryImpl extends ConversionRepository {
  @override
  Future<ConversionModel> getDataapi(String base, String symbol) async {
    final apiservie = NetworkApiService();

    final response = await apiservie.getConversionrate(base, symbol);

    if (response != null) {
      print("responsei is $response");
      return ConversionModel.fromJson(response);
    } else {
      print("Invalid or null response received: $response");
      throw Exception(
          "Expected Map<String, dynamic>, but got ${response.runtimeType}");
    }
  }
}
