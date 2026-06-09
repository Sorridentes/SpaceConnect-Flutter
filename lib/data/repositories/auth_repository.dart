import 'package:space_connect/data/services/auth_local_service.dart';
import 'package:space_connect/domain/models/user_model.dart';

import '../services/auth_firebase_service.dart';

class AuthRepository {
  final AuthFirebaseService _authFirebaseService;

  final AuthLocalService _authLocalService;

  AuthRepository(this._authFirebaseService, this._authLocalService);

  Future<void> signIn(String email, String password) async {
    return _authFirebaseService.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    return _authFirebaseService.signUp(email, password);
  }

  Future<void> signOut() async {
    return _authFirebaseService.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    // Try Firebase first
    final firebaseUser = await _authFirebaseService.getCurrentUser();
    if (firebaseUser != null) return firebaseUser;

    // Fallback to local
    return _authLocalService.getCurrentUser();
  }
}
