import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/medication.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/providers/dispense_entry_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/dispense_entry/widgets/quantity_stepper.dart';

class SelectedMedicationCard extends ConsumerStatefulWidget {
  const SelectedMedicationCard({
    super.key,
    required this.medication,
  });

  final Medication medication;

  @override
  ConsumerState<SelectedMedicationCard> createState() => _SelectedMedicationCardState();
}

class _SelectedMedicationCardState extends ConsumerState<SelectedMedicationCard> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(widget.medication.imageUrl ?? 'assets/images/amoxicillin_gsk.png', width: 50, height: 50),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.medication.name,
                        style: AppTextStyles.interP16M.copyWith(
                          color: theme.neutral.primaryText,
                        ),
                      ),
                      Text(
                        '${widget.medication.manufacturer} • ${widget.medication.brand}',
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
                    ref.read(dispenseEntryProvider.notifier).removeMedication(widget.medication);
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
                    Text('${widget.medication.stock} units', style: AppTextStyles.interP14M.copyWith(color: theme.neutral.primaryText)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pack Size:', style: AppTextStyles.interP12R.copyWith(color: theme.neutral.secondaryText)),
                    Text(widget.medication.packSize, style: AppTextStyles.interP14M.copyWith(color: theme.neutral.primaryText)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price / unit', style: AppTextStyles.interP12R.copyWith(color: theme.neutral.secondaryText)),
                    Text('₦${widget.medication.price}', style: AppTextStyles.interP14M.copyWith(color: theme.neutral.primaryText)),
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
                    setState(() {
                      quantity++;
                    });
                  },
                  onDecrement: () {
                    setState(() {
                      if (quantity > 1) quantity--;
                    });
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total', style: AppTextStyles.interP12R.copyWith(color: theme.neutral.secondaryText)),
                    Text('₦${(quantity * widget.medication.price)}', style: AppTextStyles.interP14M.copyWith(color: theme.pharmacist.bg)),
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
