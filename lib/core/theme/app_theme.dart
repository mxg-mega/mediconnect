import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  // Access colors through AppColors
  static AppColorsTheme colors(BuildContext context) => AppColors.of(context);

  // Text themes
  static TextTheme get _textTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    return GoogleFonts.interTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.lightTheme.neutral.primaryText,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: 0,
        color: AppColors.lightTheme.neutral.secondaryText,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 22 / 24,
        letterSpacing: 0,
        color: AppColors.lightTheme.neutral.primaryText,
      ),
      // Add more text styles as needed
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: _textTheme,
      colorScheme: ColorScheme.light(
        primary: AppColors.lightTheme.patient.bg,
        secondary: AppColors.lightTheme.pharmacist.bg,
        surface: AppColors.lightTheme.neutral.bgTint,
        background: AppColors.lightTheme.neutral.bgTint,
        error: AppColors.lightTheme.support.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTheme.neutral.primaryText,
        onBackground: AppColors.lightTheme.neutral.primaryText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.lightTheme.neutral.bgTint,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.lightTheme.neutral.primaryText,
        ),
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: AppColors.lightTheme.neutral.primaryText,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightTheme.neutral.bg00,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTheme.patient.bg,
          side: BorderSide(color: AppColors.lightTheme.patient.bg),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightTheme.neutral.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightTheme.neutral.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.lightTheme.patient.bg,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightTheme.support.red),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: _textTheme.apply(
        bodyColor: AppColors.darkTheme.neutral.primaryText,
        displayColor: AppColors.darkTheme.neutral.primaryText,
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkTheme.patient.bg,
        secondary: AppColors.darkTheme.pharmacist.bg,
        surface: AppColors.darkTheme.neutral.bgTint,
        background: AppColors.darkTheme.neutral.bgTint,
        error: AppColors.darkTheme.support.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTheme.neutral.primaryText,
        onBackground: AppColors.darkTheme.neutral.primaryText,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.darkTheme.neutral.bgTint,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.darkTheme.neutral.primaryText,
        ),
        titleTextStyle: _textTheme.titleLarge?.copyWith(
          color: AppColors.darkTheme.neutral.primaryText,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Add other theme overrides as needed
    );
  }

  // Helper to get text theme
  static TextTheme textTheme(BuildContext context) =>
      Theme.of(context).textTheme;

  // Helper to get color scheme
  static ColorScheme colorScheme(BuildContext context) =>
      Theme.of(context).colorScheme;
}
