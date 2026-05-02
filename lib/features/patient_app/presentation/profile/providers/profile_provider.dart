import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/features/patient_app/presentation/profile/domain/patient_profile.dart';

final patientProfileProvider = Provider<PatientProfile>((ref) {
  final user = ref.watch(currentUserProvider);

  return PatientProfile(
    name: user?.fullName ?? 'Patient',
    isVerified: user?.isVerified ?? false,
    avatarUrl: user?.profileImageUrl ?? '',
    sections: [
      ProfileSection(
        title: 'Account',
        items: [
          ProfileItem(
            title: 'Personal Details',
            subtitle: 'View or edit your name & contact info',
            icon: AppIcons.profile,
            route: '/patient/profile/details', // Placeholder route
          ),
          ProfileItem(
            title: 'Medical History',
            subtitle: 'Track conditions, medications & allergies',
            icon: AppIcons.file,
            route: '/patient/profile/medical-history', // Placeholder route
          ),
        ],
      ),
      ProfileSection(
        title: 'General',
        items: [
          ProfileItem(
            title: 'Preferences',
            subtitle: 'Customize notifications & theme',
            icon: AppIcons.filter, // Adjust if a more suitable icon exists
            route: '/patient/profile/preferences',
          ),
          ProfileItem(
            title: 'Security',
            subtitle: 'Manage your passwords and verifications',
            icon: AppIcons.lock,
            route: '/patient/profile/security',
          ),
        ],
      ),
      ProfileSection(
        title: 'Support',
        items: [
          ProfileItem(
            title: 'Help centre',
            subtitle: 'Find answers or contact support',
            icon: AppIcons.info,
            route: '/profile/help', // Shared route?
          ),
          ProfileItem(
            title: 'Term and policy',
            subtitle: 'Read our legal agreements & privacy info',
            icon: AppIcons.receipt,
            route: '/profile/terms', // Shared route?
          ),
        ],
      ),
      ProfileSection(
        title: 'Login',
        items: [
          ProfileItem(
            title: 'Switch account',
            subtitle: 'Switch between accounts',
            icon: AppIcons.export,
            route: '/auth/switch_account',
          ),
          ProfileItem(
            title: 'Logout',
            subtitle: 'Log out your account',
            icon: AppIcons.export, // Consider a different logout icon if available
            route: '/auth/logout',
            isLogout: true,
          ),
        ],
      ),
    ],
  );
});
