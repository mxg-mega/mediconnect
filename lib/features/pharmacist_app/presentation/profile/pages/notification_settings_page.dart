import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/core/providers/settings_provider.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return AppScaffold(
      title: const Text('Notification'),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          children: [
            _buildNotificationToggle(
              context,
              'Low stock alerts',
              'Receive notifications when a medication is running low',
              settings.notifications['low_stock'] ?? true,
              (val) => notifier.updateNotification('low_stock', val),
              theme,
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildNotificationToggle(
              context,
              'Expiring medication reminders',
              'Receive notifications when a medication is about to expire',
              settings.notifications['expiry'] ?? true,
              (val) => notifier.updateNotification('expiry', val),
              theme,
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildNotificationToggle(
              context,
              'Review Updates',
              'Receive notifications when someone comments or drops a review',
              settings.notifications['reviews'] ?? true,
              (val) => notifier.updateNotification('reviews', val),
              theme,
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildNotificationToggle(
              context,
              'App updates',
              'Receive notifications about new features and updates',
              settings.notifications['app_updates'] ?? false,
              (val) => notifier.updateNotification('app_updates', val),
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    AppColorsTheme theme,
  ) {
    return Container(
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
                  title,
                  style: AppTextStyles.interP16M.copyWith(color: theme.neutral.primaryText),
                ),
                SizedBox(height: context.figmaHeight(4)),
                Text(
                  subtitle,
                  style: AppTextStyles.interP14R.copyWith(color: theme.neutral.tertiaryText),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: theme.pharmacist.bg,
          ),
        ],
      ),
    );
  }
}
