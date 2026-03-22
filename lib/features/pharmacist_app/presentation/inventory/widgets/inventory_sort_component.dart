import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';

class InventorySortComponent extends ConsumerWidget {
  final VoidCallback? onSelected;
  const InventorySortComponent({super.key, this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);
    final sortBy = ref.watch(inventoryProvider.select((s) => s.sortBy));
    final notifier = ref.read(inventoryProvider.notifier);

    return Container(
      width: context.figmaWidth(150),
      padding: EdgeInsets.symmetric(vertical: context.figmaHeight(8)),
      decoration: BoxDecoration(
        color: theme.neutral.buttonTextWhite,
        borderRadius: BorderRadius.circular(context.figmaWidth(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSortItem(context, 'Name', InventorySort.name, sortBy == InventorySort.name, theme, notifier),
          _buildSortItem(context, 'Date', InventorySort.date, sortBy == InventorySort.date, theme, notifier),
          _buildSortItem(context, 'Quantity', InventorySort.quantity, sortBy == InventorySort.quantity, theme, notifier),
          _buildSortItem(context, 'Expiry', InventorySort.expiry, sortBy == InventorySort.expiry, theme, notifier),
        ],
      ),
    );
  }

  Widget _buildSortItem(
    BuildContext context,
    String label,
    InventorySort value,
    bool isSelected,
    AppColorsTheme theme,
    InventoryNotifier notifier,
  ) {
    return InkWell(
      onTap: () {
        notifier.updateSort(value);
        onSelected?.call();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.figmaWidth(16),
          vertical: context.figmaHeight(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.interP14M.copyWith(
                color: isSelected ? theme.pharmacist.bg : theme.neutral.primaryText,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: 18,
                color: theme.pharmacist.bg,
              ),
          ],
        ),
      ),
    );
  }
}
