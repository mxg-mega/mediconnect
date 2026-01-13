import 'package:flutter/material.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/core/config/app_config.dart';
import 'package:mediconnect/core/utils/responsive_utils.dart';

/// Theme extension for responsive design access
class ResponsiveThemeExtension extends ThemeExtension<ResponsiveThemeExtension> {
  final Color primaryColor;
  final UserType userType;

  const ResponsiveThemeExtension({
    required this.primaryColor,
    required this.userType,
  });

  @override
  ResponsiveThemeExtension copyWith({
    Color? primaryColor,
    UserType? userType,
  }) {
    return ResponsiveThemeExtension(
      primaryColor: primaryColor ?? this.primaryColor,
      userType: userType ?? this.userType,
    );
  }

  @override
  ResponsiveThemeExtension lerp(
    ResponsiveThemeExtension? other,
    double t,
  ) {
    if (other is! ResponsiveThemeExtension) {
      return this;
    }
    return ResponsiveThemeExtension(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      userType: userType, // UserType doesn't lerp, keep current
    );
  }
}
