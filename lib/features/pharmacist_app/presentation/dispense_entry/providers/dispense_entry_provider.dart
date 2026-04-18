import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/medication.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';

class DispenseEntryState {
  final List<Medication> selectedMedications;
  final String searchQuery;

  DispenseEntryState({
    this.selectedMedications = const [],
    this.searchQuery = '',
  });

  DispenseEntryState copyWith({
    List<Medication>? selectedMedications,
    String? searchQuery,
  }) {
    return DispenseEntryState(
      selectedMedications: selectedMedications ?? this.selectedMedications,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DispenseEntryNotifier extends StateNotifier<DispenseEntryState> {
  final Ref _ref;

  DispenseEntryNotifier(this._ref) : super(DispenseEntryState());

  /// Maps inventory items to the Medication model used in the dispense UI.
  List<Medication> _inventoryToMedications(List<InventoryItem> items) {
    return items.map((item) => Medication(
      id: item.id,
      name: item.medicationName,
      brand: item.brandName,
      manufacturer: item.supplierName ?? '',
      stock: item.quantityInStock,
      packSize: item.form,
      price: item.sellingPrice,
      imageUrl: item.imageUrl,
    )).toList();
  }

  List<Medication> get searchResults {
    final inventoryState = _ref.read(inventoryProvider);
    final allMeds = _inventoryToMedications(inventoryState.allItems);

    if (state.searchQuery.isEmpty) {
      return allMeds;
    }
    return allMeds
        .where((med) =>
            med.name.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
            med.brand.toLowerCase().contains(state.searchQuery.toLowerCase()))
        .toList();
  }

  void addMedication(Medication medication) {
    final newSelection = [...state.selectedMedications, medication];
    state = state.copyWith(selectedMedications: newSelection, searchQuery: '');
  }

  void removeMedication(Medication medication) {
    final newSelection = state.selectedMedications
        .where((m) => m.id != medication.id)
        .toList();
    state = state.copyWith(selectedMedications: newSelection);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final dispenseEntryProvider =
    StateNotifierProvider<DispenseEntryNotifier, DispenseEntryState>(
        (ref) => DispenseEntryNotifier(ref));
