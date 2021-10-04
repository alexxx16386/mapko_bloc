import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenProvider {
  static FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return  _storage.read(key: 'AuthToken');
  }

 Future<void> deleteToken() async {
  return   _storage.delete(key: 'AuthToken');
  }

  Future<void> persistToken(String? token) async {
    return _storage.write(key: 'AuthToken', value: token);
  }

  Future<bool> hasToken() async {
    return  _storage.containsKey(key: 'AuthToken');
  }
}
