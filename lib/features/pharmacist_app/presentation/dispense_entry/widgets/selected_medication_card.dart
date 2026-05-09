import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/medication.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/providers/dispense_entry_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/widgets/quantity_stepper.dart';

class SelectedMedicationCard extends ConsumerWidget {
  const SelectedMedicationCard({
    super.key,
    required this.medication,
    required this.quantity,
  });

  final Medication medication;
  final int quantity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(medication.imageUrl ?? 'assets/images/amoxicillin_gsk.png', width: 50, height: 50),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: AppTextStyles.interP16M.copyWith(
                          color: theme.neutral.primaryText,
                        ),
                      ),
                      Text(
                        '${medication.manufacturer} • ${medication.brand}',
                        style: AppTextStyles.interP14R.copyWith(
                          color: theme.neutral.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(AppIcons.delete, colorFilter: ColorFilter.mode(theme.support.red, BlendMode.srcIn)),
                  onPressed: () {
                    ref.read(dispenseEntryProvider.notifier).removeMedication(medication);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stock:', style: AppTextStyles.interP12R.copyWith(color: theme.neutral.secondaryText)),
                    Text('${medication.stock} units', style: AppTextStyles.interP14M.copyWith(color: theme.neutral.primaryText)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pack Size:', style: AppTextStyles.interP12R.copyWith(color: theme.neutral.secondaryText)),
                    Text(medication.packSize, style: AppTextStyles.interP14M.copyWith(color: theme.neutral.primaryText)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price / unit', style: AppTextStyles.interP12R.copyWith(color: theme.neutral.secondaryText)),
                    Text('₦${medication.price}', style: AppTextStyles.interP14M.copyWith(color: theme.neutral.primaryText)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuantityStepper(
                  quantity: quantity,
                  onIncrement: () {
                    if (quantity < medication.stock) {
                      ref.read(dispenseEntryProvider.notifier).updateQuantity(medication, quantity + 1);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cannot exceed available stock.')),
                      );
                    }
                  },
                  onDecrement: () {
                    if (quantity > 1) {
                      ref.read(dispenseEntryProvider.notifier).updateQuantity(medication, quantity - 1);
                    }
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total', style: AppTextStyles.interP12R.copyWith(color: theme.neutral.secondaryText)),
                    Text('₦${(quantity * medication.price)}', style: AppTextStyles.interP14M.copyWith(color: theme.pharmacist.bg)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
