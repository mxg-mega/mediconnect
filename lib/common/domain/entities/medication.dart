import 'package:equatable/equatable.dart';

class MedicationRating extends Equatable {
  final double averageRating; // 1.0 - 5.0
  final int totalReviews;
  final Map<String, int>
  ratingBreakdown; // {"1": 5, "2": 3, "3": 10, "4": 20, "5": 15}

  const MedicationRating({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.ratingBreakdown = const {},
  });

  @override
  List<Object?> get props => [averageRating, totalReviews, ratingBreakdown];

  MedicationRating copyWith({
    double? averageRating,
    int? totalReviews,
    Map<String, int>? ratingBreakdown,
  }) {
    return MedicationRating(
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      ratingBreakdown: ratingBreakdown ?? this.ratingBreakdown,
    );
  }
}

class Medication extends Equatable {
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
  final MedicationRating rating; // Average rating
  final List<String> alternativeIds; // Alternative medications
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medication({
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
    this.rating = const MedicationRating(),
    this.alternativeIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

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

  Medication copyWith({
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
    MedicationRating? rating,
    List<String>? alternativeIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
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
