import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/constants/colors.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/inventory_list_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/search_bar.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/filter_chips.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/summary_cards.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryProvider);
    final theme = AppTheme.colors(context);

    return AppScaffold(
      removeBodyPadding: true,
      hasAppBar: false,
      body: Column(
        children: [
          _buildHeader(context, theme),
          const InventorySearchBar(),
          const InventoryFilterChips(),
          const InventorySummaryCards(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: context.figmaHeight(80)),
              itemCount: state.filteredItems.length,
              itemBuilder: (context, index) {
                final item = state.filteredItems[index];
                return InventoryListItem(item: item);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.pharmacistMedicationCatalog),
        backgroundColor: theme.pharmacist.bg,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppColorsTheme theme) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.figmaWidth(16),
        right: context.figmaWidth(16),
        top: context.figmaHeight(20),
        bottom: context.figmaHeight(10),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go(AppRoutes.pharmacistDashboard),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Text(
              'Inventory',
              textAlign: TextAlign.center,
              style: AppTextStyles.interP18M.copyWith(
                color: theme.neutral.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance for back button
        ],
      ),
    );
  }
}
