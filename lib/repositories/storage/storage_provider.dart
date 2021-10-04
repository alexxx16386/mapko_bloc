import 'package:localstorage/localstorage.dart';
import 'package:mapko_bloc/config/configs.dart';

class StorageProvider {
  final LocalStorage _localStorage = LocalStorage(LOCAL_STORAGE_KEY);

  Future<String?> getItem(String key) {
    return _localStorage.getItem(key);
  }

  Future<void> setItem({required String key, required String value}) {
    return _localStorage.setItem(key, value);
  }

  Future<void> deleteItem(String key) {
    return _localStorage.deleteItem(key);
  }

  Future<void> clear() {
    return _localStorage.clear();
  }
}
