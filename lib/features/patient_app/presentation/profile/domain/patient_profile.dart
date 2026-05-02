import 'package:flutter/material.dart';

class PatientProfile {
  final String name;
  final bool isVerified;
  final String avatarUrl;
  final List<ProfileSection> sections;

  PatientProfile({
    required this.name,
    required this.isVerified,
    required this.avatarUrl,
    required this.sections,
  });
}

class ProfileSection {
  final String title;
  final List<ProfileItem> items;

  ProfileSection({
    required this.title,
    required this.items,
  });
}

class ProfileItem {
  final String title;
  final String subtitle;
  final String icon; // Changed to String to accommodate SVG paths (e.g. AppIcons.profile)
  final String route;
  final bool isLogout;

  ProfileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.isLogout = false,
  });
}
