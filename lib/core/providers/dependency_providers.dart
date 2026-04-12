import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/data/datasources/auth_data_source.dart';
import 'package:mediconnect/common/auth/data/datasources/remote_auth_data_source.dart';
import 'package:mediconnect/common/auth/data/datasources/firebase_auth_data_source.dart';
import 'package:mediconnect/common/auth/data/datasources/http_storage_layer.dart';
import 'package:mediconnect/common/auth/data/datasources/hive_storage_layer.dart';
import 'package:mediconnect/common/auth/data/repositories/auth_repository_impl.dart';
import 'package:mediconnect/common/auth/domain/repositories/auth_repository.dart';
import 'package:mediconnect/common/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/get_pharmacy_info_usecase.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_in_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_up_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_out_use_case.dart';
import 'package:mediconnect/core/network/dio_client.dart';
import 'package:mediconnect/features/pharmacist_app/data/repositories/medication_catalog_repository_impl.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/medication_catalog_repository.dart';
import 'package:mediconnect/features/pharmacist_app/data/repositories/inventory_repository_impl.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/inventory_repository.dart';
import 'package:mediconnect/features/pharmacist_app/data/repositories/dispense_repository_impl.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/dispense_repository.dart';

// Configuration providers
final useLocalAuthProvider = Provider<bool>((ref) => true);
final useFirebaseProvider = Provider<bool>((ref) => false); // Set to true when Firebase is configured

// Core dependencies
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final httpStorageLayerProvider = Provider<HttpStorageLayer>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return HttpStorageLayer(dioClient: dioClient);
});

final hiveStorageLayerProvider = Provider<HiveStorageLayer>((ref) {
  return HiveStorageLayer();
});

final storageLayerProvider = Provider<dynamic>((ref) {
  final useLocalAuth = ref.watch(useLocalAuthProvider);
  if (useLocalAuth) {
    return ref.watch(hiveStorageLayerProvider);
  } else {
    return ref.watch(httpStorageLayerProvider);
  }
});

// Auth data sources
final remoteAuthDataSourceProvider = Provider<AuthDataSource>((ref) {
  final storageLayer = ref.watch(storageLayerProvider);
  return RemoteAuthDataSource(storageLayer: storageLayer);
});

final firebaseAuthDataSourceProvider = Provider<AuthDataSource>((ref) {
  final storageLayer = ref.watch(hiveStorageLayerProvider); // Use local for caching if needed
  return FirebaseAuthDataSource(storageLayer: storageLayer);
});

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final useFirebase = ref.watch(useFirebaseProvider);
  if (useFirebase) {
    return ref.watch(firebaseAuthDataSourceProvider);
  } else {
    return ref.watch(remoteAuthDataSourceProvider);
  }
});

// Auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: authDataSource);
});

// Medication Catalog
final medicationCatalogRepositoryProvider = Provider<MedicationCatalogRepository>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return MedicationCatalogRepositoryImpl(dio: dio);
});

// Inventory
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepositoryImpl();
});

// Dispense
final dispenseRepositoryProvider = Provider<DispenseRepository>((ref) {
  return DispenseRepositoryImpl();
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
