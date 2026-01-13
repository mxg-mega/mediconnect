// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientProfileModel _$PatientProfileModelFromJson(Map<String, dynamic> json) =>
    PatientProfileModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String,
      bloodType: json['blood_type'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      emergencyContactRelation: json['emergency_contact_relation'] as String?,
      medicalHistoryPrivacy:
          json['medical_history_privacy'] as String? ?? 'private',
      allowedPharmacistIds:
          (json['allowed_pharmacist_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PatientProfileModelToJson(
  PatientProfileModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'full_name': instance.fullName,
  'date_of_birth': instance.dateOfBirth.toIso8601String(),
  'gender': instance.gender,
  'blood_type': instance.bloodType,
  'emergency_contact_name': instance.emergencyContactName,
  'emergency_contact_phone': instance.emergencyContactPhone,
  'emergency_contact_relation': instance.emergencyContactRelation,
  'medical_history_privacy': instance.medicalHistoryPrivacy,
  'allowed_pharmacist_ids': instance.allowedPharmacistIds,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
