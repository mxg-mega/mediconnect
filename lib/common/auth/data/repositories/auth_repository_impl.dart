import 'package:mediconnect/common/auth/data/datasources/auth_data_source.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return await remoteDataSource.signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.signIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    return await remoteDataSource.updateUser(user);
  }

  @override
  Future<void> sendEmailVerification(String email, {String intent = 'signup'}) async {
    await remoteDataSource.sendEmailVerification(email, intent: intent);
  }

  @override
  Future<String?> verifyEmailOtp(String email, String code, {String intent = 'signup'}) async {
    return await remoteDataSource.verifyEmailOtp(email, code, intent: intent);
  }

  @override
  Future<void> resetPassword(String email, String resetToken, String newPassword) async {
    await remoteDataSource.resetPassword(email, resetToken, newPassword);
  }
}