// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  phoneNumber: json['phone_number'] as String,
  address: json['address'] as String?,
  userType:
      $enumDecodeNullable(_$UserTypeEnumMap, json['user_type']) ??
      UserType.unknown,
  pharmacyId: json['pharmacy_id'] as String?,
  dateOfBirth: json['date_of_birth'] == null
      ? null
      : DateTime.parse(json['date_of_birth'] as String),
  gender: json['gender'] as String?,
  profileImageUrl: json['profile_image_url'] as String?,
  whatsappNumber: json['whatsapp_number'] as String?,
  verificationStatus:
      $enumDecodeNullable(
        _$VerificationStatusEnumMap,
        json['verification_status'],
      ) ??
      VerificationStatus.pending,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  lastLoginAt: json['last_login_at'] == null
      ? null
      : DateTime.parse(json['last_login_at'] as String),
  notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
  themePreference: json['theme_preference'] as String? ?? 'system',
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'phone_number': instance.phoneNumber,
  'address': instance.address,
  'user_type': _$UserTypeEnumMap[instance.userType]!,
  'pharmacy_id': instance.pharmacyId,
  'date_of_birth': instance.dateOfBirth?.toIso8601String(),
  'gender': instance.gender,
  'profile_image_url': instance.profileImageUrl,
  'whatsapp_number': instance.whatsappNumber,
  'verification_status':
      _$VerificationStatusEnumMap[instance.verificationStatus]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'last_login_at': instance.lastLoginAt?.toIso8601String(),
  'notifications_enabled': instance.notificationsEnabled,
  'theme_preference': instance.themePreference,
};

const _$UserTypeEnumMap = {
  UserType.patient: 'patient',
  UserType.pharmacist: 'pharmacist',
  UserType.unknown: 'unknown',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.verified: 'verified',
  VerificationStatus.pending: 'pending',
  VerificationStatus.rejected: 'rejected',
};
