import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/common/auth/data/models/medication_model.dart';

part 'medical_history_model.g.dart';

enum ConditionStatus {
  active,
  resolved,
  chronic;

  String get value {
    switch (this) {
      case ConditionStatus.active:
        return 'active';
      case ConditionStatus.resolved:
        return 'resolved';
      case ConditionStatus.chronic:
        return 'chronic';
    }
  }

  String get displayName {
    switch (this) {
      case ConditionStatus.active:
        return 'Active';
      case ConditionStatus.resolved:
        return 'Resolved';
      case ConditionStatus.chronic:
        return 'Chronic';
    }
  }

  static ConditionStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return ConditionStatus.active;
      case 'resolved':
        return ConditionStatus.resolved;
      case 'chronic':
        return ConditionStatus.chronic;
      default:
        return ConditionStatus.active;
    }
  }
}

enum AllergyType {
  drug,
  food,
  environmental;

  String get value {
    switch (this) {
      case AllergyType.drug:
        return 'drug';
      case AllergyType.food:
        return 'food';
      case AllergyType.environmental:
        return 'environmental';
    }
  }

  String get displayName {
    switch (this) {
      case AllergyType.drug:
        return 'Drug Allergy';
      case AllergyType.food:
        return 'Food Allergy';
      case AllergyType.environmental:
        return 'Environmental Allergy';
    }
  }

  static AllergyType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'drug':
        return AllergyType.drug;
      case 'food':
        return AllergyType.food;
      case 'environmental':
        return AllergyType.environmental;
      default:
        return AllergyType.drug;
    }
  }
}

enum AllergySeverity {
  mild,
  moderate,
  severe;

  String get value {
    switch (this) {
      case AllergySeverity.mild:
        return 'mild';
      case AllergySeverity.moderate:
        return 'moderate';
      case AllergySeverity.severe:
        return 'severe';
    }
  }

  String get displayName {
    switch (this) {
      case AllergySeverity.mild:
        return 'Mild';
      case AllergySeverity.moderate:
        return 'Moderate';
      case AllergySeverity.severe:
        return 'Severe';
    }
  }

  static AllergySeverity fromString(String value) {
    switch (value.toLowerCase()) {
      case 'mild':
        return AllergySeverity.mild;
      case 'moderate':
        return AllergySeverity.moderate;
      case 'severe':
        return AllergySeverity.severe;
      default:
        return AllergySeverity.mild;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MedicalHistory extends Equatable {
  // Your preferred fields (based on Figma design)
  final String conditionName;
  final ConditionStatus currentStatus;
  final DateTime diagnosisDate;
  final String location;
  final String diagnosisDetails;
  final List<Medication> medications;
  final Medication? currentMedication;
  final List<Allergies> allergies;

  // Enhanced features from domain model (nullable for future extensibility)
  final String? id;
  final String? patientId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? notes;

  const MedicalHistory({
    required this.conditionName,
    required this.currentStatus,
    required this.diagnosisDate,
    required this.location,
    required this.diagnosisDetails,
    required this.medications,
    this.currentMedication,
    required this.allergies,
    this.id,
    this.patientId,
    this.createdAt,
    this.updatedAt,
    this.notes,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) =>
      _$MedicalHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalHistoryToJson(this);

  @override
  List<Object?> get props => [
    conditionName,
    currentStatus,
    diagnosisDate,
    location,
    diagnosisDetails,
    medications,
    currentMedication,
    allergies,
    id,
    patientId,
    createdAt,
    updatedAt,
    notes,
  ];

  MedicalHistory copyWith({
    String? conditionName,
    ConditionStatus? currentStatus,
    DateTime? diagnosisDate,
    String? location,
    String? diagnosisDetails,
    List<Medication>? medications,
    Medication? currentMedication,
    List<Allergies>? allergies,
    String? id,
    String? patientId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return MedicalHistory(
      conditionName: conditionName ?? this.conditionName,
      currentStatus: currentStatus ?? this.currentStatus,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      location: location ?? this.location,
      diagnosisDetails: diagnosisDetails ?? this.diagnosisDetails,
      medications: medications ?? this.medications,
      currentMedication: currentMedication ?? this.currentMedication,
      allergies: allergies ?? this.allergies,
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }
}
