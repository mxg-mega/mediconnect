import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import '../constants/colors.dart';

class AppTheme {
  // Access colors through AppColors
  static AppColorsTheme colors(BuildContext context) => AppColors.of(context);

  // Text themes
  static TextTheme get _textTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    final inter = GoogleFonts.interTextTheme(baseTextTheme);

    // Typography tokens from assets/fonts.css:
    // - Inter: body + paragraphs
    // - Outfit (SemiBold 600): headings H1..H5
    return inter.copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.normal),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.38,
      ),
      bodySmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.26,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.26,
      ),
      titleSmall: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
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
          textStyle: AppTextStyles.interP18M,
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
        prefixIconColor: AppColors.lightTheme.neutral.secondaryText,
        suffixIconColor: AppColors.lightTheme.neutral.secondaryText,
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
