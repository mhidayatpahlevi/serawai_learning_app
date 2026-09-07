import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> register({
    required String nama,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user != null) {
      await user.updateDisplayName(nama.trim());

      final userModel = UserModel(
        uid: user.uid,
        nama: nama.trim(),
        email: email.trim(),
        role: 'user',
      );

      await _firestore.collection('users').doc(user.uid).set({
        ...userModel.toMap(),

        'highestUnlockedCategory': 1,

        'userLevel': 'pemula',

        'totalPantunCompleted': 0,

        'totalCategoriesCompleted': 0,

        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  Future<User?> login({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    return credential.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
