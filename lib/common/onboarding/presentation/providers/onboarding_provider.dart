import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingState {
  final bool isOnboardingComplete;
  final bool isLoading;
  final int currentPageIndex;

  const OnboardingState({
    this.isOnboardingComplete = false,
    this.isLoading = false,
    this.currentPageIndex = 0,
  });

  OnboardingState copyWith({
    bool? isOnboardingComplete,
    bool? isLoading,
    int? currentPageIndex,
  }) {
    return OnboardingState(
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      isLoading: isLoading ?? this.isLoading,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final FlutterSecureStorage _secureStorage;
  static const String _onboardingKey = 'onboarding_complete';

  OnboardingNotifier(this._secureStorage) : super(const OnboardingState()) {
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      state = state.copyWith(isLoading: true);
      
      final status = await _secureStorage.read(key: _onboardingKey);
      final isComplete = status == 'true';
      
      state = state.copyWith(
        isOnboardingComplete: isComplete,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> completeOnboarding() async {
    try {
      state = state.copyWith(isLoading: true);
      
      await _secureStorage.write(key: _onboardingKey, value: 'true');
      
      state = state.copyWith(
        isOnboardingComplete: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> resetOnboarding() async {
    try {
      state = state.copyWith(isLoading: true);
      
      await _secureStorage.delete(key: _onboardingKey);
      
      state = state.copyWith(
        isOnboardingComplete: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setCurrentPageIndex(int index) {
    state = state.copyWith(currentPageIndex: index);
  }
}

// Provider for FlutterSecureStorage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// Provider for OnboardingNotifier
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return OnboardingNotifier(secureStorage);
});

// Convenience providers
final isOnboardingCompleteProvider = Provider<bool>((ref) {
  return ref.watch(onboardingProvider).isOnboardingComplete;
});

final isOnboardingLoadingProvider = Provider<bool>((ref) {
  return ref.watch(onboardingProvider).isLoading;
});