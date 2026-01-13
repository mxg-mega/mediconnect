// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItemModel _$InventoryItemModelFromJson(Map<String, dynamic> json) =>
    InventoryItemModel(
      id: json['id'] as String,
      pharmacyId: json['pharmacy_id'] as String,
      medicationId: json['medication_id'] as String,
      brandName: json['brand_name'] as String,
      quantityInStock: (json['quantity_in_stock'] as num).toInt(),
      batchNumber: json['batch_number'] as String?,
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      sellingPrice: (json['selling_price'] as num).toDouble(),
      minimumStockLevel: (json['minimum_stock_level'] as num).toInt(),
      stockStatus: json['stock_status'] as String? ?? 'out_of_stock',
      supplierName: json['supplier_name'] as String?,
      lastRestocked: DateTime.parse(json['last_restocked'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$InventoryItemModelToJson(InventoryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pharmacy_id': instance.pharmacyId,
      'medication_id': instance.medicationId,
      'brand_name': instance.brandName,
      'quantity_in_stock': instance.quantityInStock,
      'batch_number': instance.batchNumber,
      'expiry_date': instance.expiryDate.toIso8601String(),
      'purchase_price': instance.purchasePrice,
      'selling_price': instance.sellingPrice,
      'minimum_stock_level': instance.minimumStockLevel,
      'stock_status': instance.stockStatus,
      'supplier_name': instance.supplierName,
      'last_restocked': instance.lastRestocked.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
