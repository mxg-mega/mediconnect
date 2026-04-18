import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/core/providers/settings_provider.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return AppScaffold(
      title: const Text('Language'),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          children: [
            _buildLanguageOption(context, 'English', 'English', settings.languageCode, theme, notifier),
            _buildLanguageOption(context, 'Hausa', 'Harshen Hausa', settings.languageCode, theme, notifier),
            _buildLanguageOption(context, 'Yoruba', 'Èdè Yorùbá', settings.languageCode, theme, notifier),
            _buildLanguageOption(context, 'Igbo', 'Asụsụ Igbo', settings.languageCode, theme, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label, 
    String subtitle, 
    String currentCode, 
    AppColorsTheme theme,
    SettingsNotifier notifier,
  ) {
    final isSelected = currentCode == label;
    return InkWell(
      onTap: () => notifier.updateLanguage(label),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.figmaHeight(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.interP16M.copyWith(color: theme.neutral.primaryText),
                ),
                SizedBox(height: context.figmaHeight(4)),
                Text(
                  subtitle,
                  style: AppTextStyles.interP14R.copyWith(color: theme.neutral.tertiaryText),
                ),
              ],
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
