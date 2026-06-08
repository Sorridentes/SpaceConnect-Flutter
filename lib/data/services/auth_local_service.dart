import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user_model.dart';

class AuthLocalService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  /// Realiza o login do usuário.
  Future<UserModel> signIn(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) {
      throw Exception('Nenhum usuário cadastrado');
    }

    final List<dynamic> users = json.decode(usersJson);
    final userMap = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => null,
    );

    if (userMap == null) {
      throw Exception('Email ou senha incorretos');
    }

    final user = UserModel.fromMap(userMap);
    await prefs.setString(_currentUserKey, json.encode(user.toMap()));
    return user;
  }

  /// Realiza o cadastro de um novo usuário.
  Future<UserModel> signUp(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    List<dynamic> users = [];

    if (usersJson != null) {
      users = json.decode(usersJson);
      final exists = users.any((u) => u['email'] == email);
      if (exists) {
        throw Exception('Email já cadastrado');
      }
    }

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );

    users.add({...user.toMap(), 'password': password});
    await prefs.setString(_usersKey, json.encode(users));
    await prefs.setString(_currentUserKey, json.encode(user.toMap()));
    return user;
  }

  /// Realiza o logout do usuário.
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  /// Verifica se há um usuário logado.
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);

    if (userJson == null) return null;
    return UserModel.fromMap(json.decode(userJson));
  }

  Future<void> saveCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, json.encode(user.toMap()));
  }
}
