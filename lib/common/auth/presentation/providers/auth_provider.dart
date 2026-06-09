import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sync_linked_pharmacy_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_in_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_up_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/sign_out_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/update_user_profile_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/send_email_verification_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/verify_email_otp_use_case.dart';
import 'package:mediconnect/common/auth/domain/usecases/reset_password_use_case.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/core/utils/firebase_error_parser.dart';

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
      (status == AuthStatus.authenticated || status == AuthStatus.loading) &&
      user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SyncLinkedPharmacyUseCase? syncLinkedPharmacyUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;
  final VerifyEmailOtpUseCase verifyEmailOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthNotifier({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateUserProfileUseCase,
    required this.sendEmailVerificationUseCase,
    required this.verifyEmailOtpUseCase,
    required this.resetPasswordUseCase,
    this.syncLinkedPharmacyUseCase,
  }) : super(const AuthState()) {
    _checkCurrentUser();
  }

  Future<void> _syncPharmacyIfNeeded(UserModel? user) async {
    if (user == null || user.userType != UserType.pharmacist) return;
    final sync = syncLinkedPharmacyUseCase;
    if (sync == null) return;
    try {
      await sync(user.id);
    } catch (e) {
      print('AuthNotifier: pharmacy sync failed: $e');
    }
  }

  Future<void> _checkCurrentUser() async {
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        await _syncPharmacyIfNeeded(user);
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: FirebaseErrorParser.parseError(e),
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

      print(
        'AuthNotifier: signUp successful. Setting status to authenticated.',
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      print('AuthNotifier: signUp failed. Error: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: FirebaseErrorParser.parseError(e),
      );
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    print('AuthNotifier: signIn called for email: $email');
    try {
      state = state.copyWith(status: AuthStatus.loading);

      final user = await signInUseCase(email: email, password: password);

      print(
        'AuthNotifier: signIn successful. Setting status to authenticated.',
      );
      await _syncPharmacyIfNeeded(user);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      print('AuthNotifier: signIn failed. Error: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: FirebaseErrorParser.parseError(e),
      );
      rethrow;
    }
  }

  Future<void> sendEmailVerification(
    String email, {
    String intent = 'signup',
  }) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      await sendEmailVerificationUseCase(email, intent: intent);

      if (intent == 'password_reset') {
        // Restore to unauthenticated – the user is NOT logged in during
        // password reset. This matches the router's expectation: an
        // unauthenticated user on an auth-flow page → no redirect.
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: null,
        );
      } else {
        // Normal sign-up / login flow
        state = state.copyWith(
          status: state.user != null
              ? AuthStatus.authenticated
              : AuthStatus.uninitialized,
          errorMessage: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: FirebaseErrorParser.parseError(e),
      );
      rethrow;
    }
  }

  Future<String?> verifyEmailOtp(
    String email,
    String code, {
    String intent = 'signup',
  }) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final resetToken = await verifyEmailOtpUseCase(
        email,
        code,
        intent: intent,
      );

      // Update local user state to reflect verification if it's a signup
      if (intent == 'signup' && state.user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: state.user!.copyWith(
            verificationStatus: VerificationStatus.verified,
          ),
          errorMessage: null,
        );
      } else {
        // For password reset, stay unauthenticated – the user is not logged in.
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          errorMessage: null,
        );
      }

      return resetToken;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: FirebaseErrorParser.parseError(e),
      );
      rethrow;
    }
  }

  Future<void> resetPassword(
    String email,
    String resetToken,
    String newPassword,
  ) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      await resetPasswordUseCase(email, resetToken, newPassword);
      // Clear any authenticated user after password reset
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: FirebaseErrorParser.parseError(e),
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
        errorMessage: FirebaseErrorParser.parseError(e),
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

      await _syncPharmacyIfNeeded(user);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: FirebaseErrorParser.parseError(e),
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
  final syncLinkedPharmacyUseCase = ref.watch(
    syncLinkedPharmacyUseCaseProvider,
  );
  final updateUserProfileUseCase = ref.watch(updateUserProfileUseCaseProvider);
  final sendEmailVerificationUseCase = ref.watch(
    sendEmailVerificationUseCaseProvider,
  );
  final verifyEmailOtpUseCase = ref.watch(verifyEmailOtpUseCaseProvider);
  final resetPasswordUseCase = ref.watch(resetPasswordUseCaseProvider);

  return AuthNotifier(
    signUpUseCase: signUpUseCase,
    signInUseCase: signInUseCase,
    signOutUseCase: signOutUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase,
    updateUserProfileUseCase: updateUserProfileUseCase,
    sendEmailVerificationUseCase: sendEmailVerificationUseCase,
    verifyEmailOtpUseCase: verifyEmailOtpUseCase,
    resetPasswordUseCase: resetPasswordUseCase,
    syncLinkedPharmacyUseCase: syncLinkedPharmacyUseCase,
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

  bool cacheBelongsToUser(Map<String, dynamic> businessData) {
    if (user == null) return false;
    final ownerUid = businessData['owner_uid']?.toString();
    if (ownerUid != null && ownerUid.isNotEmpty) {
      return ownerUid == user.id;
    }
    final employeeIds =
        (businessData['employee_ids'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    return employeeIds.contains(user.id);
  }

  // 1. Try Hive cache first (must belong to current user)
  try {
    final businessData = await storageLayer.get('current_business');
    if (cacheBelongsToUser(businessData)) {
      final id = businessData['id']?.toString();
      if (id != null && id.isNotEmpty) {
        return id;
      }
    } else {
      await storageLayer.delete('current_business');
    }
  } catch (_) {}

  // 2. If user is authenticated pharmacist, sync from Firestore memberships
  if (user != null && user.userType == UserType.pharmacist) {
    try {
      final sync = ref.read(syncLinkedPharmacyUseCaseProvider);
      final pharmacy = await sync(user.id);
      if (pharmacy != null && pharmacy.id.isNotEmpty) {
        return pharmacy.id;
      }
    } catch (e) {
      print('DEBUG: currentPharmacyIdProvider - Firestore sync failed: $e');
    }
  }

  return null;
});
