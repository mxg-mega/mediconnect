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
  }) async {
    final response = await storageLayer.post('/auth/signup', {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    });
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await storageLayer.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response);
  }

  @override
  Future<void> signOut() async {
    await storageLayer.delete('/auth/signout');
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await storageLayer.get('/auth/current-user');
      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final response = await storageLayer.put('/auth/user/${user.id}', user.toJson());
    return UserModel.fromJson(response);
  }

  @override
  Future<void> sendEmailVerification(String email) async {
    throw UnimplementedError('HTTP email verification is not implemented yet');
  }

  @override
  Future<void> verifyEmailOtp(String code) async {
    throw UnimplementedError('HTTP OTP verification is not implemented yet');
  }
}
