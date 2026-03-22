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
    final allItems = ref.watch(inventoryProvider.select((s) => s.allItems));

    final totalSkus = allItems.length;
    final inStock = allItems.where((item) => item.stockStatus == StockStatus.inStock).length;
    final lowStock = allItems.where((item) => item.stockStatus == StockStatus.lowStock).length;
    final expiringSoon = allItems.where((item) => item.stockStatus == StockStatus.expiringSoon).length;

    final theme = AppTheme.colors(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildSummaryCard('TOTAL SKUs', totalSkus.toString(), theme.support.blue.withValues(alpha: 0.1), theme.support.blue),
          _buildSummaryCard('IN STOCK', inStock.toString(), theme.support.green.withValues(alpha: 0.1), theme.support.green),
          _buildSummaryCard('LOW STOCK', lowStock.toString(), theme.support.red.withValues(alpha: 0.1), theme.support.red),
          _buildSummaryCard('EXPIRING', expiringSoon.toString(), theme.support.orange.withValues(alpha: 0.1), theme.support.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color bgColor, Color valueColor) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.interP12M.copyWith(color: valueColor),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.interP18M.copyWith(color: valueColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
