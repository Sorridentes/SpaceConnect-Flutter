import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/user_model.dart';

/// ViewModel da tela de Login.
/// Equivalente ao LoginViewModel do protótipo Flutter.
class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _user;
  UserModel? get user => _user;

  bool _loginSuccess = false;
  bool get loginSuccess => _loginSuccess;

  LoginViewModel(this._authRepository);

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _loginSuccess = false;
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Preencha todos os campos');
      }

      _user = await _authRepository.signIn(email, password);
      _loginSuccess = true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetLoginSuccess() {
    _loginSuccess = false;
  }
}
