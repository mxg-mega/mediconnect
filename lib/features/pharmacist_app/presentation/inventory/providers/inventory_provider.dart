import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<InventoryItem>>((ref) {
  return InventoryNotifier();
});

class InventoryNotifier extends StateNotifier<List<InventoryItem>> {
  InventoryNotifier() : super([]) {
    _loadInitialData();
  }

  // Store the original unfiltered list
  List<InventoryItem> _originalItems = [];

  void _loadInitialData() {
    // Dummy data based on inventory_page.png
    _originalItems = [
      InventoryItem(
        id: '1',
        pharmacyId: 'p1',
        medicationId: 'm1',
        medicationName: 'Amoxicillin 500 mg',
        brandName: 'Teva',
        form: 'Tablet',
        imageUrl: 'assets/images/amoxicillin_gsk.png',
        quantityInStock: 131,
        stockStatus: StockStatus.inStock,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        purchasePrice: 10.0,
        sellingPrice: 15.0,
        minimumStockLevel: 20,
        lastRestocked: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        purchasePrice: 12.0,
        sellingPrice: 18.0,
        minimumStockLevel: 20,
        lastRestocked: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        purchasePrice: 5.0,
        sellingPrice: 8.0,
        minimumStockLevel: 10,
        lastRestocked: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      InventoryItem(
        id: '4',
        pharmacyId: 'p1',
        medicationId: 'm4',
        medicationName: 'Panadol 500 mg',
        brandName: 'Panadol by GSK',
        form: 'Tablet',
        imageUrl: 'assets/images/amoxicillin_gsk.png', // Placeholder, missing panadol image
        quantityInStock: 62,
        stockStatus: StockStatus.inStock,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        purchasePrice: 8.0,
        sellingPrice: 12.0,
        minimumStockLevel: 15,
        lastRestocked: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
       InventoryItem(
        id: '5',
        pharmacyId: 'p1',
        medicationId: 'm5',
        medicationName: 'Ibuprofen 200 mg',
        brandName: 'Advil by Pfizer',
        form: 'Capsule',
        imageUrl: 'assets/images/ibuprofen_pfizer.png',
        quantityInStock: 3,
        stockStatus: StockStatus.lowStock,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        purchasePrice: 5.0,
        sellingPrice: 8.0,
        minimumStockLevel: 10,
        lastRestocked: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
       InventoryItem(
        id: '6',
        pharmacyId: 'p1',
        medicationId: 'm6',
        medicationName: 'Paracetamol 500 mg',
        brandName: 'Tylenol by J&J',
        form: 'Tablet',
        imageUrl: 'assets/images/amoxicillin_gsk.png', // Placeholder
        quantityInStock: 0,
        stockStatus: StockStatus.outOfStock,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        purchasePrice: 4.0,
        sellingPrice: 7.0,
        minimumStockLevel: 10,
        lastRestocked: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      InventoryItem(
        id: '7',
        pharmacyId: 'p1',
        medicationId: 'm7',
        medicationName: 'Metformin 500 mg',
        brandName: 'Privil by Merck',
        form: 'Tablet',
        imageUrl: 'assets/images/metformin_merck.png',
        quantityInStock: 5,
        stockStatus: StockStatus.expiringSoon,
        expiryDate: DateTime.now().add(const Duration(days: 25)),
        purchasePrice: 20.0,
        sellingPrice: 25.0,
        minimumStockLevel: 10,
        lastRestocked: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    state = _originalItems;
  }

  void filterByStatus(StockStatus? status) {
    if (status == null) {
      state = _originalItems;
    } else {
      state = _originalItems.where((item) => item.stockStatus == status).toList();
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      state = _originalItems;
    } else {
      final lowerCaseQuery = query.toLowerCase();
      state = _originalItems
          .where((item) =>
              item.medicationName.toLowerCase().contains(lowerCaseQuery) ||
              item.brandName.toLowerCase().contains(lowerCaseQuery))
          .toList();
    }
  }
}
