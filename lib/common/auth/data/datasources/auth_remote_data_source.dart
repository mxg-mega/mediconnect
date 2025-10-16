import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mediconnect/common/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    // TODO: Implement login logic with a real API
    // For now, we'll return a dummy user
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@test.com' && password == 'password') {
      return UserModel(
        id: '1',
        name: 'Test User',
        email: email,
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<UserModel> signup(String name, String email, String password) async {
    // TODO: Implement signup logic with a real API
    // For now, we'll return a dummy user
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: '2',
      name: name,
      email: email,
    );
  }
}
