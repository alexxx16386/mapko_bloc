import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenProvider {
  static FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String> getToken() async {
    return await _storage.read(key: 'AuthToken');
  }

  void deleteToken() async {
    await _storage.delete(key: 'AuthToken');
  }

  void persistToken(String? token) async {
    await _storage.write(key: 'AuthToken', value: token);
  }

  Future<bool> hasToken() async {
    return await _storage.containsKey(key: 'AuthToken');
  }
}
