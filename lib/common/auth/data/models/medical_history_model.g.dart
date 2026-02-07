// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalHistory _$MedicalHistoryFromJson(
  Map<String, dynamic> json,
) => MedicalHistory(
  conditionName: json['condition_name'] as String,
  currentStatus: $enumDecode(_$ConditionStatusEnumMap, json['current_status']),
  diagnosisDate: DateTime.parse(json['diagnosis_date'] as String),
  location: json['location'] as String,
  diagnosisDetails: json['diagnosis_details'] as String,
  medications: (json['medications'] as List<dynamic>)
      .map((e) => Medication.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentMedication: json['current_medication'] == null
      ? null
      : Medication.fromJson(json['current_medication'] as Map<String, dynamic>),
  allergies: (json['allergies'] as List<dynamic>)
      .map((e) => Allergies.fromJson(e as Map<String, dynamic>))
      .toList(),
  id: json['id'] as String?,
  patientId: json['patient_id'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$MedicalHistoryToJson(MedicalHistory instance) =>
    <String, dynamic>{
      'condition_name': instance.conditionName,
      'current_status': _$ConditionStatusEnumMap[instance.currentStatus]!,
      'diagnosis_date': instance.diagnosisDate.toIso8601String(),
      'location': instance.location,
      'diagnosis_details': instance.diagnosisDetails,
      'medications': instance.medications,
      'current_medication': instance.currentMedication,
      'allergies': instance.allergies,
      'id': instance.id,
      'patient_id': instance.patientId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'notes': instance.notes,
    };

const _$ConditionStatusEnumMap = {
  ConditionStatus.active: 'active',
  ConditionStatus.resolved: 'resolved',
  ConditionStatus.chronic: 'chronic',
};
