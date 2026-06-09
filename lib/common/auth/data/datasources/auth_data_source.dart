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
  });

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<UserModel> updateUser(UserModel user);

  Future<void> sendEmailVerification(String email, {String intent = 'signup'});

  Future<String?> verifyEmailOtp(String email, String code, {String intent = 'signup'});

  Future<void> resetPassword(String email, String resetToken, String newPassword);
}
