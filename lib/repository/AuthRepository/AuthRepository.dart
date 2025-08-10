import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signUp(
      {required String email,
        required String password,
        required String username});

  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  User? get currentUser;

  Stream<User?> authStateChanges();
}
