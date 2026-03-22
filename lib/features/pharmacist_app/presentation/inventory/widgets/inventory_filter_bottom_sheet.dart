import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';

class InventoryFilterBottomSheet extends ConsumerStatefulWidget {
  const InventoryFilterBottomSheet({super.key});

  @override
  ConsumerState<InventoryFilterBottomSheet> createState() => _InventoryFilterBottomSheetState();
}

class _InventoryFilterBottomSheetState extends ConsumerState<InventoryFilterBottomSheet> {
  late InventoryFilterState _currentFilter;

  @override
  void initState() {
    super.initState();
    _currentFilter = ref.read(inventoryProvider).advancedFilter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return Container(
      padding: EdgeInsets.all(context.figmaWidth(16)),
      decoration: BoxDecoration(
        color: theme.neutral.buttonTextWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.figmaWidth(20))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const Divider(),
          SizedBox(height: context.figmaHeight(16)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMedicationTypeSection(theme),
                  SizedBox(height: context.figmaHeight(24)),
                  _buildCategoriesSection(theme),
                  SizedBox(height: context.figmaHeight(24)),
                  _buildExpiryWindowSection(theme),
                  SizedBox(height: context.figmaHeight(24)),
                  _buildDosageFormSection(theme),
                  SizedBox(height: context.figmaHeight(32)),
                ],
              ),
            ),
          ),
          KElevatedButton(
            onPressed: () {
              ref.read(inventoryProvider.notifier).applyAdvancedFilter(_currentFilter);
              Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
          SizedBox(height: context.figmaHeight(16)),
        ],
      ),
    );
  }

  Widget _buildHeader(AppColorsTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        Text(
          'Filters',
          style: AppTextStyles.interP18M.copyWith(color: theme.neutral.primaryText),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _currentFilter = InventoryFilterState();
            });
          },
          child: Text(
            'Reset',
            style: AppTextStyles.interP14M.copyWith(color: theme.support.red),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationTypeSection(AppColorsTheme theme) {
    final types = ['All', 'Brand', 'Generic'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Medication Type', style: AppTextStyles.interP16M),
        ...types.map((type) => CheckboxListTile(
              title: Text(type, style: AppTextStyles.interP14R),
              value: _currentFilter.medicationTypes.contains(type),
              onChanged: (val) {
                setState(() {
                  final newTypes = List<String>.from(_currentFilter.medicationTypes);
                  if (val == true) {
                    newTypes.add(type);
                  } else {
                    newTypes.remove(type);
                  }
                  _currentFilter = _currentFilter.copyWith(medicationTypes: newTypes);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: theme.pharmacist.bg,
            )),
      ],
    );
  }

  Widget _buildCategoriesSection(AppColorsTheme theme) {
    final categories = ['Respiratory & Allergy', 'Pain Relief', 'Cold & Flu', 'First Aid', 'Pediatric Care', 'Dermatology & Skin Care', 'Antibiotics (Antibacterials)', 'Vitamins & Supplements', 'Others'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: AppTextStyles.interP16M),
        SizedBox(height: context.figmaHeight(12)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final isSelected = _currentFilter.categories.contains(cat);
            return FilterChip(
              label: Text(cat, style: AppTextStyles.interP12R.copyWith(color: isSelected ? theme.neutral.buttonTextWhite : theme.neutral.secondaryText)),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  final newCats = List<String>.from(_currentFilter.categories);
                  if (val) {
                    newCats.add(cat);
                  } else {
                    newCats.remove(cat);
                  }
                  _currentFilter = _currentFilter.copyWith(categories: newCats);
                });
              },
              selectedColor: theme.pharmacist.bg,
              backgroundColor: theme.neutral.bgTint,
              checkmarkColor: theme.neutral.buttonTextWhite,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExpiryWindowSection(AppColorsTheme theme) {
    final windows = ['Less than 7 days', 'Within 8-30 days', 'Within 30 days'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Expiry Window', style: AppTextStyles.interP16M),
        ...windows.map((w) => CheckboxListTile(
              title: Text(w, style: AppTextStyles.interP14R),
              value: _currentFilter.expiryWindows.contains(w),
              onChanged: (val) {
                setState(() {
                  final newWindows = List<String>.from(_currentFilter.expiryWindows);
                  if (val == true) {
                    newWindows.add(w);
                  } else {
                    newWindows.remove(w);
                  }
                  _currentFilter = _currentFilter.copyWith(expiryWindows: newWindows);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: theme.pharmacist.bg,
            )),
        SizedBox(height: context.figmaHeight(8)),
        Text('Custom Date', style: AppTextStyles.interP14M.copyWith(color: theme.neutral.secondaryText)),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 3650)),
            );
            if (date != null) {
              setState(() {
                _currentFilter = _currentFilter.copyWith(customDate: date);
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.neutral.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: theme.neutral.secondaryText),
                const SizedBox(width: 8),
                Text(
                  _currentFilter.customDate == null ? 'DD/MM/YY' : '${_currentFilter.customDate!.day}/${_currentFilter.customDate!.month}/${_currentFilter.customDate!.year}',
                  style: AppTextStyles.interP14R.copyWith(color: theme.neutral.secondaryText),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDosageFormSection(AppColorsTheme theme) {
    final forms = ['Tablet', 'Liquid', 'Capsule', 'Inhaler', 'Cream', 'Others'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dosage Form', style: AppTextStyles.interP16M),
        SizedBox(height: context.figmaHeight(12)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: forms.map((form) {
            final isSelected = _currentFilter.dosageForms.contains(form);
            return FilterChip(
              label: Text(form, style: AppTextStyles.interP12R.copyWith(color: isSelected ? theme.neutral.buttonTextWhite : theme.neutral.secondaryText)),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  final newForms = List<String>.from(_currentFilter.dosageForms);
                  if (val) {
                    newForms.add(form);
                  } else {
                    newForms.remove(form);
                  }
                  _currentFilter = _currentFilter.copyWith(dosageForms: newForms);
                });
              },
              selectedColor: theme.pharmacist.bg,
              backgroundColor: theme.neutral.bgTint,
              checkmarkColor: theme.neutral.buttonTextWhite,
            );
          }).toList(),
        ),
      ],
    );
  }
}
