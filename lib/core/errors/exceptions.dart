abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException(super.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class AuthException extends AppException {
  AuthException(super.message);
}

class ValidationException extends AppException {
  ValidationException(super.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}
