import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/domain/entities/medication.dart';

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
  MedicationCatalogNotifier() : super(MedicationCatalogState(allMedications: [], filteredMedications: [])) {
    _loadInitialData();
  }

  void _loadInitialData() {
    final now = DateTime.now();
    final mockMedications = [
      Medication(
        id: 'cat-1',
        name: '2-Hydroxyethyl Salicylate (150ML)',
        brandNames: ['BenGay® by Johnson & Johnson'],
        category: 'Pain Reliever',
        manufacturer: 'Johnson & Johnson',
        dosageForms: ['Sprays'],
        strengths: ['150ML'],
        description: 'BenGay is a topical analgesic used for temporary relief of minor aches and pains of muscles and joints.',
        createdAt: now,
        updatedAt: now,
      ),
      Medication(
        id: 'cat-2',
        name: 'Acetaminophen',
        brandNames: ['Tylenol® by Johnson & Johnson'],
        category: 'Pain Reliever',
        manufacturer: 'Johnson & Johnson',
        dosageForms: ['Tablets'],
        strengths: ['500mg'],
        description: 'Acetaminophen is a pain reliever and a fever reducer.',
        createdAt: now,
        updatedAt: now,
      ),
      Medication(
        id: 'cat-3',
        name: 'Amlodipine',
        brandNames: ['Norvasc by Pfizer'],
        category: 'Antihypertensive',
        manufacturer: 'Pfizer',
        dosageForms: ['Tablets'],
        strengths: ['5mg', '10mg'],
        createdAt: now,
        updatedAt: now,
      ),
      Medication(
        id: 'cat-4',
        name: 'Amoxicillin 200mg',
        brandNames: ['Amoxil by GlaxoSmithKline'],
        category: 'Antibiotic',
        manufacturer: 'GlaxoSmithKline',
        dosageForms: ['Tablets'],
        strengths: ['200mg'],
        createdAt: now,
        updatedAt: now,
      ),
      Medication(
        id: 'cat-5',
        name: 'Amoxicillin 500mg',
        brandNames: ['Amoxil by GlaxoSmithKline'],
        category: 'Antibiotic',
        manufacturer: 'GlaxoSmithKline',
        dosageForms: ['Tablets'],
        strengths: ['500mg'],
        description: 'Amoxicillin is a penicillin antibiotic that fights bacteria.',
        createdAt: now,
        updatedAt: now,
      ),
      Medication(
        id: 'cat-6',
        name: 'Azithromycin',
        brandNames: ['Zithromax by Pfizer'],
        category: 'Antibiotic',
        manufacturer: 'Pfizer',
        dosageForms: ['Tablets'],
        strengths: ['250mg', '500mg'],
        createdAt: now,
        updatedAt: now,
      ),
      Medication(
        id: 'cat-7',
        name: 'Ciprofloxacin',
        brandNames: ['Cipro by Bayer'],
        category: 'Antibiotic',
        manufacturer: 'Bayer',
        dosageForms: ['Tablets'],
        strengths: ['250mg', '500mg'],
        createdAt: now,
        updatedAt: now,
      ),
      Medication(
        id: 'cat-8',
        name: 'Duloxetine',
        brandNames: ['Cymbalta by Eli Lilly and Company'],
        category: 'Antidepressant (SNRI)',
        manufacturer: 'Eli Lilly and Company',
        dosageForms: ['Capsules'],
        strengths: ['20mg', '30mg', '60mg'],
        createdAt: now,
        updatedAt: now,
      ),
    ];

    state = state.copyWith(
      allMedications: mockMedications,
      filteredMedications: mockMedications,
      recentSearches: [mockMedications[4], mockMedications[9 % mockMedications.length]], // Mock recent
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void updateFilter(CatalogFilter filter) {
    state = state.copyWith(filter: filter);
    _applyFilters();
  }

  void _applyFilters() {
    List<Medication> results = state.allMedications;

    // Apply search
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      results = results.where((m) {
        final matchesName = m.name.toLowerCase().contains(query);
        final matchesBrand = m.brandNames.any((b) => b.toLowerCase().contains(query));
        final matchesCategory = m.category.toLowerCase().contains(query);
        return matchesName || matchesBrand || matchesCategory;
      }).toList();
    }

    // Apply filter (mock logic for brand/generic)
    if (state.filter == CatalogFilter.brand) {
      // In a real app, Medication would have a isGeneric field
      results = results.where((m) => m.brandNames.isNotEmpty).toList();
    } else if (state.filter == CatalogFilter.generic) {
      results = results.where((m) => m.brandNames.isEmpty || m.name.contains('Generic')).toList();
    }

    state = state.copyWith(filteredMedications: results);
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }
}

final medicationCatalogProvider = StateNotifierProvider<MedicationCatalogNotifier, MedicationCatalogState>((ref) {
  return MedicationCatalogNotifier();
});
