import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/features/pharmacist_app/domain/entities/inventory_item.dart';

part 'inventory_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InventoryItemModel extends Equatable {
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
  final String stockStatus; // in_stock | low_stock | out_of_stock
  final String? supplierName; // Supplier information
  final DateTime lastRestocked; // Last restock date
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryItemModel({
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
    this.stockStatus = 'out_of_stock',
    this.supplierName,
    required this.lastRestocked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);

  factory InventoryItemModel.fromEntity(InventoryItem entity) {
    return InventoryItemModel(
      id: entity.id,
      pharmacyId: entity.pharmacyId,
      medicationId: entity.medicationId,
      brandName: entity.brandName,
      quantityInStock: entity.quantityInStock,
      batchNumber: entity.batchNumber,
      expiryDate: entity.expiryDate,
      purchasePrice: entity.purchasePrice,
      sellingPrice: entity.sellingPrice,
      minimumStockLevel: entity.minimumStockLevel,
      stockStatus: entity.stockStatus.value,
      supplierName: entity.supplierName,
      lastRestocked: entity.lastRestocked,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  InventoryItem toEntity() {
    return InventoryItem(
      id: id,
      pharmacyId: pharmacyId,
      medicationId: medicationId,
      brandName: brandName,
      quantityInStock: quantityInStock,
      batchNumber: batchNumber,
      expiryDate: expiryDate,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      minimumStockLevel: minimumStockLevel,
      stockStatus: StockStatus.fromString(stockStatus),
      supplierName: supplierName,
      lastRestocked: lastRestocked,
      createdAt: createdAt,
      updatedAt: updatedAt,
      // TODO: The medicationName and form are not stored in the inventory item, but they are needed to create the entity. We can set them to empty strings or fetch them from a medication repository if needed.
      medicationName: '', form: '',
    );
  }

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

  InventoryItemModel copyWith({
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
    String? stockStatus,
    String? supplierName,
    DateTime? lastRestocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItemModel(
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

  InventoryItemModel updateStock(int newQuantity) {
    final newStockStatus = StockStatus.determineStatus(
      newQuantity,
      minimumStockLevel,
    );
    return copyWith(
      quantityInStock: newQuantity,
      stockStatus: newStockStatus.value,
      updatedAt: DateTime.now(),
    );
  }

  InventoryItemModel restock(int additionalQuantity, String? newBatchNumber) {
    final newQuantity = quantityInStock + additionalQuantity;
    final newStockStatus = StockStatus.determineStatus(
      newQuantity,
      minimumStockLevel,
    );
    return copyWith(
      quantityInStock: newQuantity,
      batchNumber: newBatchNumber ?? batchNumber,
      stockStatus: newStockStatus.value,
      lastRestocked: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
