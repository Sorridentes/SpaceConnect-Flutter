import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

/// ViewModel da tela de Splash.
/// Verifica se o usuário está logado para decidir a navegação.
class SplashViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isReady = false;
  bool get isReady => _isReady;

  SplashViewModel(this._authRepository);

  /// Verifica o estado de autenticação após a animação da splash.
  Future<void> checkAuthState() async {
    await Future.delayed(const Duration(seconds: 3));
    final user = await _authRepository.getCurrentUser();
    _isLoggedIn = user != null;
    _isReady = true;
    notifyListeners();
  }
}
