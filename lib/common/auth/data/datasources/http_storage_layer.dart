import 'package:dio/dio.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/core/network/dio_client.dart';
import 'package:mediconnect/core/errors/exceptions.dart';

class HttpStorageLayer implements StorageLayer {
  final DioClient dioClient;

  HttpStorageLayer({required this.dioClient});

  @override
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await dioClient.dio.post(endpoint, data: data);
      return response.dataOrThrow as Map<String, dynamic>;
    } catch (e) {
      if (e is DioException) {
        throw NetworkException('Network error: ${e.message}');
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await dioClient.dio.get(endpoint);
      return response.dataOrThrow as Map<String, dynamic>;
    } catch (e) {
      if (e is DioException) {
        throw NetworkException('Network error: ${e.message}');
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await dioClient.dio.put(endpoint, data: data);
      return response.dataOrThrow as Map<String, dynamic>;
    } catch (e) {
      if (e is DioException) {
        throw NetworkException('Network error: ${e.message}');
      }
      rethrow;
    }
  }

  @override
  Future<void> delete(String endpoint) async {
    try {
      await dioClient.dio.delete(endpoint);
    } catch (e) {
      if (e is DioException) {
        throw NetworkException('Network error: ${e.message}');
      }
      rethrow;
    }
  }
}
