import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/providers/dispense_entry_provider.dart';

class RecordedBySection extends ConsumerWidget {
  const RecordedBySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final state = ref.watch(dispenseEntryProvider);
    final notifier = ref.read(dispenseEntryProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.neutral.buttonTextWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recorded by (Optional)',
            style: AppTextStyles.interP18M.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          Text(
            'If empty, current logged-in user will be used.',
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Title / Role',
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(AppIcons.stethoscope,
                    colorFilter:
                        ColorFilter.mode(theme.neutral.secondaryText, BlendMode.srcIn)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.neutral.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.neutral.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.pharmacist.bg, width: 2),
              ),
              hintText: 'Pharmacist, Staff',
              hintStyle: AppTextStyles.interP14R.copyWith(color: theme.neutral.secondaryText),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
            value: state.recordedByRole.isEmpty ? 'Pharmacist' : state.recordedByRole,
            items: <String>['Pharmacist', 'Staff', 'Admin']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                notifier.updateRecordedBy(state.recordedByName, newValue);
              }
            },
            style: AppTextStyles.interP14R.copyWith(color: theme.neutral.primaryText),
            icon: Icon(Icons.keyboard_arrow_down, color: theme.neutral.secondaryText),
          ),
          const SizedBox(height: 16),
          Text(
            'Name',
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: state.recordedByName,
            onChanged: (value) {
              notifier.updateRecordedBy(value, state.recordedByRole);
            },
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(AppIcons.stethoscope,
                    colorFilter:
                        ColorFilter.mode(theme.neutral.secondaryText, BlendMode.srcIn)),
              ),
              hintText: 'Leave empty for current user',
              hintStyle: AppTextStyles.interP14R.copyWith(color: theme.neutral.secondaryText),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
            style: AppTextStyles.interP14R.copyWith(color: theme.neutral.primaryText),
          ),
        ],
      ),
    );
  }
}
