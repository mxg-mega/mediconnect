import 'package:flutter/material.dart';

class PharmacistProfile {
  final String name;
  final bool isVerified;
  final String avatarUrl;
  final List<ProfileSection> sections;

  PharmacistProfile({
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
  final IconData icon;
  final String route;

  ProfileItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}
