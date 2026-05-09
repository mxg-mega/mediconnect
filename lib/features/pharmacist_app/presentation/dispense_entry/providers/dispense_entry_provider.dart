import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/medication.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:uuid/uuid.dart';

class DispenseEntryState {
  final List<Medication> selectedMedications;
  final String searchQuery;
  final String recordedByName;
  final String recordedByRole;
  final bool isSubmitting;

  DispenseEntryState({
    this.selectedMedications = const [],
    this.searchQuery = '',
    this.recordedByName = '',
    this.recordedByRole = 'Pharmacist',
    this.isSubmitting = false,
  });

  DispenseEntryState copyWith({
    List<Medication>? selectedMedications,
    String? searchQuery,
    String? recordedByName,
    String? recordedByRole,
    bool? isSubmitting,
  }) {
    return DispenseEntryState(
      selectedMedications: selectedMedications ?? this.selectedMedications,
      searchQuery: searchQuery ?? this.searchQuery,
      recordedByName: recordedByName ?? this.recordedByName,
      recordedByRole: recordedByRole ?? this.recordedByRole,
      isSubmitting: isSubmitting ?? this.isSubmitting,
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

  void updateRecordedBy(String name, String role) {
    state = state.copyWith(recordedByName: name, recordedByRole: role);
  }

  void clear() {
    state = DispenseEntryState();
  }

  Future<void> submitDispense({required String pharmacistName, required String pharmacistRole}) async {
    if (state.selectedMedications.isEmpty) return;
    
    state = state.copyWith(isSubmitting: true);
    
    try {
      final finalName = state.recordedByName.isEmpty ? pharmacistName : state.recordedByName;
      final finalRole = state.recordedByRole.isEmpty ? pharmacistRole : state.recordedByRole;
      
      final record = DispenseRecord(
        id: const Uuid().v4(),
        saleId: 'SALE-${DateTime.now().millisecondsSinceEpoch}',
        recordedByRole: finalRole,
        recordedByName: finalName,
        recordedAt: DateTime.now(),
        items: state.selectedMedications.map((m) => DispensedItem(
          medicationName: m.name,
          brandName: m.brand,
          manufacturer: m.manufacturer,
          isBrand: true, 
          quantity: 1, // Defaulting to 1 for now
          unitPrice: m.price,
          totalPrice: m.price,
        )).toList(),
        totalAmount: state.selectedMedications.fold(0, (sum, m) => sum + m.price),
      );

      // 1. Save Dispense Record
      await _ref.read(dispenseRepositoryProvider).recordDispense(record);
      
      // 2. Deduct Inventory Stock
      final inventoryNotifier = _ref.read(inventoryProvider.notifier);
      final inventoryAllItems = _ref.read(inventoryProvider).allItems;
      
      for (final med in state.selectedMedications) {
        final inventoryItem = inventoryAllItems.firstWhere((item) => item.id == med.id);
        final updatedItem = inventoryItem.copyWith(
          quantityInStock: inventoryItem.quantityInStock - 1,
          updatedAt: DateTime.now(),
        );
        await inventoryNotifier.updateItem(updatedItem);
      }
      
      state = state.copyWith(isSubmitting: false);
      clear();
    } catch (e) {
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }
  }
}

final dispenseEntryProvider =
    StateNotifierProvider<DispenseEntryNotifier, DispenseEntryState>(
        (ref) => DispenseEntryNotifier(ref));
