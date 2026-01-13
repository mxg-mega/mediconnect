import 'package:equatable/equatable.dart';

enum StockStatus {
  inStock,
  lowStock,
  outOfStock;

  String get value {
    switch (this) {
      case StockStatus.inStock:
        return 'in_stock';
      case StockStatus.lowStock:
        return 'low_stock';
      case StockStatus.outOfStock:
        return 'out_of_stock';
    }
  }

  String get displayName {
    switch (this) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  static StockStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'in_stock':
        return StockStatus.inStock;
      case 'low_stock':
        return StockStatus.lowStock;
      case 'out_of_stock':
        return StockStatus.outOfStock;
      default:
        return StockStatus.outOfStock;
    }
  }

  static StockStatus determineStatus(int quantity, int minimumLevel) {
    if (quantity <= 0) {
      return StockStatus.outOfStock;
    } else if (quantity <= minimumLevel) {
      return StockStatus.lowStock;
    } else {
      return StockStatus.inStock;
    }
  }
}

class InventoryItem extends Equatable {
  final String id; // Primary key
  final String pharmacyId; // Foreign key to Pharmacy
  final String medicationId; // Foreign key to Medication
  final String brandName; // Brand name of the medication
  final int quantityInStock; // Current stock
  final String? batchNumber; // Batch/lot number
  final DateTime expiryDate; // Expiry date
  final double purchasePrice; // Cost price
  final double sellingPrice; // Retail price
  final int minimumStockLevel; // Alert threshold
  final StockStatus stockStatus; // in_stock | low_stock | out_of_stock
  final String? supplierName; // Supplier information
  final DateTime lastRestocked; // Last restock date
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryItem({
    required this.id,
    required this.pharmacyId,
    required this.medicationId,
    required this.brandName,
    required this.quantityInStock,
    this.batchNumber,
    required this.expiryDate,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.minimumStockLevel,
    required this.stockStatus,
    this.supplierName,
    required this.lastRestocked,
    required this.createdAt,
    required this.updatedAt,
  });

  double get profitMargin {
    if (purchasePrice == 0) return 0.0;
    return ((sellingPrice - purchasePrice) / purchasePrice) * 100;
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiryDate);
  }

  bool get isExpiringSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  int get daysUntilExpiry {
    return expiryDate.difference(DateTime.now()).inDays;
  }

  @override
  List<Object?> get props => [
    id,
    pharmacyId,
    medicationId,
    brandName,
    quantityInStock,
    batchNumber,
    expiryDate,
    purchasePrice,
    sellingPrice,
    minimumStockLevel,
    stockStatus,
    supplierName,
    lastRestocked,
    createdAt,
    updatedAt,
  ];

  InventoryItem copyWith({
    String? id,
    String? pharmacyId,
    String? medicationId,
    String? brandName,
    int? quantityInStock,
    String? batchNumber,
    DateTime? expiryDate,
    double? purchasePrice,
    double? sellingPrice,
    int? minimumStockLevel,
    StockStatus? stockStatus,
    String? supplierName,
    DateTime? lastRestocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      medicationId: medicationId ?? this.medicationId,
      brandName: brandName ?? this.brandName,
      quantityInStock: quantityInStock ?? this.quantityInStock,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      minimumStockLevel: minimumStockLevel ?? this.minimumStockLevel,
      stockStatus: stockStatus ?? this.stockStatus,
      supplierName: supplierName ?? this.supplierName,
      lastRestocked: lastRestocked ?? this.lastRestocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  InventoryItem updateStock(int newQuantity) {
    final newStockStatus = StockStatus.determineStatus(
      newQuantity,
      minimumStockLevel,
    );
    return copyWith(
      quantityInStock: newQuantity,
      stockStatus: newStockStatus,
      updatedAt: DateTime.now(),
    );
  }

  InventoryItem restock(int additionalQuantity, String? newBatchNumber) {
    final newQuantity = quantityInStock + additionalQuantity;
    final newStockStatus = StockStatus.determineStatus(
      newQuantity,
      minimumStockLevel,
    );
    return copyWith(
      quantityInStock: newQuantity,
      batchNumber: newBatchNumber ?? batchNumber,
      stockStatus: newStockStatus,
      lastRestocked: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
