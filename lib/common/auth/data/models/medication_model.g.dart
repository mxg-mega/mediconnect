// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication(
      id: json['id'] as String,
      medicationName: json['medication_name'] as String,
      prescribedBy: json['prescribed_by'] as String,
      dosage: json['dosage'] as String,
      form: json['form'] as String,
      prescriptionDate: json['prescription_date'] == null
          ? null
          : DateTime.parse(json['prescription_date'] as String),
    );

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medication_name': instance.medicationName,
      'prescribed_by': instance.prescribedBy,
      'dosage': instance.dosage,
      'form': instance.form,
      'prescription_date': instance.prescriptionDate?.toIso8601String(),
    };

Allergies _$AllergiesFromJson(Map<String, dynamic> json) => Allergies(
      id: json['id'] as String,
      allergenName: json['allergen_name'] as String,
      type: json['type'] as String,
      severity: json['severity'] as String,
    );

Map<String, dynamic> _$AllergiesToJson(Allergies instance) => <String, dynamic>{
      'id': instance.id,
      'allergen_name': instance.allergenName,
      'type': instance.type,
      'severity': instance.severity,
    };
