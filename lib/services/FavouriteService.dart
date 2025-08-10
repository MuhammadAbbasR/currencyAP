
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteCurrenciesService {
  static const String _keyFavorites = "favorite_currencies";

  static Future<void> saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavorites, favorites);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_keyFavorites);
    return favorites ?? [];
  }

  static Future<void> addFavorite(String code) async {
    final favorites = await getFavorites();
    if (!favorites.contains(code)) {
      favorites.add(code);
      await saveFavorites(favorites);
    }
  }

  static Future<void> removeFavorite(String code) async {
    final favorites = await getFavorites();
    if (favorites.contains(code)) {
      favorites.remove(code);
      await saveFavorites(favorites);
    }
  }

  static Future<bool> isFavorite(String code) async {
    final favorites = await getFavorites();
    return favorites.contains(code);
  }
}
