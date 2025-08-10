import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../data/response/Api_response.dart';

import '../repository/AuthRepository/AuthRepository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get currentUser => _authRepository.currentUser;

  Stream<User?> get authStateChanges => _authRepository.authStateChanges();

  Future<ApiResponse<User>> signUp(
      String email, String password, String username) async {
    _setLoading(true);

    try {
      var user = await _authRepository.signUp(
        email: email,
        password: password,
        username: username,
      );

      _setLoading(false);

      if (user != null) {
        return ApiResponse<User>.success("suceess");
      } else {
        return ApiResponse<User>.error("not success");
      }
    } catch (e) {
      _setLoading(false);
      return ApiResponse<User>.error(e.toString());
    }
  }

  Future<ApiResponse<User>> signIn(String email, String password) async {
    _setLoading(true);

    // Show loading state at the beginning
    ApiResponse<User> response = ApiResponse.loading();

    try {
      var userCredential = await _authRepository.signIn(
        email: email,
        password: password,
      );

      _setLoading(false);

      if (userCredential != null) {
        return ApiResponse.completed(userCredential.user);
      } else {
        return ApiResponse.error("Login failed. User not found.");
      }
    } catch (e) {
      _setLoading(false);
      return ApiResponse.error(e.toString());
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
