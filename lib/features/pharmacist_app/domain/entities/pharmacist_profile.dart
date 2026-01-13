import 'package:equatable/equatable.dart';

class PharmacistProfile extends Equatable {
  final String id; // Same as User.id
  final String userId; // Foreign key to User
  final String pharmacyId; // Foreign key to Pharmacy
  final String fullName; // Computed from firstName + lastName
  final String licenseNumber; // Pharmacist license
  final String? specialization; // Specialization area
  final int yearsOfExperience; // Years in practice
  final List<String> certifications; // Additional certifications
  final String? bio; // Professional bio
  final List<String> languages; // Languages spoken
  final bool isAvailableForConsultation; // Available for patient consultations
  final DateTime createdAt;
  final DateTime updatedAt;

  const PharmacistProfile({
    required this.id,
    required this.userId,
    required this.pharmacyId,
    required this.fullName,
    required this.licenseNumber,
    this.specialization,
    this.yearsOfExperience = 0,
    this.certifications = const [],
    this.bio,
    this.languages = const [],
    this.isAvailableForConsultation = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    pharmacyId,
    fullName,
    licenseNumber,
    specialization,
    yearsOfExperience,
    certifications,
    bio,
    languages,
    isAvailableForConsultation,
    createdAt,
    updatedAt,
  ];

  PharmacistProfile copyWith({
    String? id,
    String? userId,
    String? pharmacyId,
    String? fullName,
    String? licenseNumber,
    String? specialization,
    int? yearsOfExperience,
    List<String>? certifications,
    String? bio,
    List<String>? languages,
    bool? isAvailableForConsultation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PharmacistProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      fullName: fullName ?? this.fullName,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      specialization: specialization ?? this.specialization,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      certifications: certifications ?? this.certifications,
      bio: bio ?? this.bio,
      languages: languages ?? this.languages,
      isAvailableForConsultation:
          isAvailableForConsultation ?? this.isAvailableForConsultation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
