import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/user_model.dart';

/// ViewModel da tela de Cadastro.
/// Equivalente ao RegistrationViewModel do protótipo Flutter.
class RegistrationViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _user;
  UserModel? get user => _user;

  bool _registrationSuccess = false;
  bool get registrationSuccess => _registrationSuccess;

  RegistrationViewModel(this._authRepository);

  Future<void> register(String name, String email, String password, String confirmPassword) async {
    _isLoading = true;
    _errorMessage = null;
    _registrationSuccess = false;
    notifyListeners();

    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Preencha todos os campos');
      }

      if (password != confirmPassword) {
        throw Exception('As senhas não coincidem');
      }

      if (password.length < 6) {
        throw Exception('A senha deve ter pelo menos 6 caracteres');
      }

      await _authRepository.signUp(email, password);
      debugPrint('Registro realizado para $name ($email)');
      _registrationSuccess = true;
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

  void resetRegistrationSuccess() {
    _registrationSuccess = false;
  }
}
