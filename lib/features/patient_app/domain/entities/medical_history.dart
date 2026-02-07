import 'package:equatable/equatable.dart';
import 'package:mediconnect/common/auth/data/models/medical_history_model.dart';

// enum ConditionStatus {
//   active,
//   resolved,
//   chronic;

//   String get value {
//     switch (this) {
//       case ConditionStatus.active:
//         return 'active';
//       case ConditionStatus.resolved:
//         return 'resolved';
//       case ConditionStatus.chronic:
//         return 'chronic';
//     }
//   }

//   String get displayName {
//     switch (this) {
//       case ConditionStatus.active:
//         return 'Active';
//       case ConditionStatus.resolved:
//         return 'Resolved';
//       case ConditionStatus.chronic:
//         return 'Chronic';
//     }
//   }

//   static ConditionStatus fromString(String value) {
//     switch (value.toLowerCase()) {
//       case 'active':
//         return ConditionStatus.active;
//       case 'resolved':
//         return ConditionStatus.resolved;
//       case 'chronic':
//         return ConditionStatus.chronic;
//       default:
//         return ConditionStatus.active;
//     }
//   }
// }

enum RecoveryStatus {
  cured,
  notCured,
  ongoing;

  String get value {
    switch (this) {
      case RecoveryStatus.cured:
        return 'cured';
      case RecoveryStatus.notCured:
        return 'not_cured';
      case RecoveryStatus.ongoing:
        return 'ongoing';
    }
  }

  String get displayName {
    switch (this) {
      case RecoveryStatus.cured:
        return 'Cured';
      case RecoveryStatus.notCured:
        return 'Not Cured';
      case RecoveryStatus.ongoing:
        return 'Ongoing';
    }
  }

  static RecoveryStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cured':
        return RecoveryStatus.cured;
      case 'not_cured':
        return RecoveryStatus.notCured;
      case 'ongoing':
        return RecoveryStatus.ongoing;
      default:
        return RecoveryStatus.ongoing;
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

class MedicalCondition extends Equatable {
  final String id;
  final String name; // Condition name
  final String? description;
  final DateTime diagnosedDate;
  final ConditionStatus status; // active | resolved | chronic
  final String? notes;

  const MedicalCondition({
    required this.id,
    required this.name,
    this.description,
    required this.diagnosedDate,
    this.status = ConditionStatus.active,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    diagnosedDate,
    status,
    notes,
  ];

  MedicalCondition copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? diagnosedDate,
    ConditionStatus? status,
    String? notes,
  }) {
    return MedicalCondition(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      diagnosedDate: diagnosedDate ?? this.diagnosedDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

class CurrentMedication extends Equatable {
  final String id;
  final String medicationId; // Foreign key to Medication
  final String medicationName;
  final String dosage;
  final String frequency; // daily | twice_daily | as_needed
  final DateTime startDate;
  final DateTime? endDate;
  final String? prescribedBy; // Doctor name
  final String? notes;

  const CurrentMedication({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.prescribedBy,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    medicationId,
    medicationName,
    dosage,
    frequency,
    startDate,
    endDate,
    prescribedBy,
    notes,
  ];

  CurrentMedication copyWith({
    String? id,
    String? medicationId,
    String? medicationName,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? prescribedBy,
    String? notes,
  }) {
    return CurrentMedication(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      prescribedBy: prescribedBy ?? this.prescribedBy,
      notes: notes ?? this.notes,
    );
  }
}

class Diagnosis extends Equatable {
  final String id;
  final String conditionName;
  final String? location; // Body part affected
  final DateTime diagnosisDate;
  final String? doctorName;
  final String? hospital;
  final RecoveryStatus recoveryStatus; // cured | not_cured | ongoing
  final List<String> treatmentMedications;
  final String?
  treatmentEffectiveness; // effective | partially_effective | ineffective
  final String? challengesFaced;
  final String? notes;

  const Diagnosis({
    required this.id,
    required this.conditionName,
    this.location,
    required this.diagnosisDate,
    this.doctorName,
    this.hospital,
    this.recoveryStatus = RecoveryStatus.ongoing,
    this.treatmentMedications = const [],
    this.treatmentEffectiveness,
    this.challengesFaced,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    conditionName,
    location,
    diagnosisDate,
    doctorName,
    hospital,
    recoveryStatus,
    treatmentMedications,
    treatmentEffectiveness,
    challengesFaced,
    notes,
  ];

  Diagnosis copyWith({
    String? id,
    String? conditionName,
    String? location,
    DateTime? diagnosisDate,
    String? doctorName,
    String? hospital,
    RecoveryStatus? recoveryStatus,
    List<String>? treatmentMedications,
    String? treatmentEffectiveness,
    String? challengesFaced,
    String? notes,
  }) {
    return Diagnosis(
      id: id ?? this.id,
      conditionName: conditionName ?? this.conditionName,
      location: location ?? this.location,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      doctorName: doctorName ?? this.doctorName,
      hospital: hospital ?? this.hospital,
      recoveryStatus: recoveryStatus ?? this.recoveryStatus,
      treatmentMedications: treatmentMedications ?? this.treatmentMedications,
      treatmentEffectiveness:
          treatmentEffectiveness ?? this.treatmentEffectiveness,
      challengesFaced: challengesFaced ?? this.challengesFaced,
      notes: notes ?? this.notes,
    );
  }
}

class Allergy extends Equatable {
  final String id;
  final String allergenName; // Drug name or substance
  final AllergyType type; // drug | food | environmental
  final AllergySeverity severity; // mild | moderate | severe
  final List<String> symptoms;
  final DateTime firstOccurrence;
  final String? notes;

  const Allergy({
    required this.id,
    required this.allergenName,
    required this.type,
    required this.severity,
    this.symptoms = const [],
    required this.firstOccurrence,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    allergenName,
    type,
    severity,
    symptoms,
    firstOccurrence,
    notes,
  ];

  Allergy copyWith({
    String? id,
    String? allergenName,
    AllergyType? type,
    AllergySeverity? severity,
    List<String>? symptoms,
    DateTime? firstOccurrence,
    String? notes,
  }) {
    return Allergy(
      id: id ?? this.id,
      allergenName: allergenName ?? this.allergenName,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      symptoms: symptoms ?? this.symptoms,
      firstOccurrence: firstOccurrence ?? this.firstOccurrence,
      notes: notes ?? this.notes,
    );
  }
}

class MedicalHistory extends Equatable {
  final String id; // Primary key
  final String patientId; // Foreign key to User
  final List<MedicalCondition> conditions;
  final List<CurrentMedication> currentMedications;
  final List<Diagnosis> diagnoses;
  final List<Allergy> allergies;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicalHistory({
    required this.id,
    required this.patientId,
    this.conditions = const [],
    this.currentMedications = const [],
    this.diagnoses = const [],
    this.allergies = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    conditions,
    currentMedications,
    diagnoses,
    allergies,
    createdAt,
    updatedAt,
  ];

  MedicalHistory copyWith({
    String? id,
    String? patientId,
    List<MedicalCondition>? conditions,
    List<CurrentMedication>? currentMedications,
    List<Diagnosis>? diagnoses,
    List<Allergy>? allergies,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalHistory(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      conditions: conditions ?? this.conditions,
      currentMedications: currentMedications ?? this.currentMedications,
      diagnoses: diagnoses ?? this.diagnoses,
      allergies: allergies ?? this.allergies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
