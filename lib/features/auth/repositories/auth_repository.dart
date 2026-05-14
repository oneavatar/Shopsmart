import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> login({
    required String email,
    required String password,
  }) async {

    final credential =
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  Future<User?> signup({
    required String email,
    required String password,
  }) async {

    final credential =
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;
}