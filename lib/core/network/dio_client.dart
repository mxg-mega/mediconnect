import 'package:dio/dio.dart';
import 'package:mediconnect/core/errors/exceptions.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  Dio get dio => _dio;

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void addHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  void addInterceptors(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }
}

extension DioResponseExtension on Response {
  dynamic get dataOrThrow {
    if (statusCode != null && statusCode! >= 200 && statusCode! < 300) {
      return data;
    } else {
      throw ServerException('Server error: ${statusMessage ?? 'Unknown error'}');
    }
  }
}
