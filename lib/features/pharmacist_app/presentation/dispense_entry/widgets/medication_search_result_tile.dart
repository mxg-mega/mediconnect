import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/medication.dart';

class MedicationSearchResultTile extends StatelessWidget {
  const MedicationSearchResultTile({
    super.key,
    required this.medication,
    required this.onTap,
  });

  final Medication medication;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    return ListTile(
      onTap: onTap,
      leading: Image.asset(medication.imageUrl ?? 'assets/images/amoxicillin_gsk.png'),
      title: Text(
        medication.name,
        style: AppTextStyles.interP16M.copyWith(
          color: theme.neutral.primaryText,
        ),
      ),
      subtitle: Text(
        '${medication.manufacturer} • ${medication.stock} units',
        style: AppTextStyles.interP14R.copyWith(
          color: theme.neutral.secondaryText,
        ),
      ),
    );
  }
}
