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
import 'package:mediconnect/common/auth/domain/usecases/update_user_profile_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/create_pharmacy_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/update_pharmacy_info_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sync_linked_pharmacy_use_case.dart';
import 'package:mediconnect/core/services/document_upload_service.dart';
import 'package:mediconnect/common/auth/domain/usecases/send_email_verification_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/verify_email_otp_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/reset_password_use_case.dart';
import 'package:mediconnect/common/auth/data/datasources/pharmacy_data_source.dart';
import 'package:mediconnect/common/auth/data/datasources/firebase_pharmacy_data_source.dart';
import 'package:mediconnect/common/auth/domain/repositories/pharmacy_repository.dart';
import 'package:mediconnect/common/auth/data/repositories/pharmacy_repository_impl.dart';
import 'package:mediconnect/core/network/dio_client.dart';
import 'package:mediconnect/features/pharmacist_app/data/repositories/medication_catalog_repository_impl.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/medication_catalog_repository.dart';
import 'package:mediconnect/features/pharmacist_app/data/repositories/inventory_repository_impl.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/inventory_repository.dart';
import 'package:mediconnect/features/pharmacist_app/data/repositories/dispense_repository_impl.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/dispense_repository.dart';

// Configuration providers
final useLocalAuthProvider = Provider<bool>((ref) => true);
final useFirebaseProvider = Provider<bool>((ref) => true); // Set to true when Firebase is configured

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

// Pharmacy Core
final pharmacyDataSourceProvider = Provider<PharmacyDataSource>((ref) {
  final storageLayer = ref.watch(hiveStorageLayerProvider);
  return FirebasePharmacyDataSource(storageLayer: storageLayer);
});

final pharmacyRepositoryProvider = Provider<PharmacyRepository>((ref) {
  final dataSource = ref.watch(pharmacyDataSourceProvider);
  return PharmacyRepositoryImpl(remoteDataSource: dataSource);
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

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return UpdateUserProfileUseCase(authRepository);
});

final createPharmacyUseCaseProvider = Provider<CreatePharmacyUseCase>((ref) {
  final repository = ref.watch(pharmacyRepositoryProvider);
  return CreatePharmacyUseCase(repository);
});

final getPharmacyInfoUseCaseProvider = Provider<GetPharmacyInfoUseCase>((ref) {
  final repository = ref.watch(pharmacyRepositoryProvider);
  return GetPharmacyInfoUseCase(pharmacyRepository: repository);
});

final syncLinkedPharmacyUseCaseProvider = Provider<SyncLinkedPharmacyUseCase>((ref) {
  final repository = ref.watch(pharmacyRepositoryProvider);
  return SyncLinkedPharmacyUseCase(pharmacyRepository: repository);
});

final updatePharmacyInfoUseCaseProvider = Provider<UpdatePharmacyInfoUseCase>((ref) {
  final repository = ref.watch(pharmacyRepositoryProvider);
  return UpdatePharmacyInfoUseCase(repository);
});

final sendEmailVerificationUseCaseProvider = Provider<SendEmailVerificationUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SendEmailVerificationUseCase(authRepository);
});

final verifyEmailOtpUseCaseProvider = Provider<VerifyEmailOtpUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return VerifyEmailOtpUseCase(authRepository);
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return ResetPasswordUseCase(authRepository);
});

final documentUploadServiceProvider = Provider<DocumentUploadService>((ref) {
  return DocumentUploadService();
});
