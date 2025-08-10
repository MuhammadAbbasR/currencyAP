import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import '../../confi/Api_constants.dart';
import '../../confi/Api_url.dart';
import '../AppException.dart';

class NetworkApiService {
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

  Future fetchCurrencies() async {
    dynamic responseJson;

    try {
      final url = Uri.parse(AppUrl.currenciesurl);
      final response = await http.get(url);
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    return responseJson;
  }

  Future getConversionrate(String base, String symbol) async {
    dynamic responsejson;

    try {
      final url = Uri.parse('$baseUrl/$apiKey/latest/$base');

      final response = await http.get(url);
      responsejson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }
    return responsejson;
  }

  Future getGetApiResponse(String url) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    try {
      final response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 20));
      responseJson = jsonDecode(response.body);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  Future getPostApiResponse(String url, dynamic data) async {
    if (kDebugMode) {
      print(url);
      print(data);
    }

    dynamic responseJson;
    try {
      Response response = await post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    if (kDebugMode) {
      print(response.statusCode);
    }

    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communicating with server');
    }
  }
}
