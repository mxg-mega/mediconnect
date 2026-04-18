import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/core/providers/settings_provider.dart';

class DisplaySettingsPage extends ConsumerWidget {
  const DisplaySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return AppScaffold(
      title: const Text('Display'),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: AppTextStyles.interP16Sm.copyWith(color: theme.neutral.secondaryText),
            ),
            SizedBox(height: context.figmaHeight(16)),
            _buildThemeOption(context, 'System default', ThemeMode.system, settings.themeMode, theme, notifier),
            _buildThemeOption(context, 'Light', ThemeMode.light, settings.themeMode, theme, notifier),
            _buildThemeOption(context, 'Dark', ThemeMode.dark, settings.themeMode, theme, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label, 
    ThemeMode mode, 
    ThemeMode currentMode, 
    AppColorsTheme theme,
    SettingsNotifier notifier,
  ) {
    final isSelected = mode == currentMode;
    return InkWell(
      onTap: () => notifier.updateThemeMode(mode),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.figmaHeight(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.interP16M.copyWith(color: theme.neutral.primaryText),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.pharmacist.bg : theme.neutral.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.pharmacist.bg,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
