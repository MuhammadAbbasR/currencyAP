import 'package:flutter/material.dart';

import '../data/response/Api_response.dart';
import '../data/response/Status.dart';
import '../model/ConversionHistoryModel.dart';
import '../services/ShareServices.dart';

class ConversionHistoryViewModel with ChangeNotifier {
  List<ConversionHistory> _history = [];
  bool _isLoading = false;

  List<ConversionHistory> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> clearHistory() async {
    ApiResponse success = await SharedPrefencesService.clearHistory();
    if (success.status == Status.success) {
      _history.clear();
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    _history = await SharedPrefencesService.getHistory();
    notifyListeners();
  }

  Future<void> fetchHistory({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    final historyData = await SharedPrefencesService.getHistory();

    _history = historyData;
    _isLoading = false;
    notifyListeners();
  }

  Future<ApiResponse> addConversion(ConversionHistory model) async {
    final response = await SharedPrefencesService.saveConversion(model);
    await fetchHistory();
    return response;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
