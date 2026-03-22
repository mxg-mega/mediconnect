import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
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
          return colors.support.red;
        case StockStatus.outOfStock:
          return colors.neutral.secondaryText;
        case StockStatus.expiringSoon:
          return colors.support.orange;
      }
    }

    return GestureDetector(
      onTap: () => context.push(AppRoutes.pharmacistInventoryItem, extra: item),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: context.figmaWidth(16), vertical: context.figmaHeight(8)),
        padding: EdgeInsets.all(context.figmaWidth(16)),
        decoration: BoxDecoration(
          color: colors.neutral.buttonTextWhite,
          borderRadius: BorderRadius.circular(context.figmaWidth(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  SizedBox(height: context.figmaHeight(4)),
                  Text(
                    item.medicationName,
                    style: AppTextStyles.interP16M.copyWith(color: colors.neutral.primaryText),
                  ),
                  SizedBox(height: context.figmaHeight(2)),
                  Text(
                    '${item.brandName} • ${item.form}',
                    style: AppTextStyles.interP12R.copyWith(
                      color: colors.neutral.tertiaryText,
                    ),
                  ),
                  SizedBox(height: context.figmaHeight(12)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: context.figmaWidth(12), vertical: context.figmaHeight(4)),
                    decoration: BoxDecoration(
                      color: colors.neutral.bgTint,
                      borderRadius: BorderRadius.circular(context.figmaWidth(20)),
                    ),
                    child: Text(
                      'Qty: ${item.quantityInStock}',
                      style: AppTextStyles.interP12M.copyWith(color: colors.neutral.primaryText),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.figmaWidth(16)),
            ClipRRect(
              borderRadius: BorderRadius.circular(context.figmaWidth(8)),
              child: Image.asset(
                item.imageUrl ?? 'assets/images/amoxicillin_gsk.png',
                width: context.figmaWidth(100),
                height: context.figmaHeight(80),
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
