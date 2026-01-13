import 'package:equatable/equatable.dart';

class ServiceAspects extends Equatable {
  final int helpfulness; // 1-5 rating
  final int availability; // 1-5 rating
  final int cleanliness; // 1-5 rating
  final int pricing; // 1-5 rating
  final int staffKnowledge; // 1-5 rating

  const ServiceAspects({
    required this.helpfulness,
    required this.availability,
    required this.cleanliness,
    required this.pricing,
    required this.staffKnowledge,
  });

  double get averageRating {
    return (helpfulness +
            availability +
            cleanliness +
            pricing +
            staffKnowledge) /
        5.0;
  }

  @override
  List<Object?> get props => [
    helpfulness,
    availability,
    cleanliness,
    pricing,
    staffKnowledge,
  ];

  ServiceAspects copyWith({
    int? helpfulness,
    int? availability,
    int? cleanliness,
    int? pricing,
    int? staffKnowledge,
  }) {
    return ServiceAspects(
      helpfulness: helpfulness ?? this.helpfulness,
      availability: availability ?? this.availability,
      cleanliness: cleanliness ?? this.cleanliness,
      pricing: pricing ?? this.pricing,
      staffKnowledge: staffKnowledge ?? this.staffKnowledge,
    );
  }
}

class PharmacyReview extends Equatable {
  final String id; // Primary key
  final String patientId; // Foreign key to User (reviewer)
  final String pharmacyId; // Foreign key to Pharmacy
  final int rating; // 1-5 stars
  final String? reviewText; // Optional review text
  final ServiceAspects serviceAspects; // Detailed ratings
  final DateTime submittedAt;
  final int helpfulVotes; // Count of helpful votes
  final bool isVerified; // Verified purchase
  final String? visitDate; // When they visited

  const PharmacyReview({
    required this.id,
    required this.patientId,
    required this.pharmacyId,
    required this.rating,
    this.reviewText,
    required this.serviceAspects,
    required this.submittedAt,
    this.helpfulVotes = 0,
    this.isVerified = false,
    this.visitDate,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    pharmacyId,
    rating,
    reviewText,
    serviceAspects,
    submittedAt,
    helpfulVotes,
    isVerified,
    visitDate,
  ];

  PharmacyReview copyWith({
    String? id,
    String? patientId,
    String? pharmacyId,
    int? rating,
    String? reviewText,
    ServiceAspects? serviceAspects,
    DateTime? submittedAt,
    int? helpfulVotes,
    bool? isVerified,
    String? visitDate,
  }) {
    return PharmacyReview(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      serviceAspects: serviceAspects ?? this.serviceAspects,
      submittedAt: submittedAt ?? this.submittedAt,
      helpfulVotes: helpfulVotes ?? this.helpfulVotes,
      isVerified: isVerified ?? this.isVerified,
      visitDate: visitDate ?? this.visitDate,
    );
  }
}
