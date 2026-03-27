import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:go_router/go_router.dart';

class PreferencesPage extends ConsumerWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);

    return AppScaffold(
      title: const Text('Preferences'),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          children: [
            _buildPreferenceItem(
              context,
              'Notification',
              Icons.notifications_none_outlined,
              AppRoutes.pharmacistNotificationSettings,
              theme,
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildPreferenceItem(
              context,
              'Display',
              Icons.wb_sunny_outlined,
              AppRoutes.pharmacistDisplaySettings,
              theme,
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildPreferenceItem(
              context,
              'Language',
              Icons.language_outlined,
              AppRoutes.pharmacistLanguageSettings,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(
    BuildContext context,
    String title,
    IconData icon,
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
            Icon(icon, color: theme.neutral.primaryText),
            SizedBox(width: context.figmaWidth(16)),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.interP16M.copyWith(color: theme.neutral.primaryText),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: theme.neutral.secondaryText),
          ],
        ),
      ),
    );
  }
}
