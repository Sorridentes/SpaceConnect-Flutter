// lib/data/repositories/auth_repository.dart
import '../../domain/models/user_model.dart';
import '../services/auth_firebase_service.dart';
import '../services/auth_local_service.dart';

/// Repositório de autenticação com suporte Firebase + Local fallback.
class AuthRepository {
  final AuthFirebaseService _authFirebaseService;
  final AuthLocalService _authLocalService;

  AuthRepository(this._authFirebaseService, this._authLocalService);

  Future<UserModel> signIn(String email, String password) async {
    try {
      // Try Firebase first
      final user = await _authFirebaseService.signIn(email, password);
      // Sync to local storage
      await _authLocalService.saveCurrentUser(user);
      return user;
    } catch (e) {
      // Fallback to local if needed
      return _authLocalService.signIn(email, password);
    }
  }

  Future<UserModel> signUp(String name, String email, String password) async {
    try {
      // Try Firebase first
      final user = await _authFirebaseService.signUp(name, email, password);
      // Sync to local storage
      await _authLocalService.saveCurrentUser(user);
      return user;
    } catch (e) {
      // Fallback to local
      return _authLocalService.signUp(name, email, password);
    }
  }

  Future<void> signOut() async {
    try {
      await _authFirebaseService.signOut();
    } finally {
      await _authLocalService.signOut();
    }
  }

  Future<UserModel?> getCurrentUser() async {
    // Try Firebase first
    final firebaseUser = await _authFirebaseService.getCurrentUser();
    if (firebaseUser != null) return firebaseUser;

    // Fallback to local
    return _authLocalService.getCurrentUser();
  }

  Stream<User?> get authStateChanges => _authFirebaseService.authStateChanges;
}
