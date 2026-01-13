import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/common/domain/entities/medication.dart';

part 'medication_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MedicationRatingModel extends Equatable {
  final double averageRating; // 1.0 - 5.0
  final int totalReviews;
  final Map<String, int>
  ratingBreakdown; // {"1": 5, "2": 3, "3": 10, "4": 20, "5": 15}

  const MedicationRatingModel({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.ratingBreakdown = const {},
  });

  factory MedicationRatingModel.fromJson(Map<String, dynamic> json) =>
      _$MedicationRatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationRatingModelToJson(this);

  factory MedicationRatingModel.fromEntity(MedicationRating entity) {
    return MedicationRatingModel(
      averageRating: entity.averageRating,
      totalReviews: entity.totalReviews,
      ratingBreakdown: entity.ratingBreakdown,
    );
  }

  MedicationRating toEntity() {
    return MedicationRating(
      averageRating: averageRating,
      totalReviews: totalReviews,
      ratingBreakdown: ratingBreakdown,
    );
  }

  @override
  List<Object?> get props => [averageRating, totalReviews, ratingBreakdown];

  MedicationRatingModel copyWith({
    double? averageRating,
    int? totalReviews,
    Map<String, int>? ratingBreakdown,
  }) {
    return MedicationRatingModel(
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      ratingBreakdown: ratingBreakdown ?? this.ratingBreakdown,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MedicationModel extends Equatable {
  final String id; // Primary key
  final String name; // Generic name
  final List<String> brandNames; // Array of brand names
  final String category; // Therapeutic class
  final String manufacturer; // Manufacturer name
  final List<String> dosageForms; // tablet | capsule | syrup | injection
  final List<String> strengths; // 500mg | 10ml | etc.
  final String? description; // Drug description
  final String? usageInstructions; // How to use
  final List<String> sideEffects; // Common side effects
  final List<String> contraindications; // When not to use
  final bool prescriptionRequired; // Prescription needed
  final List<String> imageUrls; // Product images
  final MedicationRatingModel rating; // Average rating
  final List<String> alternativeIds; // Alternative medications
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicationModel({
    required this.id,
    required this.name,
    required this.brandNames,
    required this.category,
    required this.manufacturer,
    required this.dosageForms,
    required this.strengths,
    this.description,
    this.usageInstructions,
    this.sideEffects = const [],
    this.contraindications = const [],
    this.prescriptionRequired = false,
    this.imageUrls = const [],
    this.rating = const MedicationRatingModel(),
    this.alternativeIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      _$MedicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationModelToJson(this);

  factory MedicationModel.fromEntity(Medication entity) {
    return MedicationModel(
      id: entity.id,
      name: entity.name,
      brandNames: entity.brandNames,
      category: entity.category,
      manufacturer: entity.manufacturer,
      dosageForms: entity.dosageForms,
      strengths: entity.strengths,
      description: entity.description,
      usageInstructions: entity.usageInstructions,
      sideEffects: entity.sideEffects,
      contraindications: entity.contraindications,
      prescriptionRequired: entity.prescriptionRequired,
      imageUrls: entity.imageUrls,
      rating: MedicationRatingModel.fromEntity(entity.rating),
      alternativeIds: entity.alternativeIds,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Medication toEntity() {
    return Medication(
      id: id,
      name: name,
      brandNames: brandNames,
      category: category,
      manufacturer: manufacturer,
      dosageForms: dosageForms,
      strengths: strengths,
      description: description,
      usageInstructions: usageInstructions,
      sideEffects: sideEffects,
      contraindications: contraindications,
      prescriptionRequired: prescriptionRequired,
      imageUrls: imageUrls,
      rating: rating.toEntity(),
      alternativeIds: alternativeIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    brandNames,
    category,
    manufacturer,
    dosageForms,
    strengths,
    description,
    usageInstructions,
    sideEffects,
    contraindications,
    prescriptionRequired,
    imageUrls,
    rating,
    alternativeIds,
    createdAt,
    updatedAt,
  ];

  MedicationModel copyWith({
    String? id,
    String? name,
    List<String>? brandNames,
    String? category,
    String? manufacturer,
    List<String>? dosageForms,
    List<String>? strengths,
    String? description,
    String? usageInstructions,
    List<String>? sideEffects,
    List<String>? contraindications,
    bool? prescriptionRequired,
    List<String>? imageUrls,
    MedicationRatingModel? rating,
    List<String>? alternativeIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brandNames: brandNames ?? this.brandNames,
      category: category ?? this.category,
      manufacturer: manufacturer ?? this.manufacturer,
      dosageForms: dosageForms ?? this.dosageForms,
      strengths: strengths ?? this.strengths,
      description: description ?? this.description,
      usageInstructions: usageInstructions ?? this.usageInstructions,
      sideEffects: sideEffects ?? this.sideEffects,
      contraindications: contraindications ?? this.contraindications,
      prescriptionRequired: prescriptionRequired ?? this.prescriptionRequired,
      imageUrls: imageUrls ?? this.imageUrls,
      rating: rating ?? this.rating,
      alternativeIds: alternativeIds ?? this.alternativeIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
