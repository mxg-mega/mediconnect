import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/core/config/app_config.dart';

part 'user_model.g.dart';

enum UserType {
  patient,
  pharmacist,
  unknown;

  String get displayName {
    switch (this) {
      case UserType.patient:
        return 'Patient';
      case UserType.pharmacist:
        return 'Pharmacist';
      case UserType.unknown:
        return 'Unknown';
    }
  }

  String get value {
    switch (this) {
      case UserType.patient:
        return AppConfig.userTypePatient;
      case UserType.pharmacist:
        return AppConfig.userTypePharmacist;
      case UserType.unknown:
        return 'unknown';
    }
  }

  static UserType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'patient':
        return UserType.patient;
      case 'pharmacist':
        return UserType.pharmacist;
      default:
        return UserType.unknown;
    }
  }
}

enum VerificationStatus {
  verified,
  pending,
  rejected;

  String get value {
    switch (this) {
      case VerificationStatus.verified:
        return 'verified';
      case VerificationStatus.pending:
        return 'pending';
      case VerificationStatus.rejected:
        return 'rejected';
    }
  }

  static VerificationStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'verified':
        return VerificationStatus.verified;
      case 'pending':
        return VerificationStatus.pending;
      case 'rejected':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.pending;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? address;
  final UserType userType;
  final String? pharmacyId; // For pharmacists
  final DateTime? dateOfBirth; // For patients
  final String? gender; // male | female | other
  final String? profileImageUrl;
  final String? whatsappNumber; // For pharmacists
  final VerificationStatus verificationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final bool notificationsEnabled;
  final String themePreference; // light | dark | system

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.address,
    this.userType = UserType.unknown,
    this.pharmacyId,
    this.dateOfBirth,
    this.gender,
    this.profileImageUrl,
    this.whatsappNumber,
    this.verificationStatus = VerificationStatus.pending,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.notificationsEnabled = true,
    this.themePreference = 'system',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get fullName => '$firstName $lastName';

  bool get isPatient => userType == UserType.patient;
  bool get isPharmacist => userType == UserType.pharmacist;
  bool get isVerified => verificationStatus == VerificationStatus.verified;

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    phoneNumber,
    address,
    userType,
    pharmacyId,
    dateOfBirth,
    gender,
    profileImageUrl,
    whatsappNumber,
    verificationStatus,
    createdAt,
    updatedAt,
    lastLoginAt,
    notificationsEnabled,
    themePreference,
  ];

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    UserType? userType,
    String? pharmacyId,
    DateTime? dateOfBirth,
    String? gender,
    String? profileImageUrl,
    String? whatsappNumber,
    VerificationStatus? verificationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    bool? notificationsEnabled,
    String? themePreference,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      userType: userType ?? this.userType,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themePreference: themePreference ?? this.themePreference,
    );
  }
}
