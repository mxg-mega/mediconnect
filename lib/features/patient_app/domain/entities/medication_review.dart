import 'package:equatable/equatable.dart';

class MedicationReview extends Equatable {
  final String id; // Primary key
  final String patientId; // Foreign key to User (reviewer)
  final String medicationId; // Foreign key to Medication
  final int rating; // 1-5 stars
  final String? reviewText; // Optional review text
  final int effectivenessRating; // 1-5 rating
  final List<String> sideEffectsExperienced; // Side effects they had
  final String? conditionTreated; // What they used it for
  final DateTime submittedAt;
  final int helpfulVotes; // Count of helpful votes
  final bool isVerifiedPurchase; // Verified they bought it
  final String? dosageUsed; // Dosage they took
  final int durationOfUse; // Days/weeks used

  const MedicationReview({
    required this.id,
    required this.patientId,
    required this.medicationId,
    required this.rating,
    this.reviewText,
    required this.effectivenessRating,
    this.sideEffectsExperienced = const [],
    this.conditionTreated,
    required this.submittedAt,
    this.helpfulVotes = 0,
    this.isVerifiedPurchase = false,
    this.dosageUsed,
    this.durationOfUse = 0,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    medicationId,
    rating,
    reviewText,
    effectivenessRating,
    sideEffectsExperienced,
    conditionTreated,
    submittedAt,
    helpfulVotes,
    isVerifiedPurchase,
    dosageUsed,
    durationOfUse,
  ];

  MedicationReview copyWith({
    String? id,
    String? patientId,
    String? medicationId,
    int? rating,
    String? reviewText,
    int? effectivenessRating,
    List<String>? sideEffectsExperienced,
    String? conditionTreated,
    DateTime? submittedAt,
    int? helpfulVotes,
    bool? isVerifiedPurchase,
    String? dosageUsed,
    int? durationOfUse,
  }) {
    return MedicationReview(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicationId: medicationId ?? this.medicationId,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      effectivenessRating: effectivenessRating ?? this.effectivenessRating,
      sideEffectsExperienced:
          sideEffectsExperienced ?? this.sideEffectsExperienced,
      conditionTreated: conditionTreated ?? this.conditionTreated,
      submittedAt: submittedAt ?? this.submittedAt,
      helpfulVotes: helpfulVotes ?? this.helpfulVotes,
      isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
      dosageUsed: dosageUsed ?? this.dosageUsed,
      durationOfUse: durationOfUse ?? this.durationOfUse,
    );
  }
}
