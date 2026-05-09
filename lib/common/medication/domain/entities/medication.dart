import 'package:equatable/equatable.dart';

class MedicationRating extends Equatable {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> starBreakdown; // {5: 180, 4: 50, ...}

  const MedicationRating({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.starBreakdown = const {},
  });

  @override
  List<Object?> get props => [averageRating, totalReviews, starBreakdown];

  MedicationRating copyWith({
    double? averageRating,
    int? totalReviews,
    Map<int, int>? starBreakdown,
  }) {
    return MedicationRating(
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      starBreakdown: starBreakdown ?? this.starBreakdown,
    );
  }
}

class Medication extends Equatable {
  final String id;
  final String name; // Generic name or combined name
  final String manufacturer;
  final String? brandName; // e.g. "Amoxil"
  final String dosage; // e.g. "500 mg"
  final String packaging; // e.g. "10 capsules"
  final String description;
  final String benefitsAndUses;
  final String? imageUrl;
  final MedicationRating rating; // Nested rating object
  final List<String> variantIds; // IDs of other dosages/sizes
  final List<String> similarProductIds;

  const Medication({
    required this.id,
    required this.name,
    required this.manufacturer,
    this.brandName,
    required this.dosage,
    required this.packaging,
    required this.description,
    required this.benefitsAndUses,
    this.imageUrl,
    this.rating = const MedicationRating(),
    this.variantIds = const [],
    this.similarProductIds = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        manufacturer,
        brandName,
        dosage,
        packaging,
        description,
        benefitsAndUses,
        imageUrl,
        rating,
        variantIds,
        similarProductIds,
      ];

  Medication copyWith({
    String? id,
    String? name,
    String? manufacturer,
    String? brandName,
    String? dosage,
    String? packaging,
    String? description,
    String? benefitsAndUses,
    String? imageUrl,
    MedicationRating? rating,
    List<String>? variantIds,
    List<String>? similarProductIds,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      manufacturer: manufacturer ?? this.manufacturer,
      brandName: brandName ?? this.brandName,
      dosage: dosage ?? this.dosage,
      packaging: packaging ?? this.packaging,
      description: description ?? this.description,
      benefitsAndUses: benefitsAndUses ?? this.benefitsAndUses,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      variantIds: variantIds ?? this.variantIds,
      similarProductIds: similarProductIds ?? this.similarProductIds,
    );
  }
}

class MedicationReview extends Equatable {
  final String id;
  final String medicationId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final DateTime createdAt;
  final String comment;
  final int helpfulCount;

  const MedicationReview({
    required this.id,
    required this.medicationId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.createdAt,
    required this.comment,
    this.helpfulCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        medicationId,
        userId,
        userName,
        userAvatar,
        rating,
        createdAt,
        comment,
        helpfulCount,
      ];

  MedicationReview copyWith({
    String? id,
    String? medicationId,
    String? userId,
    String? userName,
    String? userAvatar,
    double? rating,
    DateTime? createdAt,
    String? comment,
    int? helpfulCount,
  }) {
    return MedicationReview(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      comment: comment ?? this.comment,
      helpfulCount: helpfulCount ?? this.helpfulCount,
    );
  }
}
