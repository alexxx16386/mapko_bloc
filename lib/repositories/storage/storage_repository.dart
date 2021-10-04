import 'package:mapko_bloc/repositories/storage/storage_provider.dart';

class StorageRepository {
  final StorageProvider _storageProvider = StorageProvider();

  Future<String?> getItem(String key) {
    return _storageProvider.getItem(key);
  }

  Future<void> setItem({required String key, required String value}) {
    return _storageProvider.setItem(key: key, value: value);
  }

  Future<void> deleteItem(String key) {
    return _storageProvider.deleteItem(key);
  }

  Future<void> clear() {
    return _storageProvider.clear();
  }
}
