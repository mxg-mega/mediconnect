import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/inventory_repository.dart';

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
  final bool isLoading;

  InventoryState({
    required this.allItems,
    required this.filteredItems,
    this.sortBy = InventorySort.name,
    this.quickFilterStatus,
    InventoryFilterState? advancedFilter,
    this.searchQuery = '',
    this.isLoading = false,
  }) : advancedFilter = advancedFilter ?? InventoryFilterState();

  InventoryState copyWith({
    List<InventoryItem>? allItems,
    List<InventoryItem>? filteredItems,
    InventorySort? sortBy,
    StockStatus? quickFilterStatus,
    InventoryFilterState? advancedFilter,
    String? searchQuery,
    bool? isLoading,
  }) {
    return InventoryState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      sortBy: sortBy ?? this.sortBy,
      quickFilterStatus: quickFilterStatus, 
      advancedFilter: advancedFilter ?? this.advancedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class InventoryNotifier extends StateNotifier<InventoryState> {
  final InventoryRepository _repository;
  final String? _pharmacyId;
  StreamSubscription? _subscription;

  InventoryNotifier({
    required InventoryRepository repository,
    String? pharmacyId,
  })  : _repository = repository,
        _pharmacyId = pharmacyId,
        super(InventoryState(allItems: [], filteredItems: [], isLoading: true)) {
    if (_pharmacyId != null) {
      _listenToInventory();
    }
  }

  void _listenToInventory() {
    _subscription?.cancel();
    _subscription = _repository.getInventory(_pharmacyId!).listen((items) {
      state = state.copyWith(allItems: items, isLoading: false);
      _applyFilters();
    });
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
    List<InventoryItem> results = List.from(state.allItems);

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

    // 3. Sorting
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

  Future<void> addItem(InventoryItem item) async {
    await _repository.addInventoryItem(item);
  }

  Future<void> updateItem(InventoryItem item) async {
    await _repository.updateInventoryItem(item);
  }

  Future<void> deleteItem(String id) async {
    await _repository.deleteInventoryItem(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final inventoryProvider = StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  final repository = ref.watch(inventoryRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  
  return InventoryNotifier(
    repository: repository,
    pharmacyId: user?.pharmacyId,
  );
});
