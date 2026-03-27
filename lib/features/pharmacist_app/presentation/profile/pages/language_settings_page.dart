import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class LanguageSettingsPage extends ConsumerStatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  ConsumerState<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends ConsumerState<LanguageSettingsPage> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return AppScaffold(
      title: const Text('Language'),
      body: Padding(
        padding: EdgeInsets.all(context.figmaWidth(16)),
        child: Column(
          children: [
            _buildLanguageOption('English', 'English', theme),
            _buildLanguageOption('Hausa', 'Harshen Hausa', theme),
            _buildLanguageOption('Yoruba', 'Èdè Yorùbá', theme),
            _buildLanguageOption('Igbo', 'Asụsụ Igbo', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String label, String subtitle, AppColorsTheme theme) {
    final isSelected = _selectedLanguage == label;
    return InkWell(
      onTap: () => setState(() => _selectedLanguage = label),
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
