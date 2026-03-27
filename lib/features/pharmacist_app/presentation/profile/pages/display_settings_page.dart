import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class DisplaySettingsPage extends ConsumerStatefulWidget {
  const DisplaySettingsPage({super.key});

  @override
  ConsumerState<DisplaySettingsPage> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends ConsumerState<DisplaySettingsPage> {
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

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
            _buildThemeOption('System default', theme),
            _buildThemeOption('Light', theme),
            _buildThemeOption('Dark', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String label, AppColorsTheme theme) {
    final isSelected = _selectedTheme == label;
    return InkWell(
      onTap: () => setState(() => _selectedTheme = label),
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
