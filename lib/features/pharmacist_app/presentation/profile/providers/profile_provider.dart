import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/domain/pharmacist_profile.dart';

final profileProvider = Provider<PharmacistProfile>((ref) {
  return PharmacistProfile(
    name: 'Pharmacist Muneer',
    isVerified: true,
    avatarUrl: 'https://via.placeholder.com/150', // Placeholder
    sections: [
      ProfileSection(
        title: 'Account',
        items: [
          ProfileItem(
            title: 'Personal Details',
            subtitle: 'View or edit your name & contact info',
            icon: Icons.person_outline,
            route: '/profile/personal_details',
          ),
          ProfileItem(
            title: 'Pharmacy Information',
            subtitle: 'Track conditions, medications & allergies',
            icon: Icons.local_pharmacy_outlined,
            route: '/profile/pharmacy_information',
          ),
          ProfileItem(
            title: 'Pharmacy Verification',
            subtitle: 'Track conditions, medications & allergies',
            icon: Icons.verified_user_outlined,
            route: '/profile/pharmacy_verification',
          ),
        ],
      ),
      ProfileSection(
        title: 'General',
        items: [
          ProfileItem(
            title: 'Preferences',
            subtitle: 'Customize notifications & theme',
            icon: Icons.settings_outlined,
            route: '/profile/preferences',
          ),
          ProfileItem(
            title: 'Security',
            subtitle: 'Manage your passwords and verifications',
            icon: Icons.security_outlined,
            route: '/profile/security',
          ),
        ],
      ),
      ProfileSection(
        title: 'Support & Legal',
        items: [
          ProfileItem(
            title: 'Help centre',
            subtitle: 'Find answers or contact support',
            icon: Icons.help_outline,
            route: '/profile/help',
          ),
          ProfileItem(
            title: 'Term and policy',
            subtitle: 'Read our legal agreements & privacy info',
            icon: Icons.policy_outlined,
            route: '/profile/terms',
          ),
        ],
      ),
      ProfileSection(
        title: 'Login',
        items: [
           ProfileItem(
            title: 'Switch Account',
            subtitle: 'Switch between accounts',
            icon: Icons.switch_account_outlined,
            route: '/auth/switch_account',
          ),
          ProfileItem(
            title: 'Logout',
            subtitle: 'Log out your account',
            icon: Icons.logout,
            route: '/auth/logout',
          ),
        ],
      ),
    ],
  );
});
