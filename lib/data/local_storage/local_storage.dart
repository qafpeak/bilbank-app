// INTERFACE
import 'package:bilbank_app/data/local_storage/local_storage_keys.dart';

abstract class LocalStorage {
  Future<T> getValue<T>(LocalStorageKeys key, [T? defaultValue]);
  Future<void> setValue<T>(LocalStorageKeys key, T value);
  Future<void> remove(LocalStorageKeys key);
  Future<void> clearAll();
  Future<bool> containsKey(LocalStorageKeys key);
}