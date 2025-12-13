import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal() {
    _load();
  }

  static const key = 'favorite_meals';
  List<String> _favorites = [];

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList(key) ?? [];
  }

  bool isFavorite(String id) => _favorites.contains(id);

  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    await prefs.setStringList(key, _favorites);
  }

  List<String> get favorites => _favorites;
}
