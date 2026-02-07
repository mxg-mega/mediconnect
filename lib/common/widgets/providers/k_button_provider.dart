import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';

enum ButtonState { idle, loading, disabled, success }

class KButtonState {
  final ButtonState state;
  final UserRole? explicitRole;
  final bool useRoleBasedStyling;
  final String? errorMessage;

  const KButtonState({
    this.state = ButtonState.idle,
    this.explicitRole,
    this.useRoleBasedStyling = true,
    this.errorMessage,
  });

  KButtonState copyWith({
    ButtonState? state,
    UserRole? explicitRole,
    bool? useRoleBasedStyling,
    String? errorMessage,
  }) {
    return KButtonState(
      state: state ?? this.state,
      explicitRole: explicitRole ?? this.explicitRole,
      useRoleBasedStyling: useRoleBasedStyling ?? this.useRoleBasedStyling,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => state == ButtonState.loading;
  bool get isDisabled => state == ButtonState.disabled;
  bool get isIdle => state == ButtonState.idle;
  bool get isSuccess => state == ButtonState.success;
  bool get hasError => errorMessage != null;
}

class KButtonNotifier extends StateNotifier<KButtonState> {
  KButtonNotifier() : super(const KButtonState());

  void setLoading(bool loading) {
    state = state.copyWith(
      state: loading ? ButtonState.loading : ButtonState.idle,
    );
  }

  void setDisabled(bool disabled) {
    state = state.copyWith(
      state: disabled ? ButtonState.disabled : ButtonState.idle,
    );
  }

  void setSuccess() {
    state = state.copyWith(state: ButtonState.success);
    // Auto-reset to idle after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (state.isSuccess) {
        state = state.copyWith(state: ButtonState.idle);
      }
    });
  }

  void setError(String error) {
    state = state.copyWith(state: ButtonState.idle, errorMessage: error);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void setExplicitRole(UserRole role) {
    state = state.copyWith(explicitRole: role);
  }

  void setRoleBasedStyling(bool enabled) {
    state = state.copyWith(useRoleBasedStyling: enabled);
  }

  void reset() {
    state = const KButtonState();
  }

  // Execute an action with automatic loading state management
  Future<void> executeAction(
    Future<void> Function() action, {
    String? errorMessage,
  }) async {
    try {
      setLoading(true);
      clearError();
      await action();
      setSuccess();
    } catch (e) {
      setError(errorMessage ?? 'An error occurred: $e');
    } finally {
      setLoading(false);
    }
  }
}

// Global button provider for shared button state
final kButtonProvider = StateNotifierProvider<KButtonNotifier, KButtonState>((
  ref,
) {
  return KButtonNotifier();
});

// Provider for button-specific instances (using family modifier)
final kButtonFamilyProvider =
    StateNotifierProvider.family<KButtonNotifier, KButtonState, String>((
      ref,
      id,
    ) {
      return KButtonNotifier();
    });

// Convenience provider to get effective role for buttons
final kButtonRoleProvider = Provider<UserRole>((ref) {
  final buttonState = ref.watch(kButtonProvider);
  final appScaffoldNotifier = ref.read(appScaffoldProvider.notifier);

  // Use explicit role if set, otherwise use app scaffold role
  return buttonState.explicitRole ?? appScaffoldNotifier.getEffectiveRole();
});

// Provider to determine if button should be in loading state
final kButtonLoadingProvider = Provider<bool>((ref) {
  final buttonState = ref.watch(kButtonProvider);
  final globalLoading = ref.watch(
    appScaffoldProvider.select((state) => state.isLoading),
  );

  return buttonState.isLoading || globalLoading;
});
