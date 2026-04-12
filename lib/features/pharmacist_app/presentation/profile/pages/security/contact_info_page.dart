import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';

class ContactInfoPage extends ConsumerWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final user = ref.watch(currentUserProvider);

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text(''),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact information',
              style: AppTextStyles.interP18M.copyWith(color: theme.neutral.primaryText),
            ),
            SizedBox(height: context.figmaHeight(8)),
            Text(
              'Manage your email addresses to make sure that your contact info is accurate and up to date.',
              style: AppTextStyles.interP14R.copyWith(color: theme.neutral.secondaryText),
            ),
            SizedBox(height: context.figmaHeight(32)),
            _buildContactItem(
              context,
              'Email',
              user?.email ?? 'Muneer.sani@gmail.com',
              AppRoutes.pharmacistAddEmail,
              theme,
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildContactItem(
              context,
              'Mobile Number',
              user?.phoneNumber ?? '08020345698',
              AppRoutes.pharmacistAddPhone,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    String label,
    String value,
    String route,
    AppColorsTheme theme,
  ) {
    return InkWell(
      onTap: () => context.push(route),
      child: Container(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        decoration: BoxDecoration(
          color: theme.neutral.buttonTextWhite,
          borderRadius: BorderRadius.circular(context.figmaWidth(12)),
          border: Border.all(color: theme.neutral.border.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.interP12R.copyWith(color: theme.neutral.tertiaryText),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.interP16M.copyWith(color: theme.neutral.primaryText),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: theme.neutral.secondaryText),
          ],
        ),
      ),
    );
  }
}
