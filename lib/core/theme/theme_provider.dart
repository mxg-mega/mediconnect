import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme mode enum for easier management
enum ThemeModeType { system, light, dark }

// Provider for theme state
class ThemeNotifier extends StateNotifier<ThemeModeType> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier() : super(ThemeModeType.light);

  // Load saved theme preference
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    state = ThemeModeType.values[themeIndex];
  }

  // Change theme and save preference
  Future<void> setTheme(ThemeModeType theme) async {
    if (theme == state) return;

    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }

  // Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (state == ThemeModeType.light) {
      await setTheme(ThemeModeType.dark);
    } else {
      await setTheme(ThemeModeType.light);
    }
  }
}

// Provider for theme state
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeModeType>((
  ref,
) {
  final notifier = ThemeNotifier();
  notifier.loadTheme();
  return notifier;
});

// Provider for theme data
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeProvider);
  // final brightness = WidgetsBinding.instance.window.platformBrightness;

  // Determine which theme to use based on mode and system brightness
  // final useDarkTheme =
  //     themeMode == ThemeModeType.dark ||
  //     (themeMode == ThemeModeType.system && brightness == Brightness.dark);
  final useDarkTheme = themeMode == ThemeModeType.dark;

  return useDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme;
});

// Helper extension for easy theme access
extension ThemeExtension on BuildContext {
  // Get current theme data
  ThemeData get theme => Theme.of(this);

  // Get current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Get current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Check if dark mode is active
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
