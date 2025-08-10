import 'dart:convert';
import 'package:http/http.dart' as http;

import '../confi/Api_constants.dart';
import '../confi/Api_url.dart';


class CurrencyService {
  static final String apiKey = ApiConstants.exKey;
  static final String baseUrl = AppUrl.urlexchange;

  static Future<double?> getExchangeRate(String from, String to) async {
    final url = Uri.parse('$baseUrl/$apiKey/latest/$from');
    final response = await http.get(url);

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['result'] == 'success') {
        return data['conversion_rates'][to]?.toDouble();
      } else {
        throw Exception('API Error: ${data['error-type']}');
      }
    } else {
      throw Exception(
          'Failed to fetch exchange rate. Status: ${response.statusCode}');
    }
  }
}
