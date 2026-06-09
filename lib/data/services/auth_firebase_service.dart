import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_connect/domain/models/user_model.dart';

class AuthFirebaseService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthFirebaseService(this._firebaseAuth);

  //Login com firebase
  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Registro com firebase
  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //Logout com firebase
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final User? firebaseUser = _firebaseAuth.currentUser;
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
}
