import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/features/patient_app/presentation/profile/domain/patient_profile.dart';
import 'package:mediconnect/features/patient_app/presentation/profile/providers/profile_provider.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';

class PatientProfilePage extends ConsumerWidget {
  const PatientProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppTheme.colors(context);
    final profile = ref.watch(patientProfileProvider);
    
    return Scaffold(
      backgroundColor: colors.patient.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              width: double.infinity,
              child: Column(
                children: [
                  if (profile.avatarUrl.isNotEmpty)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profile.avatarUrl),
                      backgroundColor: Colors.white24,
                    )
                  else
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    style: AppTextStyles.interP24R.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (profile.isVerified)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verified',
                          style: AppTextStyles.interP14M.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          AppIcons.approved_badge,
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(Colors.greenAccent, BlendMode.srcIn),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Unverified Account',
                          style: AppTextStyles.interP14M.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            
            // Content
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.neutral.bgTint,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: profile.sections.map((section) {
                  return _buildSection(
                    context, 
                    section.title, 
                    section.items.map((item) {
                      return _buildProfileItem(
                        context,
                        ref,
                        item: item,
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    final colors = AppTheme.colors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.interP18M.copyWith(color: colors.neutral.primaryText),
        ),
        const SizedBox(height: 16),
        ...items,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProfileItem(
    BuildContext context, 
    WidgetRef ref, {
    required ProfileItem item,
  }) {
    final colors = AppTheme.colors(context);
    
    return InkWell(
      onTap: () {
        if (item.isLogout) {
          ref.read(authProvider.notifier).signOut();
        } else if (item.route.isNotEmpty) {
          // TODO: Ensure GoRouter has these routes defined
          context.push(item.route);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.patient.bgTint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                item.icon,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  item.isLogout ? colors.support.red : colors.patient.bg, 
                  BlendMode.srcIn
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.interP16M.copyWith(
                      color: item.isLogout ? colors.support.red : colors.neutral.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: AppTextStyles.interP12R.copyWith(color: colors.neutral.tertiaryText),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colors.neutral.tertiaryText,
            ),
          ],
        ),
      ),
    );
  }
}
