import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mapko_bloc/repositories/token/token_provider.dart';

class TokenRepository {
  final TokenProvider _tokenProvider = TokenProvider();

  Future<String> getToken() async {
    return _tokenProvider.getToken();
  }

  void deleteToken() {
    _tokenProvider.deleteToken();
  }

  void persistToken(String? token) {
    _tokenProvider.persistToken(token);
  }

  Future<bool> hasToken() async {
    return _tokenProvider.hasToken();
  }
}
