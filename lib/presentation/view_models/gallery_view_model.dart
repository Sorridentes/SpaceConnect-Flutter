import 'package:flutter/material.dart';
import '../../data/repositories/astronomy_repository.dart';
import '../../domain/models/astronomy_model.dart';

/// Enum para representar o estado da UI.
/// Equivalente ao UiState do projeto Kotlin.
enum UiState { initial, loading, success, error }

/// ViewModel da tela de Galeria (lista APOD).
/// Equivalente ao AstronomyListViewModel.kt do projeto Kotlin.
class GalleryViewModel extends ChangeNotifier {
  final AstronomyRepository _astronomyRepository;

  UiState _uiState = UiState.initial;
  UiState get uiState => _uiState;

  List<AstronomyModel> _astronomyList = [];
  List<AstronomyModel> get astronomyList => _astronomyList;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  GalleryViewModel(this._astronomyRepository);

  /// Retorna a lista filtrada pela busca.
  List<AstronomyModel> get filteredList {
    if (_searchQuery.isEmpty) return _astronomyList;
    final q = _searchQuery.toLowerCase();
    return _astronomyList.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q);
    }).toList();
  }

  /// Busca a lista de astronomias por intervalo de datas.
  Future<void> fetchAstronomyByDate(String startDate, String endDate) async {
    _uiState = UiState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _astronomyList =
          await _astronomyRepository.getAstronomyListByDate(startDate, endDate);
      _uiState = UiState.success;
    } catch (e) {
      _uiState = UiState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  /// Carrega os dados iniciais (últimos 15 dias).
  Future<void> loadInitialData() async {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 14));

    final startStr =
        '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
    final endStr =
        '${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';

    await fetchAstronomyByDate(startStr, endStr);
  }

  /// Alterna o estado de favorito de um item.
  Future<void> toggleFavorite(AstronomyModel astronomy) async {
    final newStatus = await _astronomyRepository.toggleFavorite(astronomy);
    final index = _astronomyList.indexWhere((a) => a.date == astronomy.date);
    if (index != -1) {
      _astronomyList[index] = _astronomyList[index].copyWith(isFavorite: newStatus);
      notifyListeners();
    }
  }

  /// Atualiza a query de busca.
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
