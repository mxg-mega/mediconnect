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
    final response = await storageLayer.post('/auth/signup', {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
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
}
