import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dummy_medications.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/medication.dart';

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
  DispenseEntryNotifier() : super(DispenseEntryState());

  List<Medication> get searchResults {
    if (state.searchQuery.isEmpty) {
      return dummyMedications;
    }
    return dummyMedications
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
        (ref) => DispenseEntryNotifier());
