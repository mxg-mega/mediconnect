import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';
import 'package:mediconnect/core/providers/dependency_providers.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';

class DashboardState {
  final bool isLoading;
  final String? errorMessage;

  // Sales activity
  final double todaySalesTotal;
  final int todayItemsSold;

  // Inventory stats
  final int totalSkus;
  final int lowStockCount;
  final int expiringCount;
  final double averageRating;

  // Recent dispenses
  final List<DispenseRecord> recentDispenses;

  const DashboardState({
    this.isLoading = true,
    this.errorMessage,
    this.todaySalesTotal = 0.0,
    this.todayItemsSold = 0,
    this.totalSkus = 0,
    this.lowStockCount = 0,
    this.expiringCount = 0,
    this.averageRating = 0.0,
    this.recentDispenses = const [],
  });

  DashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    double? todaySalesTotal,
    int? todayItemsSold,
    int? totalSkus,
    int? lowStockCount,
    int? expiringCount,
    double? averageRating,
    List<DispenseRecord>? recentDispenses,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      todaySalesTotal: todaySalesTotal ?? this.todaySalesTotal,
      todayItemsSold: todayItemsSold ?? this.todayItemsSold,
      totalSkus: totalSkus ?? this.totalSkus,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      expiringCount: expiringCount ?? this.expiringCount,
      averageRating: averageRating ?? this.averageRating,
      recentDispenses: recentDispenses ?? this.recentDispenses,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final Ref _ref;
  StreamSubscription<List<InventoryItem>>? _inventorySub;
  StreamSubscription<List<DispenseRecord>>? _dispenseSub;

  DashboardNotifier(this._ref, {String? pharmacyId})
      : super(const DashboardState()) {
    _bind(pharmacyId);
  }

  void _bind(String? pharmacyId) {
    _inventorySub?.cancel();
    _dispenseSub?.cancel();
    _inventorySub = null;
    _dispenseSub = null;

    if (pharmacyId == null || pharmacyId.isEmpty) {
      state = const DashboardState(isLoading: false);
      return;
    }

    state = const DashboardState(isLoading: true);
    try {
      final inventoryRepo = _ref.read(inventoryRepositoryProvider);
      final dispenseRepo = _ref.read(dispenseRepositoryProvider);

      _inventorySub = inventoryRepo.getInventory(pharmacyId).listen(
        _processInventoryStats,
        onError: (e) {
          state = state.copyWith(isLoading: false, errorMessage: e.toString());
        },
      );

      _dispenseSub = dispenseRepo.getDispenseHistory(pharmacyId).listen(
        _processDispenseData,
        onError: (e) {
          state = state.copyWith(isLoading: false, errorMessage: e.toString());
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void _processInventoryStats(List<InventoryItem> items) {
    final totalSkus = items.length;
    final lowStockCount = items
        .where(
          (i) =>
              i.stockStatus == StockStatus.lowStock ||
              i.stockStatus == StockStatus.outOfStock,
        )
        .length;
    final expiringCount = items.where((i) => i.isExpiringSoon).length;

    state = state.copyWith(
      isLoading: false,
      totalSkus: totalSkus,
      lowStockCount: lowStockCount,
      expiringCount: expiringCount,
    );
  }

  void _processDispenseData(List<DispenseRecord> records) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final todayRecords = records
        .where((r) => r.recordedAt.isAfter(todayStart))
        .toList();

    final todaySalesTotal = todayRecords.fold<double>(
      0.0,
      (sum, r) => sum + r.totalAmount,
    );
    final todayItemsSold = todayRecords.fold<int>(
      0,
      (sum, r) => sum + r.items.length,
    );

    final recentDispenses = records.take(3).toList();

    state = state.copyWith(
      isLoading: false,
      todaySalesTotal: todaySalesTotal,
      todayItemsSold: todayItemsSold,
      recentDispenses: recentDispenses,
    );
  }

  @override
  void dispose() {
    _inventorySub?.cancel();
    _dispenseSub?.cancel();
    super.dispose();
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final pharmacyId = ref.watch(currentPharmacyIdProvider).valueOrNull;
  return DashboardNotifier(ref, pharmacyId: pharmacyId);
});
