import 'package:flutter/material.dart';
import 'package:mediconnect/common/auth/domain/entities/user_entity.dart';
import 'package:mediconnect/common/auth/domain/usecases/login_usecase.dart';
import 'package:mediconnect/common/auth/domain/usecases/signup_usecase.dart';

enum AuthState { initial, loading, authenticated, error }

class AuthNotifier extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  AuthNotifier({required this.loginUseCase, required this.signupUseCase});

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  UserEntity? _user;
  UserEntity? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      _user = await loginUseCase(email, password);
      _state = AuthState.authenticated;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      _user = await signupUseCase(name, email, password);
      _state = AuthState.authenticated;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
