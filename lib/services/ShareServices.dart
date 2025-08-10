import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/response/Api_response.dart';
import '../model/ConversionHistoryModel.dart';

class SharedPrefencesService {
  static SharedPreferences? _prefs;

  static Future initialize_SharedPrefence() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<ApiResponse> saveConversion(ConversionHistory model) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    try {
      history.insert(0, model);

      final encoded =
      history.map((item) => json.encode(item.toJson())).toList();

      await prefs.setStringList("history", encoded);

      return ApiResponse.success('success');
    } catch (error) {
      return ApiResponse.error(error.toString());
    }
  }

  static Future<List<ConversionHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? historyJsonList = prefs.getStringList("history");

    if (historyJsonList == null) return [];

    return historyJsonList
        .map((item) => ConversionHistory.fromJson(json.decode(item)))
        .toList();
  }

  static Future<ApiResponse> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove("history");
      return ApiResponse.success('History cleared');
    } catch (error) {
      return ApiResponse.error(error.toString());
    }
  }
}
