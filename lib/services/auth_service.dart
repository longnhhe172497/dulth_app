import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // REGISTER
  Future<User?> register(
      String email,
      String password,
      String fullName,
      ) async {

    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;

    if (user != null) {

      await FirestoreService().createUserProfile(
        fullName: fullName,
        email: email,
      );

    }

    return user;
  }

  // LOGIN
  Future<User?> login(String email, String password) async {

    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}