import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/inventory_list_item.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/search_bar.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/filter_chips.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/summary_cards.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter action
            },
          ),
        ],
      ),
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
