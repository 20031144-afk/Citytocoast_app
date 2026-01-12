import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  Future<UserCredential> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    isLoggedIn.value = true;
    return credential;
  }

  Future<UserCredential> signup(String email, String password) {
    // Signup doesn't automatically imply fully logged in until profile created,
    // but typically firebase auth signs them in.
    // Let's leave it manual or update if needed.
    // For now, we'll assume login flow handles the mainly.
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
    isLoggedIn.value = false;
  }

  User? get currentUser => _auth.currentUser;
}
