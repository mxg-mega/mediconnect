import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  final StorageLayer storageLayer;

  AuthDataSource({required this.storageLayer});

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}
