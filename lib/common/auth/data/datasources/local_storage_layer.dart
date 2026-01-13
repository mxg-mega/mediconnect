import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/core/errors/exceptions.dart';

class LocalStorageLayer implements StorageLayer {
  Map<String, Map<String, dynamic>>? _currentUser;

  final Map<String, Map<String, dynamic>> _usersByEmail = {
    // Patient
    'patient@example.com': {
      'password': 'password123',
      'user_id': 'p-001',
      'email': 'patient@example.com',
      'display_name': 'Patient Zero',
      'user_type': 'patient',
      'phone_number': '08000000001',
    },
    // Pharmacist
    'pharmacist@example.com': {
      'password': 'password123',
      'user_id': 'ph-001',
      'email': 'pharmacist@example.com',
      'display_name': 'Pharmacist One',
      'user_type': 'pharmacist',
      'phone_number': '08000000002',
      'pharmacy_id': 'pharmacy-123',
    },
  };

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    switch (endpoint) {
      case '/auth/login':
        final email = data['email'] as String?;
        final password = data['password'] as String?;
        if (email == null || password == null) {
          throw AuthException('Email and password are required');
        }
        final record = _usersByEmail[email];
        if (record == null || record['password'] != password) {
          throw AuthException('Invalid credentials');
        }
        final response = Map<String, dynamic>.from(record)..remove('password');
        _currentUser = {email: response};
        return response;

      case '/auth/signup':
        final email = data['email'] as String?;
        final password = data['password'] as String?;
        if (email == null || password == null) {
          throw AuthException('Email and password are required');
        }
        if (_usersByEmail.containsKey(email)) {
          throw AuthException('The account already exists for that email');
        }
        final newUser = <String, dynamic>{
          'password': password,
          'user_id': 'local-${_usersByEmail.length + 1}',
          'email': email,
          'display_name': '${data['firstName']} ${data['lastName']}',
          'user_type': (data['userType'] as String?) ?? 'patient',
          'phone_number': data['phoneNumber'],
          'pharmacy_id': data['pharmacyId'],
        };
        _usersByEmail[email] = newUser;
        final response = Map<String, dynamic>.from(newUser)..remove('password');
        _currentUser = {email: response};
        return response;

      default:
        throw ServerException('Unsupported endpoint: $endpoint');
    }
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    switch (endpoint) {
      case '/auth/current-user':
        if (_currentUser != null && _currentUser!.isNotEmpty) {
          return _currentUser!.values.first;
        }
        throw AuthException('No user currently signed in');
      default:
        throw ServerException('Unsupported endpoint: $endpoint');
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    throw ServerException('PUT not supported for LocalStorageLayer');
  }

  @override
  Future<void> delete(String endpoint) async {
    switch (endpoint) {
      case '/auth/signout':
        _currentUser = null;
        return;
      default:
        throw ServerException('Unsupported endpoint: $endpoint');
    }
  }
}
