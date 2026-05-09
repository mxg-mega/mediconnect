import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dispense_record.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DispensedItem extends Equatable {
  final String medicationName;
  final String brandName;
  final String manufacturer;
  final bool isBrand;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const DispensedItem({
    required this.medicationName,
    required this.brandName,
    required this.manufacturer,
    required this.isBrand,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory DispensedItem.fromJson(Map<String, dynamic> json) =>
      _$DispensedItemFromJson(json);

  Map<String, dynamic> toJson() => _$DispensedItemToJson(this);

  @override
  List<Object?> get props => [
        medicationName,
        brandName,
        manufacturer,
        isBrand,
        quantity,
        unitPrice,
        totalPrice,
      ];
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DispenseRecord extends Equatable {
  final String id;
  final String pharmacyId;
  final String saleId;
  final String recordedByRole;
  final String recordedByName;
  final DateTime recordedAt;
  final List<DispensedItem> items;
  final double totalAmount;

  const DispenseRecord({
    required this.id,
    required this.pharmacyId,
    required this.saleId,
    required this.recordedByRole,
    required this.recordedByName,
    required this.recordedAt,
    required this.items,
    required this.totalAmount,
  });

  factory DispenseRecord.fromJson(Map<String, dynamic> json) =>
      _$DispenseRecordFromJson(json);

  Map<String, dynamic> toJson() => _$DispenseRecordToJson(this);

  @override
  List<Object?> get props => [
        id,
        pharmacyId,
        saleId,
        recordedByRole,
        recordedByName,
        recordedAt,
        items,
        totalAmount,
      ];
}
