import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

final selectedFilterProvider = StateProvider<StockStatus?>((ref) => null);

class InventoryFilterChips extends ConsumerWidget {
  const InventoryFilterChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedFilterProvider);
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
            'Low-stock',
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
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) {
            ref.read(selectedFilterProvider.notifier).state = status;
            ref.read(inventoryProvider.notifier).filterByStatus(status);
          }
        },
        backgroundColor: isSelected
            ? colors.patient.bg.withOpacity(0.1)
            : colors.neutral.bg00,
        selectedColor: colors.patient.bg.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? colors.patient.bg : colors.neutral.primaryText,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? colors.patient.bg : colors.neutral.border,
          ),
        ),
      ),
    );
  }
}
