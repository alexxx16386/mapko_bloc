import 'dart:async';
import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/repositories/auth/auth_provider.dart';


class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();

  Future<String> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    final String token = await _authProvider.signUp(
      username: username,
      email: email,
      password: password,
    );

    return token;
  }

  Future<String> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _authProvider.logIn(
      email: email,
      password: password,
    );
  }

  Future<UserModel> getCurrrentUserInfo(String token) async {
    return _authProvider.getCurrrentUserInfo(
      token: token,
    );
  }
}
