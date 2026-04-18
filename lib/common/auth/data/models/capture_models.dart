import 'package:equatable/equatable.dart';
import 'package:mediconnect/common/auth/data/models/medical_history_model.dart';
import 'package:mediconnect/common/auth/data/models/medication_model.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/features/patient_app/domain/entities/medical_history.dart'
    as domain_medical;

class PatientInfoInput extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime? dateOfBirth;
  final String gender;
  final String address;
  final String emergencyContact;

  const PatientInfoInput({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.emergencyContact,
  });

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'email': email,
    'phone_number': phoneNumber,
    'date_of_birth': dateOfBirth?.toIso8601String(),
    'gender': gender,
    'address': address,
    'emergency_contact': emergencyContact,
  };

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    dateOfBirth,
    gender,
    address,
    emergencyContact,
  ];
}

class MedicationInput extends Equatable {
  final String id;
  final String name;
  final String strength;
  final String form;
  final String prescribedBy;
  final DateTime? prescriptionDate;
  final domain_medical.RecoveryStatus? recoveryStatus;

  const MedicationInput({
    required this.id,
    required this.name,
    required this.strength,
    required this.form,
    required this.prescribedBy,
    this.prescriptionDate,
    this.recoveryStatus,
  });

  Medication toMedicationModel() => Medication(
    id: id,
    medicationName: name,
    prescribedBy: prescribedBy,
    dosage: strength,
    form: form,
    prescriptionDate: prescriptionDate,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    strength,
    form,
    prescribedBy,
    prescriptionDate,
    recoveryStatus,
  ];
}

class AllergyInput extends Equatable {
  final String id;
  final String symptoms;
  final String type;
  final AllergySeverity severity;

  const AllergyInput({
    required this.id,
    required this.symptoms,
    required this.type,
    required this.severity,
  });

  Allergies toAllergyModel() => Allergies(
    id: id,
    allergenName: symptoms,
    type: type,
    severity: severity.value,
  );

  @override
  List<Object?> get props => [id, symptoms, type, severity];
}

class MedicalHistoryInput extends Equatable {
  final String conditionName;
  final ConditionStatus currentStatus;
  final DateTime? diagnosisDate;
  final String location;
  final String diagnosisDetails;
  final List<MedicationInput> currentMedications;
  final List<MedicationInput> pastMedications;
  final List<AllergyInput> allergies;
  final bool consentAccepted;

  const MedicalHistoryInput({
    required this.conditionName,
    required this.currentStatus,
    required this.diagnosisDate,
    required this.location,
    required this.diagnosisDetails,
    required this.currentMedications,
    required this.pastMedications,
    required this.allergies,
    required this.consentAccepted,
  });

  MedicalHistory toModel() {
    return MedicalHistory(
      conditionName: conditionName,
      currentStatus: currentStatus,
      diagnosisDate: diagnosisDate ?? DateTime.now(),
      location: location,
      diagnosisDetails: diagnosisDetails,
      medications: [
        ...currentMedications.map((e) => e.toMedicationModel()),
        ...pastMedications.map((e) => e.toMedicationModel()),
      ],
      currentMedication: currentMedications.isNotEmpty
          ? currentMedications.first.toMedicationModel()
          : null,
      allergies: allergies.map((e) => e.toAllergyModel()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    conditionName,
    currentStatus,
    diagnosisDate,
    location,
    diagnosisDetails,
    currentMedications,
    pastMedications,
    allergies,
    consentAccepted,
  ];
}

class PharmacyInfoInput extends Equatable {
  final String pharmacyName;
  final String titleOrRole;
  final String contactNumber;
  final String email;
  final String address;
  final String operatingHours;
  final PharmacyType type;
  final String? description;

  const PharmacyInfoInput({
    required this.pharmacyName,
    required this.titleOrRole,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.operatingHours,
    required this.type,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'pharmacy_name': pharmacyName,
    'title_role': titleOrRole,
    'contact_number': contactNumber,
    'email': email,
    'address': address,
    'operating_hours': operatingHours,
    'type': type.value,
    'description': description,
  };

  @override
  List<Object?> get props => [
    pharmacyName,
    titleOrRole,
    contactNumber,
    email,
    address,
    operatingHours,
    type,
    description,
  ];
}

class PharmacyVerificationInput extends Equatable {
  final String? frontalImagePath;
  final String? licensePath;
  final String? businessRegPath;
  final String? pcnIdNumber;
  final String? agencySelection;
  final String? pcnCertificatePath;
  final String? addressProofPath;
  final String? additionalCertPath;
  final bool consentAccepted;

  const PharmacyVerificationInput({
    this.frontalImagePath,
    this.licensePath,
    this.businessRegPath,
    this.pcnIdNumber,
    this.agencySelection,
    this.pcnCertificatePath,
    this.addressProofPath,
    this.additionalCertPath,
    required this.consentAccepted,
  });

  Map<String, dynamic> toJson() => {
    'frontal_image': frontalImagePath,
    'license_document': licensePath,
    'business_registration': businessRegPath,
    'pcn_id_number': pcnIdNumber,
    'agency_selection': agencySelection,
    'pcn_certificate': pcnCertificatePath,
    'address_proof': addressProofPath,
    'additional_certification': additionalCertPath,
    'consent_accepted': consentAccepted,
  };

  @override
  List<Object?> get props => [
    frontalImagePath,
    licensePath,
    businessRegPath,
    pcnIdNumber,
    agencySelection,
    pcnCertificatePath,
    addressProofPath,
    additionalCertPath,
    consentAccepted,
  ];
}
