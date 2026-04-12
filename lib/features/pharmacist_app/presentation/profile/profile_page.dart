import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/domain/pharmacist_profile.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/providers/profile_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/widgets/profile_list_item.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.neutral.bgTint,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            backgroundColor: colors.pharmacist.bg,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context, profile, colors),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final section = profile.sections[index];
              return _buildSection(context, section, colors, ref);
            }, childCount: profile.sections.length),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    PharmacistProfile profile,
    AppColorsTheme colors,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: profile.avatarUrl.isNotEmpty
              ? NetworkImage(profile.avatarUrl)
              : null,
          backgroundColor: colors.neutral.bgTint,
          child: profile.avatarUrl.isEmpty
              ? Icon(
                  Icons.person,
                  size: 50,
                  color: colors.pharmacist.bg,
                )
              : null,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profile.name,
              style: AppTextStyles.interP24R.copyWith(color: Colors.white),
            ),
            if (profile.isVerified) ...[
              const SizedBox(width: 8),
              const Icon(Icons.verified, color: Colors.white, size: 20),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Verified',
          style: AppTextStyles.interP14R.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    ProfileSection section,
    AppColorsTheme colors,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: AppTextStyles.interP16Sm.copyWith(
              color: colors.neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          ...section.items.map((item) => ProfileListItem(
                item: item,
                onTap: () {
                  if (item.title == 'Switch Account') {
                    _showSwitchAccountOverlay(context, colors);
                  } else if (item.title == 'Logout') {
                    _showLogoutOverlay(context, colors, ref);
                  } else {
                    context.push(item.route);
                  }
                },
              )),
        ],
      ),
    );
  }

  void _showSwitchAccountOverlay(BuildContext context, AppColorsTheme colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Switch account',
                style: AppTextStyles.interP18M.copyWith(color: colors.neutral.primaryText),
              ),
              const SizedBox(height: 24),
              _buildAccountTile(
                'Muneer Sani',
                'https://via.placeholder.com/150', // Placeholder
                false,
                colors,
              ),
              _buildAccountTile(
                'Pharmacist Muneer',
                'https://via.placeholder.com/150', // Placeholder
                true,
                colors,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.neutral.bgTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 24),
                ),
                title: Text('Add account', style: AppTextStyles.interP16M),
                onTap: () {
                  // TODO: Implement add account
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccountTile(String name, String avatarUrl, bool isSelected, AppColorsTheme colors) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: Text(name, style: AppTextStyles.interP16M),
      trailing: isSelected ? Icon(Icons.check, color: colors.support.green) : null,
      onTap: () {
        // TODO: Implement switch logic
      },
    );
  }

  void _showLogoutOverlay(BuildContext context, AppColorsTheme colors, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              'Are you sure you want to log out?',
              style: AppTextStyles.interP16M.copyWith(color: colors.neutral.secondaryText),
            ),
            const SizedBox(height: 24),
            ListTile(
              title: Center(
                child: Text(
                  'Switch account',
                  style: AppTextStyles.interP18M.copyWith(color: colors.neutral.primaryText),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showSwitchAccountOverlay(context, colors);
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: Center(
                child: Text(
                  'Log Out',
                  style: AppTextStyles.interP18M.copyWith(color: colors.support.red),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLogoutConfirmation(context, colors, ref);
              },
            ),
            Container(
              height: 8,
              color: Colors.black, // Dark separator line from image
            ),
            ListTile(
              title: Center(
                child: Text(
                  'Cancel',
                  style: AppTextStyles.interP18M.copyWith(color: colors.neutral.primaryText),
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context, AppColorsTheme colors, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Center(
            child: Text(
              'Log out of your account?',
              textAlign: TextAlign.center,
              style: AppTextStyles.interP18M.copyWith(color: colors.neutral.primaryText),
            ),
          ),
          actions: [
            Column(
              children: [
                const Divider(),
                TextButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).signOut();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Log Out',
                    style: AppTextStyles.interP16M.copyWith(color: colors.support.red),
                  ),
                ),
                const Divider(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.interP16M.copyWith(color: colors.neutral.primaryText),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
