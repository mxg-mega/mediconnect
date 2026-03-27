import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends ConsumerState<NotificationSettingsPage> {
  bool _lowStock = true;
  bool _expiringMed = true;
  bool _reviewUpdates = true;
  bool _appUpdates = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return AppScaffold(
      title: const Text('Notification'),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          children: [
            _buildNotificationToggle(
              'Low stock alerts',
              'Receive notifications when a medication is running low',
              _lowStock,
              (val) => setState(() => _lowStock = val),
              theme,
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildNotificationToggle(
              'Expiring medication reminders',
              'Receive notifications when a medication is about to expire',
              _expiringMed,
              (val) => setState(() => _expiringMed = val),
              theme,
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildNotificationToggle(
              'Review Updates',
              'Receive notifications when someone comments or drops a review',
              _reviewUpdates,
              (val) => setState(() => _reviewUpdates = val),
              theme,
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildNotificationToggle(
              'App updates',
              'Receive notifications about new features and updates',
              _appUpdates,
              (val) => setState(() => _appUpdates = val),
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
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
