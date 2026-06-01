import 'package:equatable/equatable.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy_verification_document.dart';

enum PharmacyType {
  retail,
  wholesale;

  String get value {
    switch (this) {
      case PharmacyType.retail:
        return 'retail';
      case PharmacyType.wholesale:
        return 'wholesale';
    }
  }

  String get displayName {
    switch (this) {
      case PharmacyType.retail:
        return 'Retail Pharmacy';
      case PharmacyType.wholesale:
        return 'Wholesale Pharmacy';
    }
  }

  static PharmacyType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'retail':
        return PharmacyType.retail;
      case 'wholesale':
        return PharmacyType.wholesale;
      default:
        return PharmacyType.retail;
    }
  }
}

class OperatingHours extends Equatable {
  final String
  dayOfWeek; // monday | tuesday | wednesday | thursday | friday | saturday | sunday
  final String openTime; // HH:mm format
  final String closeTime; // HH:mm format
  final bool isClosed; // If closed on this day

  const OperatingHours({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  @override
  List<Object?> get props => [dayOfWeek, openTime, closeTime, isClosed];

  OperatingHours copyWith({
    String? dayOfWeek,
    String? openTime,
    String? closeTime,
    bool? isClosed,
  }) {
    return OperatingHours(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}

class GeoLocation extends Equatable {
  final double latitude;
  final double longitude;
  final String? address; // Human readable address

  const GeoLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];

  GeoLocation copyWith({double? latitude, double? longitude, String? address}) {
    return GeoLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }
}

class PharmacyRating extends Equatable {
  final double averageRating; // 1.0 - 5.0
  final int totalReviews;
  final Map<String, int>
  ratingBreakdown; // {"1": 5, "2": 3, "3": 10, "4": 20, "5": 15}

  const PharmacyRating({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.ratingBreakdown = const {},
  });

  @override
  List<Object?> get props => [averageRating, totalReviews, ratingBreakdown];

  PharmacyRating copyWith({
    double? averageRating,
    int? totalReviews,
    Map<String, int>? ratingBreakdown,
  }) {
    return PharmacyRating(
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      ratingBreakdown: ratingBreakdown ?? this.ratingBreakdown,
    );
  }
}

class Pharmacy extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String businessEmail; // Separate from owner email
  final PharmacyType type; // retail | wholesale
  final String? licenseNumber;
  final String? description;
  final String? frontalImageUrl; // Main pharmacy image
  final String? interiorImageUrl; // Interior view
  final String? logoUrl; // Pharmacy logo
  final List<String> licenseDocumentUrls; // License verification docs
  final String? pcnRegistrationNumber;
  final String? pcnAgency;
  final Map<String, PharmacyVerificationDocument> verificationDocuments;
  final List<OperatingHours> operatingHours;
  final GeoLocation location; // lat/lng coordinates
  final PharmacyRating rating; // Average rating and count
  final bool isVerified; // Admin verified
  final bool? isRegistrationComplete; // null = legacy/complete; false = skipped placeholder
  final bool isFeatured; // Featured pharmacy
  final List<String> employeeIds; // Pharmacist IDs
  final DateTime createdAt;
  final DateTime updatedAt;

  const Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.businessEmail,
    this.type = PharmacyType.retail,
    this.licenseNumber,
    this.description,
    this.frontalImageUrl,
    this.interiorImageUrl,
    this.logoUrl,
    this.licenseDocumentUrls = const [],
    this.pcnRegistrationNumber,
    this.pcnAgency,
    this.verificationDocuments = const {},
    this.operatingHours = const [],
    required this.location,
    this.rating = const PharmacyRating(),
    this.isVerified = false,
    this.isRegistrationComplete,
    this.isFeatured = false,
    this.employeeIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Existing businesses without this field are treated as fully registered.
  bool get hasCompletedRegistration => isRegistrationComplete ?? true;

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    phoneNumber,
    email,
    businessEmail,
    type,
    licenseNumber,
    description,
    frontalImageUrl,
    interiorImageUrl,
    logoUrl,
    licenseDocumentUrls,
    pcnRegistrationNumber,
    pcnAgency,
    verificationDocuments,
    operatingHours,
    location,
    rating,
    isVerified,
    isRegistrationComplete,
    isFeatured,
    employeeIds,
    createdAt,
    updatedAt,
  ];

  Pharmacy copyWith({
    String? id,
    String? name,
    String? address,
    String? phoneNumber,
    String? email,
    String? businessEmail,
    PharmacyType? type,
    String? licenseNumber,
    String? description,
    String? frontalImageUrl,
    String? interiorImageUrl,
    String? logoUrl,
    List<String>? licenseDocumentUrls,
    String? pcnRegistrationNumber,
    String? pcnAgency,
    Map<String, PharmacyVerificationDocument>? verificationDocuments,
    List<OperatingHours>? operatingHours,
    GeoLocation? location,
    PharmacyRating? rating,
    bool? isVerified,
    bool? isRegistrationComplete,
    bool? isFeatured,
    List<String>? employeeIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pharmacy(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      businessEmail: businessEmail ?? this.businessEmail,
      type: type ?? this.type,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      description: description ?? this.description,
      frontalImageUrl: frontalImageUrl ?? this.frontalImageUrl,
      interiorImageUrl: interiorImageUrl ?? this.interiorImageUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      licenseDocumentUrls: licenseDocumentUrls ?? this.licenseDocumentUrls,
      pcnRegistrationNumber:
          pcnRegistrationNumber ?? this.pcnRegistrationNumber,
      pcnAgency: pcnAgency ?? this.pcnAgency,
      verificationDocuments:
          verificationDocuments ?? this.verificationDocuments,
      operatingHours: operatingHours ?? this.operatingHours,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      isRegistrationComplete:
          isRegistrationComplete ?? this.isRegistrationComplete,
      isFeatured: isFeatured ?? this.isFeatured,
      employeeIds: employeeIds ?? this.employeeIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
