import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/features/patient_app/domain/entities/patient_profile.dart';

part 'patient_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PatientProfileModel extends Equatable {
  final String id; // Same as User.id
  final String userId; // Foreign key to User
  final String fullName; // Computed from firstName + lastName
  final DateTime dateOfBirth;
  final String gender; // male | female | other
  final String? bloodType; // A+ | A- | B+ | B- | AB+ | AB- | O+ | O-
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  final String
  medicalHistoryPrivacy; // private | shared_with_pharmacists | public
  final List<String>
  allowedPharmacistIds; // Pharmacists who can view medical history
  final DateTime createdAt;
  final DateTime updatedAt;

  const PatientProfileModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    this.bloodType,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelation,
    this.medicalHistoryPrivacy = 'private',
    this.allowedPharmacistIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) =>
      _$PatientProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatientProfileModelToJson(this);

  factory PatientProfileModel.fromEntity(PatientProfile entity) {
    return PatientProfileModel(
      id: entity.id,
      userId: entity.userId,
      fullName: entity.fullName,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      bloodType: entity.bloodType,
      emergencyContactName: entity.emergencyContactName,
      emergencyContactPhone: entity.emergencyContactPhone,
      emergencyContactRelation: entity.emergencyContactRelation,
      medicalHistoryPrivacy: entity.medicalHistoryPrivacy.value,
      allowedPharmacistIds: entity.allowedPharmacistIds,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  PatientProfile toEntity() {
    return PatientProfile(
      id: id,
      userId: userId,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      bloodType: bloodType,
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation,
      medicalHistoryPrivacy: MedicalHistoryPrivacyLevel.fromString(
        medicalHistoryPrivacy,
      ),
      allowedPharmacistIds: allowedPharmacistIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

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

  PatientProfileModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? medicalHistoryPrivacy,
    List<String>? allowedPharmacistIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientProfileModel(
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
