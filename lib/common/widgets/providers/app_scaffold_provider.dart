import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/constants/colors.dart';

enum AppFlow { onboarding, signup, authenticated }

class AppScaffoldState {
  final UserType currentRole;
  final UserType previewRole; // For signup flow preview
  final AppFlow currentFlow;
  final bool isLoading;

  const AppScaffoldState({
    this.currentRole = UserType.unknown,
    this.previewRole = UserType.unknown,
    this.currentFlow = AppFlow.onboarding,
    this.isLoading = false,
  });

  AppScaffoldState copyWith({
    UserType? currentRole,
    UserType? previewRole,
    AppFlow? currentFlow,
    bool? isLoading,
  }) {
    return AppScaffoldState(
      currentRole: currentRole ?? this.currentRole,
      previewRole: previewRole ?? this.previewRole,
      currentFlow: currentFlow ?? this.currentFlow,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AppScaffoldNotifier extends StateNotifier<AppScaffoldState> {
  final Ref _ref;

  AppScaffoldNotifier(this._ref) : super(AppScaffoldState()) {
    _init();
  }

  void _init() {
    // Listen to auth changes and update scaffold state accordingly
    _ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated && next.user != null) {
        updateRole(next.user!.userType);
        setFlow(AppFlow.authenticated);
      } else if (next.status == AuthStatus.unauthenticated) {
        updateRole(UserType.unknown);
        // Only reset to onboarding if we were previously authenticated
        if (previous?.status == AuthStatus.authenticated) {
          setFlow(AppFlow.onboarding);
        }
      }
    }, fireImmediately: true);
  }

  void updateRole(UserType role) {
    state = state.copyWith(currentRole: role);
  }

  void setFlow(AppFlow flow) {
    state = state.copyWith(currentFlow: flow);
  }

  void setPreviewRole(UserType role) {
    state = state.copyWith(previewRole: role);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  // Get the effective role based on flow
  UserType getEffectiveRole() {
    switch (state.currentFlow) {
      case AppFlow.signup:
        return state.previewRole;
      case AppFlow.authenticated:
        return state.currentRole;
      case AppFlow.onboarding:
        return UserType.unknown;
    }
    
  }

  Color getBackgroundColor() {
    final effectiveRole = getEffectiveRole();
    switch (effectiveRole) {
      case UserType.patient:
        return AppColors.lightTheme.patient.bg;
      case UserType.pharmacist:
        return AppColors.lightTheme.pharmacist.bg;
      case UserType.unknown:
        return AppColors.lightTheme.neutral.bg00;
    }
  }

  Color getScaffoldColor() {
    final effectiveRole = getEffectiveRole();
    switch (effectiveRole) {
      case UserType.patient:
        return AppColors.lightTheme.neutral.bgTint;
      case UserType.pharmacist:
        return AppColors.lightTheme.neutral.bgTint;
      case UserType.unknown:
        return AppColors.lightTheme.neutral.bgTint;
    }
  }
}

// Provider instances
final appScaffoldProvider =
    StateNotifierProvider<AppScaffoldNotifier, AppScaffoldState>((ref) {
      return AppScaffoldNotifier(ref);
    });

// Convenience providers for specific values
final appScaffoldBackgroundColorProvider = Provider<Color>((ref) {
  ref.watch(appScaffoldProvider);
  return ref.read(appScaffoldProvider.notifier).getBackgroundColor();
});

final appScaffoldScaffoldColorProvider = Provider<Color>((ref) {
  ref.watch(appScaffoldProvider);
  return ref.read(appScaffoldProvider.notifier).getScaffoldColor();
});

final appScaffoldRoleProvider = Provider<UserType>((ref) {
  return ref.watch(appScaffoldProvider).currentRole;
});
final appScaffoldFlowProvider = Provider<AppFlow>((ref) {
  return ref.watch(appScaffoldProvider).currentFlow;
});
