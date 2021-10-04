import 'dart:async';
import 'package:mapko_bloc/repositories/auth/auth_provider.dart';
import 'package:mapko_bloc/repositories/token/token_repository.dart';

class AuthRepository {
  final TokenRepository _tokenRepository;
  final AuthProvider _authProvider = AuthProvider();

  AuthRepository({
    required TokenRepository tokenRepository,
  }) : _tokenRepository = tokenRepository;

  Future signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    _tokenRepository.persistToken(
      await _authProvider.signUp(
        username: username,
        email: email,
        password: password,
      ),
    );
  }

  Future logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _tokenRepository.persistToken(
      await _authProvider.logIn(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> logOut() async {
    _tokenRepository.deleteToken();
  }
}
