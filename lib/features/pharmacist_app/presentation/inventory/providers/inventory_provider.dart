import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';

enum InventorySort { name, date, quantity, expiry }

class InventoryFilterState {
  final List<String> medicationTypes; // All, Brand, Generic
  final List<String> categories;
  final List<String> expiryWindows; // < 7 days, 8-30, > 30
  final DateTime? customDate;
  final List<String> dosageForms;

  InventoryFilterState({
    this.medicationTypes = const ['All'],
    this.categories = const [],
    this.expiryWindows = const [],
    this.customDate,
    this.dosageForms = const [],
  });

  InventoryFilterState copyWith({
    List<String>? medicationTypes,
    List<String>? categories,
    List<String>? expiryWindows,
    DateTime? customDate,
    List<String>? dosageForms,
  }) {
    return InventoryFilterState(
      medicationTypes: medicationTypes ?? this.medicationTypes,
      categories: categories ?? this.categories,
      expiryWindows: expiryWindows ?? this.expiryWindows,
      customDate: customDate ?? this.customDate,
      dosageForms: dosageForms ?? this.dosageForms,
    );
  }
}

class InventoryState {
  final List<InventoryItem> allItems;
  final List<InventoryItem> filteredItems;
  final InventorySort sortBy;
  final StockStatus? quickFilterStatus;
  final InventoryFilterState advancedFilter;
  final String searchQuery;

  InventoryState({
    required this.allItems,
    required this.filteredItems,
    this.sortBy = InventorySort.name,
    this.quickFilterStatus,
    InventoryFilterState? advancedFilter,
    this.searchQuery = '',
  }) : advancedFilter = advancedFilter ?? InventoryFilterState();

  InventoryState copyWith({
    List<InventoryItem>? allItems,
    List<InventoryItem>? filteredItems,
    InventorySort? sortBy,
    StockStatus? quickFilterStatus,
    InventoryFilterState? advancedFilter,
    String? searchQuery,
  }) {
    return InventoryState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      sortBy: sortBy ?? this.sortBy,
      quickFilterStatus: quickFilterStatus, // Can be null
      advancedFilter: advancedFilter ?? this.advancedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class InventoryNotifier extends StateNotifier<InventoryState> {
  InventoryNotifier() : super(InventoryState(allItems: [], filteredItems: [])) {
    _loadInitialData();
  }

  void _loadInitialData() {
    final now = DateTime.now();
    final items = [
      InventoryItem(
        id: '1',
        pharmacyId: 'p1',
        medicationId: 'm1',
        medicationName: 'Amoxicillin 500 mg',
        brandName: 'Amoxicillin by Teva',
        form: 'Tablet',
        imageUrl: 'assets/images/amoxicillin_gsk.png',
        quantityInStock: 131,
        stockStatus: StockStatus.inStock,
        expiryDate: now.add(const Duration(days: 365)),
        purchasePrice: 10.0,
        sellingPrice: 15.0,
        minimumStockLevel: 20,
        lastRestocked: now,
        createdAt: now,
        updatedAt: now,
      ),
      InventoryItem(
        id: '2',
        pharmacyId: 'p1',
        medicationId: 'm2',
        medicationName: 'Amoxicillin 500 mg',
        brandName: 'Amoxil by GSK',
        form: 'Tablet',
        imageUrl: 'assets/images/amoxicillin_gsk.png',
        quantityInStock: 74,
        stockStatus: StockStatus.inStock,
        expiryDate: now.add(const Duration(days: 365)),
        purchasePrice: 12.0,
        sellingPrice: 18.0,
        minimumStockLevel: 20,
        lastRestocked: now,
        createdAt: now,
        updatedAt: now,
      ),
      InventoryItem(
        id: '3',
        pharmacyId: 'p1',
        medicationId: 'm3',
        medicationName: 'Ibuprofen 200 mg',
        brandName: 'Advil by Pfizer',
        form: 'Capsule',
        imageUrl: 'assets/images/ibuprofen_pfizer.png',
        quantityInStock: 3,
        stockStatus: StockStatus.lowStock,
        expiryDate: now.add(const Duration(days: 365)),
        purchasePrice: 5.0,
        sellingPrice: 8.0,
        minimumStockLevel: 10,
        lastRestocked: now,
        createdAt: now,
        updatedAt: now,
      ),
      InventoryItem(
        id: '4',
        pharmacyId: 'p1',
        medicationId: 'm4',
        medicationName: 'Panadol 500 mg',
        brandName: 'Panadol by GSK',
        form: 'Tablet',
        imageUrl: 'assets/images/amoxicillin_gsk.png',
        quantityInStock: 62,
        stockStatus: StockStatus.inStock,
        expiryDate: now.add(const Duration(days: 365)),
        purchasePrice: 8.0,
        sellingPrice: 12.0,
        minimumStockLevel: 15,
        lastRestocked: now,
        createdAt: now,
        updatedAt: now,
      ),
      InventoryItem(
        id: '5',
        pharmacyId: 'p1',
        medicationId: 'm5',
        medicationName: 'Paracetamol 500 mg',
        brandName: 'Tylenol by J&J',
        form: 'Tablet',
        imageUrl: 'assets/images/amoxicillin_gsk.png',
        quantityInStock: 0,
        stockStatus: StockStatus.outOfStock,
        expiryDate: now.add(const Duration(days: 365)),
        purchasePrice: 4.0,
        sellingPrice: 7.0,
        minimumStockLevel: 10,
        lastRestocked: now,
        createdAt: now,
        updatedAt: now,
      ),
      InventoryItem(
        id: '6',
        pharmacyId: 'p1',
        medicationId: 'm6',
        medicationName: 'Metformin 500 mg',
        brandName: 'Prinivil by Merck',
        form: 'Tablet',
        imageUrl: 'assets/images/metformin_merck.png',
        quantityInStock: 5,
        stockStatus: StockStatus.expiringSoon,
        expiryDate: now.add(const Duration(days: 25)),
        purchasePrice: 20.0,
        sellingPrice: 25.0,
        minimumStockLevel: 10,
        lastRestocked: now,
        createdAt: now,
        updatedAt: now,
      ),
    ];
    state = state.copyWith(allItems: items, filteredItems: items);
    _applyFilters();
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void updateQuickFilter(StockStatus? status) {
    state = state.copyWith(quickFilterStatus: status);
    _applyFilters();
  }

  void updateSort(InventorySort sort) {
    state = state.copyWith(sortBy: sort);
    _applyFilters();
  }

  void applyAdvancedFilter(InventoryFilterState advancedFilter) {
    state = state.copyWith(advancedFilter: advancedFilter);
    _applyFilters();
  }

  void _applyFilters() {
    List<InventoryItem> results = state.allItems;

    // 1. Search Query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      results = results.where((item) =>
          item.medicationName.toLowerCase().contains(query) ||
          item.brandName.toLowerCase().contains(query)).toList();
    }

    // 2. Quick Status Filter
    if (state.quickFilterStatus != null) {
      results = results.where((item) => item.stockStatus == state.quickFilterStatus).toList();
    }

    // 3. Advanced Filters (Mock implementation)
    // medicationTypes, categories, expiryWindows, dosageForms would be implemented here

    // 4. Sorting
    switch (state.sortBy) {
      case InventorySort.name:
        results.sort((a, b) => a.medicationName.compareTo(b.medicationName));
        break;
      case InventorySort.date:
        results.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case InventorySort.quantity:
        results.sort((a, b) => b.quantityInStock.compareTo(a.quantityInStock));
        break;
      case InventorySort.expiry:
        results.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
    }

    state = state.copyWith(filteredItems: results);
  }

  void deleteItem(String id) {
    final newItems = state.allItems.where((item) => item.id != id).toList();
    state = state.copyWith(allItems: newItems);
    _applyFilters();
  }
}

final inventoryProvider = StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  return InventoryNotifier();
});
