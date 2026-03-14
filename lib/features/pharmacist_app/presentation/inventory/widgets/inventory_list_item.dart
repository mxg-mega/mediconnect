import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';

class InventoryListItem extends StatelessWidget {
  const InventoryListItem({
    super.key,
    required this.item,
  });

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    Color getStatusColor(StockStatus status) {
      switch (status) {
        case StockStatus.inStock:
          return colors.support.green;
        case StockStatus.lowStock:
          return colors.support.orange;
        case StockStatus.outOfStock:
          return colors.support.red;
        case StockStatus.expiringSoon:
          return colors.support.orange;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                item.imageUrl ?? 'assets/images/metformin_merck.png', // Placeholder
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.stockStatus.displayName,
                    style: AppTextStyles.interP12M.copyWith(
                      color: getStatusColor(item.stockStatus),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.medicationName,
                    style: AppTextStyles.interP16Sm,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.brandName} • ${item.form}',
                    style: AppTextStyles.interP14R.copyWith(
                      color: colors.neutral.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Qty: ${item.quantityInStock}',
                  style: AppTextStyles.interP14M.copyWith(
                    color: colors.neutral.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
