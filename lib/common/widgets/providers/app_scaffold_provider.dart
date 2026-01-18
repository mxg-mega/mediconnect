import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/constants/colors.dart';

enum UserRole { patient, pharmacist, none }

enum AppFlow { onboarding, signup, authenticated }

class AppScaffoldState {
  final UserRole currentRole;
  final UserRole previewRole; // For signup flow preview
  final AppFlow currentFlow;
  final bool isLoading;

  const AppScaffoldState({
    this.currentRole = UserRole.none,
    this.previewRole = UserRole.none,
    this.currentFlow = AppFlow.onboarding,
    this.isLoading = false,
  });

  AppScaffoldState copyWith({
    UserRole? currentRole,
    UserRole? previewRole,
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
  AppScaffoldNotifier() : super(const AppScaffoldState());

  void updateRole(UserRole role) {
    state = state.copyWith(currentRole: role);
  }

  void setFlow(AppFlow flow) {
    state = state.copyWith(currentFlow: flow);
  }

  void setPreviewRole(UserRole role) {
    state = state.copyWith(previewRole: role);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  // Get the effective role based on flow
  UserRole getEffectiveRole() {
    switch (state.currentFlow) {
      case AppFlow.signup:
        return state.previewRole;
      case AppFlow.authenticated:
        return state.currentRole;
      case AppFlow.onboarding:
      default:
        return UserRole.none;
    }
  }

  Color getBackgroundColor() {
    final effectiveRole = getEffectiveRole();
    switch (effectiveRole) {
      case UserRole.patient:
        return AppColors.lightTheme.patient.bg;
      case UserRole.pharmacist:
        return AppColors.lightTheme.pharmacist.bg;
      case UserRole.none:
      default:
        return AppColors.lightTheme.neutral.bg00;
    }
  }

  Color getScaffoldColor() {
    final effectiveRole = getEffectiveRole();
    switch (effectiveRole) {
      case UserRole.patient:
        return AppColors.lightTheme.patient.bgTint;
      case UserRole.pharmacist:
        return AppColors.lightTheme.pharmacist.bgTint;
      case UserRole.none:
      default:
        return AppColors.lightTheme.neutral.bgTint;
    }
  }
}

// Provider instances
final appScaffoldProvider =
    StateNotifierProvider<AppScaffoldNotifier, AppScaffoldState>((ref) {
      return AppScaffoldNotifier();
    });

// Convenience providers for specific values
final appScaffoldBackgroundColorProvider = Provider<Color>((ref) {
  return ref.watch(appScaffoldProvider.notifier).getBackgroundColor();
});

final appScaffoldScaffoldColorProvider = Provider<Color>((ref) {
  return ref.watch(appScaffoldProvider.notifier).getScaffoldColor();
});

final appScaffoldRoleProvider = Provider<UserRole>((ref) {
  return ref.watch(appScaffoldProvider).currentRole;
});
final appScaffoldFlowProvider = Provider<AppFlow>((ref) {
  return ref.watch(appScaffoldProvider).currentFlow;
});
