import '../../domain/models/astronomy_model.dart';
import '../services/nasa_api_service.dart';
import '../services/favorites_local_service.dart';

/// Repositório que coordena dados remotos (NASA API) e locais (Favoritos).
/// Equivalente ao AstronomyRepository.kt do projeto Kotlin.
class AstronomyRepository {
  final NasaApiService _nasaApiService;
  final FavoritesLocalService _favoritesLocalService;

  AstronomyRepository(this._nasaApiService, this._favoritesLocalService);

  /// Busca a lista de astronomias por intervalo de datas.
  Future<List<AstronomyModel>> getAstronomyListByDate(
    String startDate,
    String endDate,
  ) async {
    final list = await _nasaApiService.getAstronomyListByDate(startDate, endDate);

    // Marca os favoritos na lista
    for (int i = 0; i < list.length; i++) {
      final isFav = await _favoritesLocalService.isFavorite(list[i].date);
      if (isFav) {
        list[i] = list[i].copyWith(isFavorite: true);
      }
    }

    return list;
  }

  /// Busca uma astronomia específica por data.
  Future<AstronomyModel> getAstronomyByDate(String date) async {
    final astronomy = await _nasaApiService.getAstronomyByDate(date);
    final isFav = await _favoritesLocalService.isFavorite(date);
    return astronomy.copyWith(isFavorite: isFav);
  }

  /// Alterna o estado de favorito.
  Future<bool> toggleFavorite(AstronomyModel astronomy) async {
    return _favoritesLocalService.toggleFavorite(astronomy);
  }

  /// Retorna a lista de favoritos.
  Future<List<AstronomyModel>> getFavorites() async {
    return _favoritesLocalService.getFavorites();
  }

  /// Remove um favorito.
  Future<void> removeFavorite(String date) async {
    return _favoritesLocalService.removeFavorite(date);
  }
}
