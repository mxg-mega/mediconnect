// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperatingHoursModel _$OperatingHoursModelFromJson(Map<String, dynamic> json) =>
    OperatingHoursModel(
      dayOfWeek: json['day_of_week'] as String,
      openTime: json['open_time'] as String,
      closeTime: json['close_time'] as String,
      isClosed: json['is_closed'] as bool? ?? false,
    );

Map<String, dynamic> _$OperatingHoursModelToJson(
  OperatingHoursModel instance,
) => <String, dynamic>{
  'day_of_week': instance.dayOfWeek,
  'open_time': instance.openTime,
  'close_time': instance.closeTime,
  'is_closed': instance.isClosed,
};

GeoLocationModel _$GeoLocationModelFromJson(Map<String, dynamic> json) =>
    GeoLocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$GeoLocationModelToJson(GeoLocationModel instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
    };

PharmacyRatingModel _$PharmacyRatingModelFromJson(Map<String, dynamic> json) =>
    PharmacyRatingModel(
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      ratingBreakdown:
          (json['rating_breakdown'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$PharmacyRatingModelToJson(
  PharmacyRatingModel instance,
) => <String, dynamic>{
  'average_rating': instance.averageRating,
  'total_reviews': instance.totalReviews,
  'rating_breakdown': instance.ratingBreakdown,
};

PharmacyModel _$PharmacyModelFromJson(
  Map<String, dynamic> json,
) => PharmacyModel(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  phoneNumber: json['phone_number'] as String,
  email: json['email'] as String,
  businessEmail: json['business_email'] as String,
  type: json['type'] as String? ?? 'retail',
  licenseNumber: json['license_number'] as String?,
  description: json['description'] as String?,
  frontalImageUrl: json['frontal_image_url'] as String?,
  interiorImageUrl: json['interior_image_url'] as String?,
  logoUrl: json['logo_url'] as String?,
  licenseDocumentUrls:
      (json['license_document_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  pcnRegistrationNumber: json['pcn_registration_number'] as String?,
  operatingHours:
      (json['operating_hours'] as List<dynamic>?)
          ?.map((e) => OperatingHoursModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  location: GeoLocationModel.fromJson(json['location'] as Map<String, dynamic>),
  rating: json['rating'] == null
      ? const PharmacyRatingModel()
      : PharmacyRatingModel.fromJson(json['rating'] as Map<String, dynamic>),
  isVerified: json['is_verified'] as bool? ?? false,
  isFeatured: json['is_featured'] as bool? ?? false,
  employeeIds:
      (json['employee_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PharmacyModelToJson(PharmacyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'business_email': instance.businessEmail,
      'type': instance.type,
      'license_number': instance.licenseNumber,
      'description': instance.description,
      'frontal_image_url': instance.frontalImageUrl,
      'interior_image_url': instance.interiorImageUrl,
      'logo_url': instance.logoUrl,
      'license_document_urls': instance.licenseDocumentUrls,
      'pcn_registration_number': instance.pcnRegistrationNumber,
      'operating_hours': instance.operatingHours,
      'location': instance.location,
      'rating': instance.rating,
      'is_verified': instance.isVerified,
      'is_featured': instance.isFeatured,
      'employee_ids': instance.employeeIds,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
