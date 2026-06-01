import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy_verification_document.dart';
import 'package:mediconnect/common/auth/domain/utils/pharmacy_verification_docs.dart';

part 'pharmacy_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class OperatingHoursModel extends Equatable {
  final String
  dayOfWeek; // monday | tuesday | wednesday | thursday | friday | saturday | sunday
  final String openTime; // HH:mm format
  final String closeTime; // HH:mm format
  final bool isClosed; // If closed on this day

  const OperatingHoursModel({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });

  factory OperatingHoursModel.fromJson(Map<String, dynamic> json) =>
      _$OperatingHoursModelFromJson(json);

  Map<String, dynamic> toJson() => _$OperatingHoursModelToJson(this);

  factory OperatingHoursModel.fromEntity(OperatingHours entity) {
    return OperatingHoursModel(
      dayOfWeek: entity.dayOfWeek,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      isClosed: entity.isClosed,
    );
  }

  OperatingHours toEntity() {
    return OperatingHours(
      dayOfWeek: dayOfWeek,
      openTime: openTime,
      closeTime: closeTime,
      isClosed: isClosed,
    );
  }

  @override
  List<Object?> get props => [dayOfWeek, openTime, closeTime, isClosed];

  OperatingHoursModel copyWith({
    String? dayOfWeek,
    String? openTime,
    String? closeTime,
    bool? isClosed,
  }) {
    return OperatingHoursModel(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GeoLocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final String? address; // Human readable address

  const GeoLocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) =>
      _$GeoLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeoLocationModelToJson(this);

  factory GeoLocationModel.fromEntity(GeoLocation entity) {
    return GeoLocationModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
    );
  }

  GeoLocation toEntity() {
    return GeoLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, address];

  GeoLocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return GeoLocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PharmacyRatingModel extends Equatable {
  final double averageRating; // 1.0 - 5.0
  final int totalReviews;
  final Map<String, int>
  ratingBreakdown; // {"1": 5, "2": 3, "3": 10, "4": 20, "5": 15}

  const PharmacyRatingModel({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.ratingBreakdown = const {},
  });

  factory PharmacyRatingModel.fromJson(Map<String, dynamic> json) =>
      _$PharmacyRatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyRatingModelToJson(this);

  factory PharmacyRatingModel.fromEntity(PharmacyRating entity) {
    return PharmacyRatingModel(
      averageRating: entity.averageRating,
      totalReviews: entity.totalReviews,
      ratingBreakdown: entity.ratingBreakdown,
    );
  }

  PharmacyRating toEntity() {
    return PharmacyRating(
      averageRating: averageRating,
      totalReviews: totalReviews,
      ratingBreakdown: ratingBreakdown,
    );
  }

  @override
  List<Object?> get props => [averageRating, totalReviews, ratingBreakdown];

  PharmacyRatingModel copyWith({
    double? averageRating,
    int? totalReviews,
    Map<String, int>? ratingBreakdown,
  }) {
    return PharmacyRatingModel(
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      ratingBreakdown: ratingBreakdown ?? this.ratingBreakdown,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PharmacyModel extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String email;
  final String businessEmail; // Separate from owner email
  final String type; // retail | wholesale
  final String? licenseNumber;
  final String? description;
  final String? frontalImageUrl; // Main pharmacy image
  final String? interiorImageUrl; // Interior view
  final String? logoUrl; // Pharmacy logo
  final List<String> licenseDocumentUrls; // License verification docs
  final String? pcnRegistrationNumber;
  final String? pcnAgency;
  final Map<String, PharmacyVerificationDocument> verificationDocuments;
  final List<OperatingHoursModel> operatingHours;
  final GeoLocationModel location; // lat/lng coordinates
  final PharmacyRatingModel rating; // Average rating and count
  final bool isVerified; // Admin verified
  final bool? isRegistrationComplete; // null = legacy/complete; false = skipped placeholder
  final bool isFeatured; // Featured pharmacy
  final List<String> employeeIds; // Pharmacist IDs
  final DateTime createdAt;
  final DateTime updatedAt;

  const PharmacyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.businessEmail,
    this.type = 'retail',
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
    this.rating = const PharmacyRatingModel(),
    this.isVerified = false,
    this.isRegistrationComplete,
    this.isFeatured = false,
    this.employeeIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Existing businesses without this field are treated as fully registered.
  bool get hasCompletedRegistration => isRegistrationComplete ?? true;

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    final model = _$PharmacyModelFromJson(json);
    return model.copyWith(
      pcnAgency: json['pcn_agency'] as String? ?? model.pcnAgency,
      verificationDocuments: parseVerificationDocumentsMap(
        json['verification_documents'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final data = _$PharmacyModelToJson(this);
    if (pcnAgency != null && pcnAgency!.isNotEmpty) {
      data['pcn_agency'] = pcnAgency;
    }
    if (verificationDocuments.isNotEmpty) {
      data['verification_documents'] =
          verificationDocumentsToJson(verificationDocuments);
    }
    return data;
  }

  factory PharmacyModel.fromEntity(Pharmacy entity) {
    return PharmacyModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      phoneNumber: entity.phoneNumber,
      email: entity.email,
      businessEmail: entity.businessEmail,
      type: entity.type.value,
      licenseNumber: entity.licenseNumber,
      description: entity.description,
      frontalImageUrl: entity.frontalImageUrl,
      interiorImageUrl: entity.interiorImageUrl,
      logoUrl: entity.logoUrl,
      licenseDocumentUrls: entity.licenseDocumentUrls,
      pcnRegistrationNumber: entity.pcnRegistrationNumber,
      pcnAgency: entity.pcnAgency,
      verificationDocuments: entity.verificationDocuments,
      operatingHours: entity.operatingHours
          .map((e) => OperatingHoursModel.fromEntity(e))
          .toList(),
      location: GeoLocationModel.fromEntity(entity.location),
      rating: PharmacyRatingModel.fromEntity(entity.rating),
      isVerified: entity.isVerified,
      isRegistrationComplete: entity.isRegistrationComplete,
      isFeatured: entity.isFeatured,
      employeeIds: entity.employeeIds,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Pharmacy toEntity() {
    return Pharmacy(
      id: id,
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      email: email,
      businessEmail: businessEmail,
      type: PharmacyType.fromString(type),
      licenseNumber: licenseNumber,
      description: description,
      frontalImageUrl: frontalImageUrl,
      interiorImageUrl: interiorImageUrl,
      logoUrl: logoUrl,
      licenseDocumentUrls: licenseDocumentUrls,
      pcnRegistrationNumber: pcnRegistrationNumber,
      pcnAgency: pcnAgency,
      verificationDocuments: verificationDocuments,
      operatingHours: operatingHours.map((e) => e.toEntity()).toList(),
      location: location.toEntity(),
      rating: rating.toEntity(),
      isVerified: isVerified,
      isRegistrationComplete: isRegistrationComplete,
      isFeatured: isFeatured,
      employeeIds: employeeIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

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

  PharmacyModel copyWith({
    String? id,
    String? name,
    String? address,
    String? phoneNumber,
    String? email,
    String? businessEmail,
    String? type,
    String? licenseNumber,
    String? description,
    String? frontalImageUrl,
    String? interiorImageUrl,
    String? logoUrl,
    List<String>? licenseDocumentUrls,
    String? pcnRegistrationNumber,
    String? pcnAgency,
    Map<String, PharmacyVerificationDocument>? verificationDocuments,
    List<OperatingHoursModel>? operatingHours,
    GeoLocationModel? location,
    PharmacyRatingModel? rating,
    bool? isVerified,
    bool? isRegistrationComplete,
    bool? isFeatured,
    List<String>? employeeIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PharmacyModel(
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
