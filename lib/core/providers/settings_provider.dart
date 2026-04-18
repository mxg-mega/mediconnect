import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';

class SettingsState {
  final ThemeMode themeMode;
  final String languageCode;
  final Map<String, bool> notifications;
  final bool hasSeenOnboarding;

  SettingsState({
    this.themeMode = ThemeMode.system,
    this.languageCode = 'en',
    this.notifications = const {
      'low_stock': true,
      'expiry': true,
      'reviews': true,
      'app_updates': false,
    },
    this.hasSeenOnboarding = false,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    Map<String, bool>? notifications,
    bool? hasSeenOnboarding,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      notifications: notifications ?? this.notifications,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final dynamic _storage;

  SettingsNotifier(this._storage) : super(SettingsState()) {
    _loadSettings();
  }

  static const String _settingsKey = 'user_settings';

  Future<void> _loadSettings() async {
    try {
      final data = await _storage.get(_settingsKey);
      state = SettingsState(
        themeMode: _parseThemeMode(data['themeMode']),
        languageCode: data['languageCode'] ?? 'en',
        notifications: Map<String, bool>.from(data['notifications'] ?? state.notifications),
        hasSeenOnboarding: data['hasSeenOnboarding'] ?? false,
      );
    } catch (e) {
      // Default settings used if not found
    }
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    _saveSettings();
  }

  Future<void> updateLanguage(String code) async {
    state = state.copyWith(languageCode: code);
    _saveSettings();
  }

  Future<void> updateNotification(String key, bool value) async {
    final newNotifications = Map<String, bool>.from(state.notifications);
    newNotifications[key] = value;
    state = state.copyWith(notifications: newNotifications);
    _saveSettings();
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    state = state.copyWith(hasSeenOnboarding: value);
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    await _storage.put(_settingsKey, {
      'themeMode': state.themeMode.name,
      'languageCode': state.languageCode,
      'notifications': state.notifications,
      'hasSeenOnboarding': state.hasSeenOnboarding,
    });
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final storage = ref.watch(hiveStorageLayerProvider);
  return SettingsNotifier(storage);
});
