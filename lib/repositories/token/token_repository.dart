import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mapko_bloc/repositories/token/token_provider.dart';

class TokenRepository {
  final TokenProvider _tokenProvider = TokenProvider();

  Future<String?> getToken() async {
    return _tokenProvider.getToken();
  }

  Future<void> deleteToken() {
    return _tokenProvider.deleteToken();
  }

  Future<void> persistToken(String? token) {
    return _tokenProvider.persistToken(token);
  }

  Future<bool> hasToken() async {
    return _tokenProvider.hasToken();
  }
}
