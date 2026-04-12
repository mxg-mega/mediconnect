import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/core/errors/exceptions.dart';

class HiveStorageLayer implements StorageLayer {
  static const String _boxName = 'mediconnect_storage';
  late Box _box;

  HiveStorageLayer() {
    _init();
  }

  Future<void> _init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  Future<void> _ensureInitialized() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await _init();
    }
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    await _ensureInitialized();
    // Simulate endpoint-like behavior using Hive keys
    final key = endpoint.replaceAll('/', '_');
    await _box.put(key, data);
    return data;
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    await _ensureInitialized();
    final key = endpoint.replaceAll('/', '_');
    final data = _box.get(key);
    if (data == null) {
      throw CacheException('No data found for $endpoint');
    }
    return Map<String, dynamic>.from(data);
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    await _ensureInitialized();
    final key = endpoint.replaceAll('/', '_');
    await _box.put(key, data);
    return data;
  }

  @override
  Future<void> delete(String endpoint) async {
    await _ensureInitialized();
    final key = endpoint.replaceAll('/', '_');
    await _box.delete(key);
  }
}
