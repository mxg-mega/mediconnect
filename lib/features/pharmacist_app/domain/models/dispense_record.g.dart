// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispense_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DispensedItem _$DispensedItemFromJson(Map<String, dynamic> json) =>
    DispensedItem(
      medicationName: json['medication_name'] as String,
      brandName: json['brand_name'] as String,
      manufacturer: json['manufacturer'] as String,
      isBrand: json['is_brand'] as bool,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );

Map<String, dynamic> _$DispensedItemToJson(DispensedItem instance) =>
    <String, dynamic>{
      'medication_name': instance.medicationName,
      'brand_name': instance.brandName,
      'manufacturer': instance.manufacturer,
      'is_brand': instance.isBrand,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
    };

DispenseRecord _$DispenseRecordFromJson(Map<String, dynamic> json) =>
    DispenseRecord(
      id: json['id'] as String,
      pharmacyId: json['pharmacy_id'] as String,
      saleId: json['sale_id'] as String,
      recordedByRole: json['recorded_by_role'] as String,
      recordedByName: json['recorded_by_name'] as String,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => DispensedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
    );

Map<String, dynamic> _$DispenseRecordToJson(DispenseRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pharmacy_id': instance.pharmacyId,
      'sale_id': instance.saleId,
      'recorded_by_role': instance.recordedByRole,
      'recorded_by_name': instance.recordedByName,
      'recorded_at': instance.recordedAt.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total_amount': instance.totalAmount,
    };
