import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedDuration = 'Custom';

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.figmaWidth(20),
        vertical: context.figmaHeight(20),
      ),
      decoration: BoxDecoration(
        color: theme.neutral.bgTint,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.figmaWidth(20)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter',
                style: AppTextStyles.interP18M.copyWith(
                  color: theme.neutral.primaryText,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.interP14R.copyWith(
                    color: theme.neutral.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          SizedBox(height: context.figmaHeight(20)),
          Text(
            'Duration',
            style: AppTextStyles.interP16M.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          SizedBox(height: context.figmaHeight(12)),
          Row(
            children: [
              _DurationButton(
                label: 'Last 3 months',
                isSelected: selectedDuration == 'Last 3 months',
                onTap: () => setState(() => selectedDuration = 'Last 3 months'),
              ),
              SizedBox(width: context.figmaWidth(12)),
              _DurationButton(
                label: 'Last 6 months',
                isSelected: selectedDuration == 'Last 6 months',
                onTap: () => setState(() => selectedDuration = 'Last 6 months'),
              ),
              SizedBox(width: context.figmaWidth(12)),
              _DurationButton(
                label: 'Custom',
                isSelected: selectedDuration == 'Custom',
                onTap: () => setState(() => selectedDuration = 'Custom'),
              ),
            ],
          ),
          SizedBox(height: context.figmaHeight(24)),
          Text(
            'Start Date',
            style: AppTextStyles.interP16M.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          SizedBox(height: context.figmaHeight(8)),
          _DateField(hintText: 'DD/MM/YY'),
          SizedBox(height: context.figmaHeight(20)),
          Text(
            'End Date',
            style: AppTextStyles.interP16M.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          SizedBox(height: context.figmaHeight(8)),
          _DateField(hintText: 'DD/MM/YY'),
          SizedBox(height: context.figmaHeight(40)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle confirm
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.pharmacist.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.figmaWidth(8)),
                ),
              ),
              child: Text(
                'Confirm',
                style: AppTextStyles.interP16M.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: context.figmaHeight(20)),
        ],
      ),
    );
  }
}

class _DurationButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.figmaWidth(16),
          vertical: context.figmaHeight(10),
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.pharmacist.bg : theme.pharmacist.bgTint,
          borderRadius: BorderRadius.circular(context.figmaWidth(20)),
          border: isSelected
              ? null
              : Border.all(color: theme.pharmacist.border.withOpacity(0.1)),
        ),
        child: Text(
          label,
          style: AppTextStyles.interP14R.copyWith(
            color: isSelected ? Colors.white : theme.pharmacist.bg,
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String hintText;

  const _DateField({required this.hintText});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.figmaWidth(12),
        vertical: context.figmaHeight(14),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.figmaWidth(8)),
        border: Border.all(color: theme.neutral.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.calendar,
            width: 20,
            colorFilter: ColorFilter.mode(
              theme.neutral.secondaryText,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: context.figmaWidth(12)),
          Text(
            hintText,
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.secondaryText.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
