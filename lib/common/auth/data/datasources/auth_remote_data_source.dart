import 'package:mediconnect/common/auth/data/datasources/auth_data_source.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/core/errors/exceptions.dart';

class RemoteAuthDataSource extends AuthDataSource {
  @override
  final StorageLayer storageLayer;

  RemoteAuthDataSource({required this.storageLayer})
      : super(storageLayer: storageLayer);

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      final response = await storageLayer.post('/auth/signup', {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      });

      return UserModel.fromJson(response);
    } on Exception catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await storageLayer.post('/auth/login', {
        'email': email,
        'password': password,
      });

      return UserModel.fromJson(response);
    } on Exception catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await storageLayer.delete('/auth/signout');
    } on Exception catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await storageLayer.get('/auth/current-user');
      return UserModel.fromJson(response);
    } catch (e) {
      return null; // User not signed in
    }
  }
}
