import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/domain/entities/medication.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/medication_catalog_repository.dart';

enum CatalogFilter { all, brand, generic }

class MedicationCatalogState {
  final List<Medication> allMedications;
  final List<Medication> filteredMedications;
  final List<Medication> recentSearches;
  final CatalogFilter filter;
  final String searchQuery;
  final bool isLoading;

  MedicationCatalogState({
    required this.allMedications,
    required this.filteredMedications,
    this.recentSearches = const [],
    this.filter = CatalogFilter.all,
    this.searchQuery = '',
    this.isLoading = false,
  });

  MedicationCatalogState copyWith({
    List<Medication>? allMedications,
    List<Medication>? filteredMedications,
    List<Medication>? recentSearches,
    CatalogFilter? filter,
    String? searchQuery,
    bool? isLoading,
  }) {
    return MedicationCatalogState(
      allMedications: allMedications ?? this.allMedications,
      filteredMedications: filteredMedications ?? this.filteredMedications,
      recentSearches: recentSearches ?? this.recentSearches,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MedicationCatalogNotifier extends StateNotifier<MedicationCatalogState> {
  final MedicationCatalogRepository _repository;
  Timer? _debounce;

  MedicationCatalogNotifier({required MedicationCatalogRepository repository}) 
      : _repository = repository,
        super(MedicationCatalogState(allMedications: [], filteredMedications: [])) {
    _loadInitialData();
  }

  void _loadInitialData() {
    // We start empty, or we could load some common medications
    state = state.copyWith(allMedications: [], filteredMedications: []);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    
    if (query.isEmpty) {
      state = state.copyWith(allMedications: [], filteredMedications: [], isLoading: false);
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      state = state.copyWith(isLoading: true);
      try {
        final results = await _repository.searchMedications(query);
        state = state.copyWith(
          allMedications: results,
          filteredMedications: results,
          isLoading: false,
        );
        _applyFilters();
      } catch (e) {
        state = state.copyWith(isLoading: false);
      }
    });
  }

  void updateFilter(CatalogFilter filter) {
    state = state.copyWith(filter: filter);
    _applyFilters();
  }

  void _applyFilters() {
    List<Medication> results = state.allMedications;

    // Filter by brand/generic (mock logic for OpenFDA results)
    if (state.filter == CatalogFilter.brand) {
      results = results.where((m) => m.brandNames.isNotEmpty).toList();
    } else if (state.filter == CatalogFilter.generic) {
      // In OpenFDA, if brand_name matches generic_name or brand is empty, treat as generic
      results = results.where((m) => m.brandNames.isEmpty || m.brandNames.first.toLowerCase() == m.name.toLowerCase()).toList();
    }

    state = state.copyWith(filteredMedications: results);
  }

  void addToRecent(Medication med) {
    final current = List<Medication>.from(state.recentSearches);
    if (!current.any((m) => m.id == med.id)) {
      current.insert(0, med);
      if (current.length > 5) current.removeLast();
      state = state.copyWith(recentSearches: current);
    }
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final medicationCatalogProvider = StateNotifierProvider<MedicationCatalogNotifier, MedicationCatalogState>((ref) {
  final repository = ref.watch(medicationCatalogRepositoryProvider);
  return MedicationCatalogNotifier(repository: repository);
});
