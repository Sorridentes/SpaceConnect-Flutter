import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/astronomy_model.dart';

/// Serviço de persistência local dos favoritos.
/// Equivalente ao AstronomyLocalDataSource do projeto Kotlin.
class FavoritesLocalService {
  static const String _favoritesKey = 'favorites_list';

  /// Retorna a lista de favoritos salvos localmente.
  Future<List<AstronomyModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favJson = prefs.getString(_favoritesKey);

    if (favJson == null) return [];

    final List<dynamic> data = json.decode(favJson);
    return data.map((item) => AstronomyModel.fromMap(item)).toList();
  }

  /// Adiciona um item aos favoritos.
  Future<void> addFavorite(AstronomyModel astronomy) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    final exists = favorites.any((f) => f.date == astronomy.date);
    if (!exists) {
      favorites.add(astronomy.copyWith(isFavorite: true));
      await prefs.setString(
        _favoritesKey,
        json.encode(favorites.map((f) => f.toMap()).toList()),
      );
    }
  }

  /// Remove um item dos favoritos.
  Future<void> removeFavorite(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites.removeWhere((f) => f.date == date);
    await prefs.setString(
      _favoritesKey,
      json.encode(favorites.map((f) => f.toMap()).toList()),
    );
  }

  /// Verifica se um item está nos favoritos.
  Future<bool> isFavorite(String date) async {
    final favorites = await getFavorites();
    return favorites.any((f) => f.date == date);
  }

  /// Alterna o estado de favorito de um item.
  Future<bool> toggleFavorite(AstronomyModel astronomy) async {
    final isFav = await isFavorite(astronomy.date);
    if (isFav) {
      await removeFavorite(astronomy.date);
      return false;
    } else {
      await addFavorite(astronomy);
      return true;
    }
  }
}
