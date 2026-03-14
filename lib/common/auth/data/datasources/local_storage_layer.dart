import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/core/errors/exceptions.dart';

class LocalStorageLayer implements StorageLayer {
  static const String _currentUserKey = 'auth_current_user';
  
  // In-memory cache for fast access
  Map<String, dynamic>? _currentUser;
  
  // Mock database for users (in a real offline app, this would be SQLite/Hive)
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

  LocalStorageLayer() {
    _init();
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);
      if (userJson != null) {
        _currentUser = json.decode(userJson) as Map<String, dynamic>;
      }
    } catch (e) {
      // Handle initialization error silently or log it
      print('LocalStorageLayer init error: $e');
    }
  }

  Future<void> _persistUser(Map<String, dynamic> user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, json.encode(user));
  }

  Future<void> _clearUser() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    // Ensure initialization is complete before processing
    if (_currentUser == null) await _init();

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
        await _persistUser(response);
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
          'user_type': (data['userType'] as String?) ?? 'unknown', // Default to unknown for new signups
          'phone_number': data['phoneNumber'],
          'pharmacy_id': data['pharmacyId'],
        };
        
        _usersByEmail[email] = newUser;
        final response = Map<String, dynamic>.from(newUser)..remove('password');
        await _persistUser(response);
        return response;

      default:
        throw ServerException('Unsupported endpoint: $endpoint');
    }
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    // Ensure initialization is complete before processing
    if (_currentUser == null) await _init();

    switch (endpoint) {
      case '/auth/current-user':
        if (_currentUser != null) {
          return _currentUser!;
        }
        // Instead of throwing, return empty map or null equivalent logic handled by repo
        // But the interface expects a map, so we throw if no user found
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
        await _clearUser();
        return;
      default:
        throw ServerException('Unsupported endpoint: $endpoint');
    }
  }
}
