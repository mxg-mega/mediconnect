import 'package:flutter/material.dart';

/// A comprehensive color system for the app with light/dark mode support.
///
/// Usage:
/// ```dart
/// // Access colors directly
/// AppColors.Neutral.bg00
///
/// // Access with theme context (supports dark/light mode)
/// AppColors.of(context).neutral.bg00
/// ```
class AppColors {
  // Private constructor to prevent instantiation
  const AppColors._();

  /// Returns the current theme's colors based on the provided BuildContext
  static AppColorsTheme of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }

  /// Light theme colors
  static const lightTheme = AppColorsTheme(
    neutral: NeutralColors(
      bg00: Color(0xFF669F77),
      bg: Color(0xFF607D8B),
      border: Color(0xFF90A4AE),
      bgTint: Color(0xFFF7F7F7),
      placeholderDisabled: Color(0xFFB0BEC5),
      primaryText: Color(0xFF212121),
      secondaryText: Color(0xFF37474F),
      tertiaryText: Color(0xFFA6B4BF),
      buttonTextWhite: Color(0xFFFFFFFF),
    ),
    patient: PatientColors(
      bg: Color(0xFF0058FF),
      bgTint: Color(0x1A2196F3),
      border: Color(0x332196F3),
      disabled: Color(0x802196F3),
    ),
    pharmacist: PharmacistColors(
      bg: Color(0xFF228B22),
      bgTint: Color(0x1A228B22),
      border: Color(0x33228B22),
      disabled: Color(0x80228B22),
    ),
    support: SupportColors(
      red: Color(0xFFCF0606),
      link: Color(0xFFC42454),
      green: Color(0xFF50D261),
      subtleReminder: Color(0xFF6C7C9C),
    ),
  );

  /// Dark theme colors (override specific colors as needed)
  static final darkTheme = lightTheme.copyWith(
    neutral: lightTheme.neutral.copyWith(
      primaryText: Colors.white,
      secondaryText: Color(0xFFB0BEC5),
      bg: Color(0xFF455A64),
      bgTint: Color(0xFF263238),
    ),
    // Add more dark theme overrides as needed
  );
}

/// Base class for theme colors
class AppColorsTheme {
  final NeutralColors neutral;
  final PatientColors patient;
  final PharmacistColors pharmacist;
  final SupportColors support;

  const AppColorsTheme({
    required this.neutral,
    required this.patient,
    required this.pharmacist,
    required this.support,
  });

  AppColorsTheme copyWith({
    NeutralColors? neutral,
    PatientColors? patient,
    PharmacistColors? pharmacist,
    SupportColors? support,
  }) {
    return AppColorsTheme(
      neutral: neutral ?? this.neutral,
      patient: patient ?? this.patient,
      pharmacist: pharmacist ?? this.pharmacist,
      support: support ?? this.support,
    );
  }
}

class NeutralColors {
  final Color bg00;
  final Color bg;
  final Color border;
  final Color bgTint;
  final Color placeholderDisabled;
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color buttonTextWhite;

  const NeutralColors({
    required this.bg00,
    required this.bg,
    required this.border,
    required this.bgTint,
    required this.placeholderDisabled,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.buttonTextWhite,
  });

  NeutralColors copyWith({
    Color? bg00,
    Color? bg,
    Color? border,
    Color? bgTint,
    Color? placeholderDisabled,
    Color? primaryText,
    Color? secondaryText,
    Color? tertiaryText,
    Color? buttonTextWhite,
  }) {
    return NeutralColors(
      bg00: bg00 ?? this.bg00,
      bg: bg ?? this.bg,
      border: border ?? this.border,
      bgTint: bgTint ?? this.bgTint,
      placeholderDisabled: placeholderDisabled ?? this.placeholderDisabled,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertiaryText: tertiaryText ?? this.tertiaryText,
      buttonTextWhite: buttonTextWhite ?? this.buttonTextWhite,
    );
  }
}

class PatientColors {
  final Color bg;
  final Color bgTint;
  final Color border;
  final Color disabled;

  const PatientColors({
    required this.bg,
    required this.bgTint,
    required this.border,
    required this.disabled,
  });

  PatientColors copyWith({
    Color? bg,
    Color? bgTint,
    Color? border,
    Color? disabled,
  }) {
    return PatientColors(
      bg: bg ?? this.bg,
      bgTint: bgTint ?? this.bgTint,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
    );
  }
}

class PharmacistColors {
  final Color bg;
  final Color bgTint;
  final Color border;
  final Color disabled;

  const PharmacistColors({
    required this.bg,
    required this.bgTint,
    required this.border,
    required this.disabled,
  });

  PharmacistColors copyWith({
    Color? bg,
    Color? bgTint,
    Color? border,
    Color? disabled,
  }) {
    return PharmacistColors(
      bg: bg ?? this.bg,
      bgTint: bgTint ?? this.bgTint,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
    );
  }
}

class SupportColors {
  final Color red;
  final Color link;
  final Color green;
  final Color subtleReminder;

  const SupportColors({
    required this.red,
    required this.link,
    required this.green,
    required this.subtleReminder,
  });

  SupportColors copyWith({
    Color? red,
    Color? link,
    Color? green,
    Color? subtleReminder,
  }) {
    return SupportColors(
      red: red ?? this.red,
      link: link ?? this.link,
      green: green ?? this.green,
      subtleReminder: subtleReminder ?? this.subtleReminder,
    );
  }
}
