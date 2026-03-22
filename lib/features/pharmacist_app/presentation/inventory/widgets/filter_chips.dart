import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';

class InventoryFilterChips extends ConsumerWidget {
  const InventoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(inventoryProvider.select((s) => s.quickFilterStatus));
    final colors = AppTheme.colors(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildChip(context, ref, 'All', null, selectedFilter, colors),
          _buildChip(
            context,
            ref,
            'In-stock',
            StockStatus.inStock,
            selectedFilter,
            colors,
          ),
          _buildChip(
            context,
            ref,
            'Low-Stock',
            StockStatus.lowStock,
            selectedFilter,
            colors,
          ),
          _buildChip(
            context,
            ref,
            'Out of Stock',
            StockStatus.outOfStock,
            selectedFilter,
            colors,
          ),
          _buildChip(
            context,
            ref,
            'Expiring Soon',
            StockStatus.expiringSoon,
            selectedFilter,
            colors,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    StockStatus? status,
    StockStatus? selectedFilter,
    AppColorsTheme colors,
  ) {
    final isSelected = status == selectedFilter;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          ref.read(inventoryProvider.notifier).updateQuickFilter(status);
        },
        backgroundColor: colors.neutral.bgTint,
        selectedColor: colors.pharmacist.bg,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : colors.neutral.secondaryText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? colors.pharmacist.bg : colors.neutral.border.withOpacity(0.2),
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}
