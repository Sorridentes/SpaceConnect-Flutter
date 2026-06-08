// lib/data/services/auth_firebase_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';

class AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign in with email and password
  Future<UserModel> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Erro ao fazer login');
      }

      // Get user data from Firestore
      final docSnapshot = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('Usuário não encontrado');
      }

      final userData = docSnapshot.data() as Map<String, dynamic>;

      return UserModel(
        id: firebaseUser.uid,
        name: userData['name'] ?? '',
        email: firebaseUser.email ?? email,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Usuário não encontrado');
      } else if (e.code == 'wrong-password') {
        throw Exception('Senha incorreta');
      } else if (e.code == 'invalid-email') {
        throw Exception('Email inválido');
      } else if (e.code == 'user-disabled') {
        throw Exception('Usuário desabilitado');
      }
      throw Exception('Erro ao fazer login: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }

  /// Sign up with email and password
  Future<UserModel> signUp(String name, String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Erro ao criar usuário');
      }

      // Create user document in Firestore
      final userModel = UserModel(
        id: firebaseUser.uid,
        name: name,
        email: email,
      );

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Senha muito fraca');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Email já está em uso');
      } else if (e.code == 'invalid-email') {
        throw Exception('Email inválido');
      }
      throw Exception('Erro ao criar conta: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao criar conta: ${e.toString()}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!docSnapshot.exists) return null;

      final userData = docSnapshot.data() as Map<String, dynamic>;

      return UserModel(
        id: firebaseUser.uid,
        name: userData['name'] ?? '',
        email: firebaseUser.email ?? '',
      );
    } catch (e) {
      return null;
    }
  }

  /// Get auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
