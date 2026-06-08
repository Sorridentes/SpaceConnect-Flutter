import 'package:flutter/material.dart';
import '../../data/repositories/astronomy_repository.dart';
import '../../domain/models/astronomy_model.dart';
import 'gallery_view_model.dart';

/// ViewModel da tela de Detalhes.
/// Equivalente ao AstronomyDetailViewModel do projeto Kotlin.
class DetailViewModel extends ChangeNotifier {
  final AstronomyRepository _astronomyRepository;

  UiState _uiState = UiState.initial;
  UiState get uiState => _uiState;

  AstronomyModel? _astronomy;
  AstronomyModel? get astronomy => _astronomy;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  DetailViewModel(this._astronomyRepository);

  /// Carrega os dados de uma astronomia específica por data.
  Future<void> loadAstronomy(String date) async {
    _uiState = UiState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _astronomy = await _astronomyRepository.getAstronomyByDate(date);
      _uiState = UiState.success;
    } catch (e) {
      _uiState = UiState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  /// Alterna o estado de favorito.
  Future<void> toggleFavorite() async {
    if (_astronomy == null) return;

    final newStatus = await _astronomyRepository.toggleFavorite(_astronomy!);
    _astronomy = _astronomy!.copyWith(isFavorite: newStatus);
    notifyListeners();
  }
}
