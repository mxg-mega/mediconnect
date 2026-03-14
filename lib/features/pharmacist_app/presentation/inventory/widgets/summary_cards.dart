import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';

class InventorySummaryCards extends ConsumerWidget {
  const InventorySummaryCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider);

    final totalSkus = inventory.length;
    final inStock = inventory.where((item) => item.stockStatus == StockStatus.inStock).length;
    final lowStock = inventory.where((item) => item.stockStatus == StockStatus.lowStock).length;
    final expiringSoon = inventory.where((item) => item.isExpiringSoon).length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SummaryCard(title: 'Total SKUs', value: totalSkus.toString(), color: Colors.blue.shade100),
          SummaryCard(title: 'In Stock', value: inStock.toString(), color: Colors.green.shade100),
          SummaryCard(title: 'Low Stock', value: lowStock.toString(), color: Colors.orange.shade100),
          SummaryCard(title: 'Expiring', value: expiringSoon.toString(), color: Colors.red.shade100),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Card(
      color: color,
      margin: const EdgeInsets.only(right: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.interP12M.copyWith(color: colors.neutral.secondaryText),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.inter24M.copyWith(color: colors.neutral.primaryText),
            ),
          ],
        ),
      ),
    );
  }
}
