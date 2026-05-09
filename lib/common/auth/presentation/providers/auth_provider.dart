import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/get_pharmacy_info_usecase.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_in_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_up_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_out_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/update_user_profile_use_case.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final Pharmacy? pharmacy;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.uninitialized,
    this.user,
    this.pharmacy,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    Pharmacy? pharmacy,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      pharmacy: pharmacy ?? this.pharmacy,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetPharmacyInfoUseCase? getPharmacyInfoUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  AuthNotifier({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateUserProfileUseCase,
    this.getPharmacyInfoUseCase,
  }) : super(const AuthState()) {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    print('AuthNotifier: signUp called for email: $email');
    try {
      state = state.copyWith(status: AuthStatus.loading);

      final user = await signUpUseCase(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      print('AuthNotifier: signUp successful. Setting status to authenticated.');
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      print('AuthNotifier: signUp failed. Error: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    print('AuthNotifier: signIn called for email: $email');
    try {
      state = state.copyWith(status: AuthStatus.loading);

      final user = await signInUseCase(email: email, password: password);

      print('AuthNotifier: signIn successful. Setting status to authenticated.');
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      print('AuthNotifier: signIn failed. Error: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);

      await signOutUseCase();

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        pharmacy: null,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> mockSignIn(UserType type) async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 500));
    final mockUser = UserModel(
      id: 'mock-id',
      email: 'mock@example.com',
      firstName: 'Mock',
      lastName: type.displayName,
      phoneNumber: '0000000000',
      userType: type,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: mockUser,
      errorMessage: null,
    );
  }

  Future<void> updateProfileInfo({required UserModel updatedUser}) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      
      final user = await updateUserProfileUseCase(updatedUser);
      
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  void updateProfileStatus({required bool isComplete}) {
    if (state.user != null) {
      state = state.copyWith(
        user: state.user!.copyWith(isProfileComplete: isComplete),
      );
    }
  }

  void clearError() {
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: null,
    );
  }
}

// Provider for AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // These will be provided by dependency injection providers
  final signUpUseCase = ref.watch(signUpUseCaseProvider);
  final signInUseCase = ref.watch(signInUseCaseProvider);
  final signOutUseCase = ref.watch(signOutUseCaseProvider);
  final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
  final getPharmacyInfoUseCase = ref.watch(getPharmacyInfoUseCaseProvider);
  final updateUserProfileUseCase = ref.watch(updateUserProfileUseCaseProvider);

  return AuthNotifier(
    signUpUseCase: signUpUseCase,
    signInUseCase: signInUseCase,
    signOutUseCase: signOutUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase,
    updateUserProfileUseCase: updateUserProfileUseCase,
    getPharmacyInfoUseCase: getPharmacyInfoUseCase,
  );
});

// Convenience providers for accessing auth state
final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authProvider).status;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).errorMessage;
});

/// Reads the active pharmacy/business ID from Hive cache.
/// This is the canonical source of truth for which business the user
/// is currently operating under (multi-tenancy friendly).
final currentPharmacyIdProvider = FutureProvider<String?>((ref) async {
  final storageLayer = ref.watch(hiveStorageLayerProvider);
  final user = ref.watch(currentUserProvider);
  
  // 1. Try Hive Cache first
  try {
    final businessData = await storageLayer.get('current_business');
    final id = businessData['id']?.toString();
    if (id != null && id.isNotEmpty) {
      print('DEBUG: currentPharmacyIdProvider - Found in Hive: $id');
      return id;
    }
  } catch (_) {
    print('DEBUG: currentPharmacyIdProvider - Not found in Hive cache');
  }

  // 2. If user is authenticated and is a pharmacist, try Firestore memberships
  if (user != null && user.userType == UserType.pharmacist) {
    print('DEBUG: currentPharmacyIdProvider - Hive empty. Falling back to Firestore for user: ${user.id}');
    try {
      final firestore = FirebaseFirestore.instance;
      final memberships = await firestore
          .collection('users')
          .doc(user.id)
          .collection('memberships')
          .limit(1)
          .get();

      if (memberships.docs.isNotEmpty) {
        final pharmacyId = memberships.docs.first.id;
        print('DEBUG: currentPharmacyIdProvider - Found in Firestore memberships: $pharmacyId');
        
        // Fetch full pharmacy info to populate Hive cache for next time
        // This ensures subsequent calls are fast
        try {
          final pharmacyDoc = await firestore.collection('businesses').doc(pharmacyId).get();
          if (pharmacyDoc.exists) {
            await storageLayer.put('current_business', pharmacyDoc.data()!);
            print('DEBUG: currentPharmacyIdProvider - Populated Hive cache with $pharmacyId');
          }
        } catch (e) {
          print('DEBUG: currentPharmacyIdProvider - Error populating Hive: $e');
        }
        
        return pharmacyId;
      }
    } catch (e) {
      print('DEBUG: currentPharmacyIdProvider - Firestore fallback failed: $e');
    }
  }

  print('DEBUG: currentPharmacyIdProvider - No pharmacy ID found anywhere.');
  return null;
});
