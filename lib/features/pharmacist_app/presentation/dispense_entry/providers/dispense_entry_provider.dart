import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/medication.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:uuid/uuid.dart';

class DispenseItemState {
  final Medication medication;
  final int quantity;

  DispenseItemState({
    required this.medication,
    this.quantity = 1,
  });

  DispenseItemState copyWith({
    Medication? medication,
    int? quantity,
  }) {
    return DispenseItemState(
      medication: medication ?? this.medication,
      quantity: quantity ?? this.quantity,
    );
  }
}

class DispenseEntryState {
  final List<DispenseItemState> selectedItems;
  final String searchQuery;
  final String recordedByName;
  final String recordedByRole;
  final bool isSubmitting;

  DispenseEntryState({
    required this.selectedItems,
    this.searchQuery = '',
    this.recordedByName = '',
    this.recordedByRole = 'Pharmacist',
    this.isSubmitting = false,
  });

  factory DispenseEntryState.initial() {
    return DispenseEntryState(
      selectedItems: <DispenseItemState>[],
      searchQuery: '',
      recordedByName: '',
      recordedByRole: 'Pharmacist',
      isSubmitting: false,
    );
  }

  DispenseEntryState copyWith({
    List<DispenseItemState>? selectedItems,
    String? searchQuery,
    String? recordedByName,
    String? recordedByRole,
    bool? isSubmitting,
  }) {
    return DispenseEntryState(
      selectedItems: selectedItems ?? this.selectedItems,
      searchQuery: searchQuery ?? this.searchQuery,
      recordedByName: recordedByName ?? this.recordedByName,
      recordedByRole: recordedByRole ?? this.recordedByRole,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class DispenseEntryNotifier extends StateNotifier<DispenseEntryState> {
  final Ref _ref;

  DispenseEntryNotifier(this._ref) : super(DispenseEntryState.initial());

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
    if (state.selectedItems.any((item) => item.medication.id == medication.id)) {
      return; // Already added
    }
    final newSelection = [...state.selectedItems, DispenseItemState(medication: medication)];
    state = state.copyWith(selectedItems: newSelection, searchQuery: '');
  }

  void removeMedication(Medication medication) {
    final newSelection = state.selectedItems
        .where((item) => item.medication.id != medication.id)
        .toList();
    state = state.copyWith(selectedItems: newSelection);
  }

  void updateQuantity(Medication medication, int quantity) {
    final newSelection = state.selectedItems.map((item) {
      if (item.medication.id == medication.id) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    state = state.copyWith(selectedItems: newSelection);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateRecordedBy(String name, String role) {
    state = state.copyWith(recordedByName: name, recordedByRole: role);
  }

  void clear() {
      state = DispenseEntryState.initial();
  }

  Future<void> submitDispense({required String pharmacistName, required String pharmacistRole}) async {
    if (state.selectedItems.isEmpty) return;
    
    state = state.copyWith(isSubmitting: true);
    
    try {
      final pharmacyId = await _ref.read(currentPharmacyIdProvider.future);
      
      if (pharmacyId == null) {
        throw Exception('No active pharmacy found for this account.');
      }

      final finalName = state.recordedByName.isEmpty ? pharmacistName : state.recordedByName;
      final finalRole = state.recordedByRole.isEmpty ? pharmacistRole : state.recordedByRole;
      
      final record = DispenseRecord(
        id: const Uuid().v4(),
        pharmacyId: pharmacyId,
        saleId: 'SALE-${DateTime.now().millisecondsSinceEpoch}',
        recordedByRole: finalRole,
        recordedByName: finalName,
        recordedAt: DateTime.now(),
        items: state.selectedItems.map((item) => DispensedItem(
          medicationName: item.medication.name,
          brandName: item.medication.brand,
          manufacturer: item.medication.manufacturer,
          isBrand: true, 
          quantity: item.quantity,
          unitPrice: item.medication.price,
          totalPrice: item.medication.price * item.quantity,
        )).toList(),
        totalAmount: state.selectedItems.fold(0, (sum, item) => sum + (item.medication.price * item.quantity)),
      );

      print('DEBUG: submitDispense - Saving record to Firestore: ${record.id} for pharmacy: $pharmacyId');

      // 1. Save Dispense Record
      await _ref.read(dispenseRepositoryProvider).recordDispense(record);
      
      print('DEBUG: submitDispense - Record saved. Deducting inventory...');

      // 2. Deduct Inventory Stock
      final inventoryNotifier = _ref.read(inventoryProvider.notifier);
      final inventoryAllItems = _ref.read(inventoryProvider).allItems;
      
      for (final item in state.selectedItems) {
        final inventoryItem = inventoryAllItems.firstWhere((i) => i.id == item.medication.id);
        final updatedItem = inventoryItem.copyWith(
          quantityInStock: inventoryItem.quantityInStock - item.quantity,
          updatedAt: DateTime.now(),
        );
        await inventoryNotifier.updateItem(updatedItem);
      }
      
      print('DEBUG: submitDispense - Inventory updated successfully.');

      state = state.copyWith(isSubmitting: false);
      clear();
    } catch (e) {
      print('DEBUG: submitDispense - Error: $e');
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }
  }
}

final dispenseEntryProvider =
    StateNotifierProvider<DispenseEntryNotifier, DispenseEntryState>(
        (ref) => DispenseEntryNotifier(ref));
