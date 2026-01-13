import 'package:mediconnect/common/auth/data/datasources/auth_data_source.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';

class RemoteAuthDataSource implements AuthDataSource {
  @override
  final StorageLayer storageLayer;

  RemoteAuthDataSource({required this.storageLayer});
  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    // In a real app, this would be an API call
    return UserModel(
      id: '123',
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    // In a real app, this would be an API call
    if (email == 'test@example.com' && password == 'password') {
      return UserModel(
        id: '123',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        phoneNumber: '1234567890',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // In a real app, this would clear session/token
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    // In a real app, this would check for an existing session/token
    return null; // For now, no user is logged in by default
  }
}
