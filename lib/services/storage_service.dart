import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<List<String>> getFavorites() async {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> toggleFavorite(String countryName) async {
    final favorites = await getFavorites();
    if (favorites.contains(countryName)) {
      favorites.remove(countryName);
    } else {
      favorites.add(countryName);
    }
    await _prefs.setStringList(_favoritesKey, favorites);
  }

  Future<bool> isFavorite(String countryName) async {
    final favorites = await getFavorites();
    return favorites.contains(countryName);
  }
}
