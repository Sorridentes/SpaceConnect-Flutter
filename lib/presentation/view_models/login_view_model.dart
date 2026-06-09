import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

/// ViewModel da tela de Login.
/// Equivalente ao LoginViewModel do protótipo Flutter.
class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _loginSuccess = false;
  bool get loginSuccess => _loginSuccess;

  LoginViewModel(this._authRepository);

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Preencha todos os campos');
      }
      await _authRepository.signIn(email, password);
      debugPrint('Login realizado com $email');
      _loginSuccess = true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Erro no login: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetLoginSuccess() {
    _loginSuccess = false;
  }
}
