// lib/data/services/user_firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';

class UserFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'users';

  /// Save user to Firestore
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Erro ao salvar usuário: ${e.toString()}');
    }
  }

  /// Get user from Firestore
  Future<UserModel?> getUser(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(_collectionName)
          .doc(id)
          .get();

      if (!docSnapshot.exists) return null;

      final userData = docSnapshot.data() as Map<String, dynamic>;
      return UserModel.fromMap(userData);
    } catch (e) {
      return null;
    }
  }

  /// Update user name
  Future<void> updateUserName(String userId, String newName) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).update({
        'name': newName,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar nome: ${e.toString()}');
    }
  }

  /// Check if user exists
  Future<bool> userExists(String userId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_collectionName)
          .doc(userId)
          .get();
      return docSnapshot.exists;
    } catch (e) {
      return false;
    }
  }
}
