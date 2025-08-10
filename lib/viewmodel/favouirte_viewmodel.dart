import 'package:flutter/foundation.dart';


import '../data/response/Api_response.dart';
import '../services/FavouriteService.dart';

class FavoriteCurrenciesViewModel extends ChangeNotifier {
  ApiResponse<List<String>> favoriteCurrenciesResponse = ApiResponse.loading();

  String _seletedCurrency = "";

  String get getSelectedCurrecny => _seletedCurrency;

  void setCurrency(String code) {
    _seletedCurrency = code;
    notifyListeners();
  }

  Future<void> fetchFavorites() async {
    try {
      favoriteCurrenciesResponse = ApiResponse.loading();
      notifyListeners();

      final favorites = await FavoriteCurrenciesService.getFavorites();
      favoriteCurrenciesResponse = ApiResponse.completed(favorites);
      notifyListeners();
    } catch (e) {
      favoriteCurrenciesResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  Future<void> addFavorite(String currencyCode) async {
    if (favoriteCurrenciesResponse.data == null) {
      favoriteCurrenciesResponse = ApiResponse.completed([currencyCode]);
      await FavoriteCurrenciesService.saveFavorites([currencyCode]);
      notifyListeners();
      return;
    }

    final updatedFavorites =
    List<String>.from(favoriteCurrenciesResponse.data!);
    if (!updatedFavorites.contains(currencyCode)) {
      updatedFavorites.add(currencyCode);
      await FavoriteCurrenciesService.saveFavorites(updatedFavorites);
      favoriteCurrenciesResponse = ApiResponse.completed(updatedFavorites);
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String currencyCode) async {
    if (favoriteCurrenciesResponse.data == null) return;

    final updatedFavorites =
    List<String>.from(favoriteCurrenciesResponse.data!);
    updatedFavorites.remove(currencyCode);
    await FavoriteCurrenciesService.saveFavorites(updatedFavorites);
    favoriteCurrenciesResponse = ApiResponse.completed(updatedFavorites);
    notifyListeners();
  }
}
