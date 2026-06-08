import 'package:flutter/material.dart';
import '../../data/repositories/astronomy_repository.dart';
import '../../domain/models/astronomy_model.dart';
import 'gallery_view_model.dart';

/// ViewModel da tela de Favoritos.
/// Equivalente ao AstronomyFavoritesViewModel do projeto Kotlin.
class FavoritesViewModel extends ChangeNotifier {
  final AstronomyRepository _astronomyRepository;

  UiState _uiState = UiState.initial;
  UiState get uiState => _uiState;

  List<AstronomyModel> _favorites = [];
  List<AstronomyModel> get favorites => _favorites;

  FavoritesViewModel(this._astronomyRepository);

  /// Carrega a lista de favoritos.
  Future<void> loadFavorites() async {
    _uiState = UiState.loading;
    notifyListeners();

    try {
      _favorites = await _astronomyRepository.getFavorites();
      _uiState = UiState.success;
    } catch (e) {
      _uiState = UiState.error;
    }

    notifyListeners();
  }

  /// Remove um item dos favoritos.
  Future<void> removeFavorite(AstronomyModel astronomy) async {
    await _astronomyRepository.removeFavorite(astronomy.date);
    _favorites.removeWhere((f) => f.date == astronomy.date);
    notifyListeners();
  }
}
