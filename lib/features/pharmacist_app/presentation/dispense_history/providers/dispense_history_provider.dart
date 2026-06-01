import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';

class DispenseHistoryState {
  final List<DispenseRecord> allRecords;
  final List<DispenseRecord> filteredRecords;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  const DispenseHistoryState({
    this.allRecords = const [],
    this.filteredRecords = const [],
    this.searchQuery = '',
    this.isLoading = true,
    this.errorMessage,
  });

  DispenseHistoryState copyWith({
    List<DispenseRecord>? allRecords,
    List<DispenseRecord>? filteredRecords,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DispenseHistoryState(
      allRecords: allRecords ?? this.allRecords,
      filteredRecords: filteredRecords ?? this.filteredRecords,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DispenseHistoryNotifier extends StateNotifier<DispenseHistoryState> {
  final Ref _ref;
  StreamSubscription<List<DispenseRecord>>? _subscription;

  DispenseHistoryNotifier(this._ref, {String? pharmacyId})
      : super(const DispenseHistoryState()) {
    _bind(pharmacyId);
  }

  void _bind(String? pharmacyId) {
    _subscription?.cancel();
    _subscription = null;

    if (pharmacyId == null || pharmacyId.isEmpty) {
      state = const DispenseHistoryState(
        isLoading: false,
        allRecords: [],
        filteredRecords: [],
      );
      return;
    }

    state = const DispenseHistoryState(isLoading: true);
    try {
      final dispenseRepo = _ref.read(dispenseRepositoryProvider);
      _subscription = dispenseRepo.getDispenseHistory(pharmacyId).listen(
        (records) {
          state = state.copyWith(
            allRecords: records,
            isLoading: false,
            errorMessage: null,
          );
          _applySearch();
        },
        onError: (e) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
    _applySearch();
  }

  void _applySearch() {
    if (state.searchQuery.isEmpty) {
      state = state.copyWith(filteredRecords: state.allRecords);
      return;
    }

    final query = state.searchQuery.toLowerCase();
    final filtered = state.allRecords.where((record) {
      return record.saleId.toLowerCase().contains(query) ||
          record.recordedByName.toLowerCase().contains(query) ||
          record.items.any(
            (item) =>
                item.medicationName.toLowerCase().contains(query) ||
                item.brandName.toLowerCase().contains(query),
          );
    }).toList();

    state = state.copyWith(filteredRecords: filtered);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final dispenseHistoryProvider =
    StateNotifierProvider<DispenseHistoryNotifier, DispenseHistoryState>((ref) {
  final pharmacyId = ref.watch(currentPharmacyIdProvider).valueOrNull;
  return DispenseHistoryNotifier(ref, pharmacyId: pharmacyId);
});
