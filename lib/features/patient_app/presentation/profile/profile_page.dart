import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/constants/assets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    
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
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Muneer Sani',
                    style: AppTextStyles.interP24R.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                children: [
                  _buildSection(context, 'Account', [
                    _buildProfileItem(
                      context,
                      icon: AppIcons.profile,
                      title: 'Personal Details',
                      subtitle: 'View or edit your name & contact info',
                    ),
                    _buildProfileItem(
                      context,
                      icon: AppIcons.file,
                      title: 'Medical History',
                      subtitle: 'Track conditions, medications & allergies',
                    ),
                  ]),
                  
                  _buildSection(context, 'General', [
                    _buildProfileItem(
                      context,
                      icon: AppIcons.filter, // Using as placeholder for Preferences
                      title: 'Preferences',
                      subtitle: 'Customize notifications & theme',
                    ),
                    _buildProfileItem(
                      context,
                      icon: AppIcons.lock,
                      title: 'Security',
                      subtitle: 'Manage your passwords and verifications',
                    ),
                  ]),
                  
                  _buildSection(context, 'Support', [
                    _buildProfileItem(
                      context,
                      icon: AppIcons.info,
                      title: 'Help centre',
                      subtitle: 'Find answers or contact support',
                    ),
                    _buildProfileItem(
                      context,
                      icon: AppIcons.receipt,
                      title: 'Term and policy',
                      subtitle: 'Read our legal agreements & privacy info',
                    ),
                  ]),
                  
                  _buildSection(context, 'Login', [
                    _buildProfileItem(
                      context,
                      icon: AppIcons.export,
                      title: 'Switch account',
                      subtitle: 'Switch between accounts',
                    ),
                    _buildProfileItem(
                      context,
                      icon: AppIcons.export, // Using as logout
                      title: 'Logout',
                      subtitle: 'Log out your account',
                      isLogout: true,
                    ),
                  ]),
                ],
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
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    bool isLogout = false,
  }) {
    final colors = AppTheme.colors(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(colors.patient.bg, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.interP16M.copyWith(
                    color: isLogout ? colors.support.red : colors.neutral.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.interP12R.copyWith(color: colors.neutral.tertiaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
