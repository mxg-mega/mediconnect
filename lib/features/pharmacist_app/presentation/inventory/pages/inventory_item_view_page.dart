import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';

class InventoryItemViewPage extends ConsumerWidget {
  final InventoryItem item;
  const InventoryItemViewPage({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.colors(context);

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme, ref),
            _buildImage(context),
            Padding(
              padding: EdgeInsets.all(context.figmaWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReadOnlyField(context, 'Medication Name(API)', item.medicationName, theme),
                  _buildReadOnlyField(context, 'Medication Type', 'Brand', theme), // Mock
                  _buildReadOnlyField(context, 'Medication Type Name', item.brandName, theme),
                  _buildReadOnlyField(context, 'Manufacturer', 'GlaxoSmithKline', theme), // Mock
                  _buildReadOnlyField(context, 'Tags/Preferred Name(Optional)', '', theme),
                  SizedBox(height: context.figmaHeight(24)),
                  _buildSectionHeader('Medication Info', theme),
                  _buildReadOnlyField(context, 'Category', 'Antibiotics', theme), // Mock
                  _buildReadOnlyField(context, 'Strength/Concentration', '500MG', theme), // Mock
                  _buildReadOnlyField(context, 'Dosage Form', item.form, theme),
                  _buildReadOnlyField(context, 'Quantity per Pack', "10's", theme), // Mock
                  _buildReadOnlyField(context, 'Description', 'Amoxicillin is an aminopenicillin...', theme, maxLines: 5),
                  _buildReadOnlyField(context, 'Benefits & Uses', 'Respiratory tract infections...', theme, maxLines: 4),
                  SizedBox(height: context.figmaHeight(24)),
                  _buildSectionHeader('Inventory', theme),
                  _buildReadOnlyField(context, 'Current Stock Units', item.quantityInStock.toString(), theme),
                  _buildReadOnlyField(context, 'Reorder Point', item.minimumStockLevel.toString(), theme),
                  _buildReadOnlyField(context, 'Expiration Date', '${item.expiryDate.year}-${item.expiryDate.month.toString().padLeft(2, '0')}-${item.expiryDate.day.toString().padLeft(2, '0')}', theme),
                  SizedBox(height: context.figmaHeight(24)),
                  _buildSectionHeader('Medication Price', theme),
                  _buildReadOnlyField(context, 'Price(₦)', item.sellingPrice.toStringAsFixed(0), theme),
                  SizedBox(height: context.figmaHeight(40)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsTheme theme, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.figmaWidth(16),
        vertical: context.figmaHeight(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Text(
              'Inventory Item',
              textAlign: TextAlign.center,
              style: AppTextStyles.interP18M.copyWith(color: theme.neutral.primaryText),
            ),
          ),
          IconButton(
            onPressed: () {
              // Show delete confirmation
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Item'),
                  content: const Text('Are you sure you want to delete this item from inventory?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        ref.read(inventoryProvider.notifier).deleteItem(item.id);
                        Navigator.pop(context); // Close dialog
                        context.pop(); // Go back to inventory
                      },
                      child: Text('Delete', style: TextStyle(color: theme.support.red)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.pharmacistInventoryEdit, extra: item),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      height: context.figmaHeight(200),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(item.imageUrl ?? 'assets/images/amoxicillin_gsk.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppColorsTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.interP18M.copyWith(color: theme.neutral.primaryText),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4, bottom: 16),
          height: 2,
          width: 40,
          color: theme.pharmacist.bg,
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(BuildContext context, String label, String value, AppColorsTheme theme, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.figmaHeight(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.interP14M.copyWith(color: theme.neutral.secondaryText)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: theme.neutral.bgTint,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.neutral.border.withOpacity(0.1)),
            ),
            child: Text(
              value,
              maxLines: maxLines,
              style: AppTextStyles.interP14R.copyWith(color: theme.neutral.primaryText),
            ),
          ),
        ],
      ),
    );
  }
}
