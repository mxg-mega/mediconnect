// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicationRatingModel _$MedicationRatingModelFromJson(
  Map<String, dynamic> json,
) => MedicationRatingModel(
  averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
  totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
  ratingBreakdown:
      (json['rating_breakdown'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
);

Map<String, dynamic> _$MedicationRatingModelToJson(
  MedicationRatingModel instance,
) => <String, dynamic>{
  'average_rating': instance.averageRating,
  'total_reviews': instance.totalReviews,
  'rating_breakdown': instance.ratingBreakdown,
};

MedicationModel _$MedicationModelFromJson(Map<String, dynamic> json) =>
    MedicationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      brandNames: (json['brand_names'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      category: json['category'] as String,
      manufacturer: json['manufacturer'] as String,
      dosageForms: (json['dosage_forms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      strengths: (json['strengths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      usageInstructions: json['usage_instructions'] as String?,
      sideEffects:
          (json['side_effects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      contraindications:
          (json['contraindications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      prescriptionRequired: json['prescription_required'] as bool? ?? false,
      imageUrls:
          (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: json['rating'] == null
          ? const MedicationRatingModel()
          : MedicationRatingModel.fromJson(
              json['rating'] as Map<String, dynamic>,
            ),
      alternativeIds:
          (json['alternative_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MedicationModelToJson(MedicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand_names': instance.brandNames,
      'category': instance.category,
      'manufacturer': instance.manufacturer,
      'dosage_forms': instance.dosageForms,
      'strengths': instance.strengths,
      'description': instance.description,
      'usage_instructions': instance.usageInstructions,
      'side_effects': instance.sideEffects,
      'contraindications': instance.contraindications,
      'prescription_required': instance.prescriptionRequired,
      'image_urls': instance.imageUrls,
      'rating': instance.rating,
      'alternative_ids': instance.alternativeIds,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
