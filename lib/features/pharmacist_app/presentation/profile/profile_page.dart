import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/k_navigate.dart';
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
              return _buildSection(context, section, colors);
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
          backgroundImage: NetworkImage(profile.avatarUrl, ),
          backgroundColor: colors.pharmacist.bg,
          child: const Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ),
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
          ...section.items.map((item) => ProfileListItem(item: item)),
        ],
      ),
    );
  }
}
