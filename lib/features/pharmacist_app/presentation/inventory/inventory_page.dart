import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/router/routes_names.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/inventory_list_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/search_bar.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/filter_chips.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/summary_cards.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider);

    return AppScaffold(
      removeBodyPadding: true,
      title: const Text('Inventory'),
      onBack: () => context.go(AppRoutes.pharmacistDashboard),
      scaffoldActions: [
        IconButton(
          onPressed: () => context.push(AppRoutes.pharmacistMedicationCatalog),
          icon: SvgPicture.asset(
            AppIcons.add,
            width: 24,
            height: 24,
          ),
        ),
      ],
      body: Column(
        children: [
          const InventorySearchBar(),
          const InventoryFilterChips(),
          const InventorySummaryCards(),
          Expanded(
            child: ListView.builder(
              itemCount: inventory.length,
              itemBuilder: (context, index) {
                final item = inventory[index];
                return InventoryListItem(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
