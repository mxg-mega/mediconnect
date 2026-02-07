import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class RecordedBySection extends StatefulWidget {
  const RecordedBySection({super.key});

  @override
  State<RecordedBySection> createState() => _RecordedBySectionState();
}

class _RecordedBySectionState extends State<RecordedBySection> {
  String? selectedRole;
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
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
            'Recorded by',
            style: AppTextStyles.interP18M.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          Text(
            'Recorded time will be set on save (server time)',
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Title / Role *',
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
            value: selectedRole,
            items: <String>['Pharmacist', 'Staff', 'Admin']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedRole = newValue;
              });
            },
            style: AppTextStyles.interP14R.copyWith(color: theme.neutral.primaryText),
            icon: Icon(Icons.keyboard_arrow_down, color: theme.neutral.secondaryText),
          ),
          const SizedBox(height: 16),
          Text(
            'Name *',
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(AppIcons.stethoscope,
                    colorFilter:
                        ColorFilter.mode(theme.neutral.secondaryText, BlendMode.srcIn)),
              ),
              hintText: 'Yusuf A.',
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
