import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/data/datasources/auth_data_source.dart';
import 'package:mediconnect/common/auth/data/datasources/remote_auth_data_source.dart';
import 'package:mediconnect/common/auth/data/datasources/http_storage_layer.dart';
import 'package:mediconnect/common/auth/data/datasources/local_storage_layer.dart';
import 'package:mediconnect/common/auth/data/repositories/auth_repository_impl.dart';
import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';
import 'package:mediconnect/common/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/get_pharmacy_info_usecase.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_in_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_up_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_out_use_case.dart';
import 'package:mediconnect/core/network/dio_client.dart';

// Configuration provider
final useLocalAuthProvider = Provider<bool>((ref) => true);

// Core dependencies
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final httpStorageLayerProvider = Provider<HttpStorageLayer>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return HttpStorageLayer(dioClient: dioClient);
});

final localStorageLayerProvider = Provider<LocalStorageLayer>((ref) {
  return LocalStorageLayer();
});

final storageLayerProvider = Provider<dynamic>((ref) {
  final useLocalAuth = ref.watch(useLocalAuthProvider);
  if (useLocalAuth) {
    return ref.watch(localStorageLayerProvider);
  } else {
    return ref.watch(httpStorageLayerProvider);
  }
});

// Auth data source
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final storageLayer = ref.watch(storageLayerProvider);
  return RemoteAuthDataSource(storageLayer: storageLayer);
});

// Auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: authDataSource);
});

// Use cases
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(authRepository);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInUseCase(authRepository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(authRepository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(authRepository);
});

final getPharmacyInfoUseCaseProvider = Provider<GetPharmacyInfoUseCase?>((ref) {
  // This can be implemented later when pharmacy functionality is added
  return null;
});
