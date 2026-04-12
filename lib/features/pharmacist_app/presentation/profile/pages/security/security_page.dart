import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:go_router/go_router.dart';

class SecurityPage extends ConsumerWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);

    return AppScaffold(
      removeBodyPadding: true,
      onBack: () => context.push(AppRoutes.pharmacistProfile),
      title: const Text('Security'),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityItem(
              context,
              'Change Password',
              Icons.lock_outline,
              AppRoutes.pharmacistChangePassword,
              theme,
            ),
            SizedBox(height: context.figmaHeight(24)),
            Text(
              'Contact Info',
              style: AppTextStyles.interP16M.copyWith(
                color: theme.neutral.primaryText,
              ),
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildSecurityItem(
              context,
              'Contact Info',
              null,
              AppRoutes.pharmacistContactInfo,
              theme,
              subtitle: 'Muneer.sani@gmail.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityItem(
    BuildContext context,
    String title,
    IconData? icon,
    String route,
    AppColorsTheme theme, {
    String? subtitle,
  }) {
    return InkWell(
      onTap: () => context.push(route),
      child: Container(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        decoration: BoxDecoration(
          color: theme.neutral.buttonTextWhite,
          borderRadius: BorderRadius.circular(context.figmaWidth(12)),
          border: Border.all(
            color: theme.neutral.border.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: theme.neutral.primaryText),
              SizedBox(width: context.figmaWidth(16)),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (subtitle != null)
                    Text(
                      title,
                      style: AppTextStyles.interP12R.copyWith(
                        color: theme.neutral.tertiaryText,
                      ),
                    ),
                  Text(
                    subtitle ?? title,
                    style: AppTextStyles.interP16M.copyWith(
                      color: theme.neutral.primaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.neutral.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
