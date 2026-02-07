import 'package:flutter/material.dart';
import 'package:mediconnect/common/widgets/k_navigate.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/profile/domain/pharmacist_profile.dart';

class ProfileListItem extends StatelessWidget {
  const ProfileListItem({super.key, required this.item});

  final ProfileItem item;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(item.icon, color: colors.pharmacist.bg),
        title: Text(item.title, style: AppTextStyles.interP16M),
        subtitle: Text(item.subtitle, style: AppTextStyles.interP14R),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => navigateTo(context, item.route),
      ),
    );
  }
}
