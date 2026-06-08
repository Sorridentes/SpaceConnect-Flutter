import '../../domain/models/user_model.dart';
import '../services/user_firebase_service.dart';

class UserRepository {
  final UserFirebaseService _userFirebaseService;

  UserRepository(this._userFirebaseService);

  Future<void> saveUser(UserModel user) async {
    return _userFirebaseService.saveUser(user);
  }

  Future<UserModel?> getUser(String id) async {
    return _userFirebaseService.getUser(id);
  }
}
