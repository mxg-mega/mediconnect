import 'package:equatable/equatable.dart';

enum MedicalHistoryPrivacyLevel {
  private,
  sharedWithPharmacists,
  public;

  String get value {
    switch (this) {
      case MedicalHistoryPrivacyLevel.private:
        return 'private';
      case MedicalHistoryPrivacyLevel.sharedWithPharmacists:
        return 'shared_with_pharmacists';
      case MedicalHistoryPrivacyLevel.public:
        return 'public';
    }
  }

  String get displayName {
    switch (this) {
      case MedicalHistoryPrivacyLevel.private:
        return 'Private';
      case MedicalHistoryPrivacyLevel.sharedWithPharmacists:
        return 'Shared with Pharmacists';
      case MedicalHistoryPrivacyLevel.public:
        return 'Public';
    }
  }

  static MedicalHistoryPrivacyLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'private':
        return MedicalHistoryPrivacyLevel.private;
      case 'shared_with_pharmacists':
        return MedicalHistoryPrivacyLevel.sharedWithPharmacists;
      case 'public':
        return MedicalHistoryPrivacyLevel.public;
      default:
        return MedicalHistoryPrivacyLevel.private;
    }
  }
}

class PatientProfile extends Equatable {
  final String id; // Same as User.id
  final String userId; // Foreign key to User
  final String fullName; // Computed from firstName + lastName
  final DateTime dateOfBirth;
  final String gender; // male | female | other
  final String? bloodType; // A+ | A- | B+ | B- | AB+ | AB- | O+ | O-
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  final MedicalHistoryPrivacyLevel
  medicalHistoryPrivacy; // private | shared_with_pharmacists | public
  final List<String>
  allowedPharmacistIds; // Pharmacists who can view medical history
  final DateTime createdAt;
  final DateTime updatedAt;

  const PatientProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    this.bloodType,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.medicalHistoryPrivacy = MedicalHistoryPrivacyLevel.private,
    this.allowedPharmacistIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    fullName,
    dateOfBirth,
    gender,
    bloodType,
    emergencyContactName,
    emergencyContactPhone,
    emergencyContactRelation,
    medicalHistoryPrivacy,
    allowedPharmacistIds,
    createdAt,
    updatedAt,
  ];

  PatientProfile copyWith({
    String? id,
    String? userId,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    MedicalHistoryPrivacyLevel? medicalHistoryPrivacy,
    List<String>? allowedPharmacistIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation:
          emergencyContactRelation ?? this.emergencyContactRelation,
      medicalHistoryPrivacy:
          medicalHistoryPrivacy ?? this.medicalHistoryPrivacy,
      allowedPharmacistIds: allowedPharmacistIds ?? this.allowedPharmacistIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
