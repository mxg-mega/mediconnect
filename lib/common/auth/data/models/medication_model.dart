import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medication_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Medication extends Equatable {
  final String id;
  final String medicationName;
  final String prescribedBy;
  final String dosage;
  final String form;
  final DateTime? prescriptionDate;

  const Medication({
    required this.id,
    required this.medicationName,
    required this.prescribedBy,
    required this.dosage,
    required this.form,
    this.prescriptionDate,
  });

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationToJson(this);

  @override
  List<Object?> get props => [
    id,
    medicationName,
    prescribedBy,
    dosage,
    form,
    prescriptionDate,
  ];

  Medication copyWith({
    String? id,
    String? medicationName,
    String? prescribedBy,
    String? dosage,
    String? form,
    DateTime? prescriptionDate,
  }) {
    return Medication(
      id: id ?? this.id,
      medicationName: medicationName ?? this.medicationName,
      prescribedBy: prescribedBy ?? this.prescribedBy,
      dosage: dosage ?? this.dosage,
      form: form ?? this.form,
      prescriptionDate: prescriptionDate ?? this.prescriptionDate,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Allergies extends Equatable {
  final String id;
  final String allergenName; // This represents the symptoms (e.g., "Skin rash")
  final String type; // Allergen type (e.g., "Penicillin, Food, Drug")
  final String severity;

  const Allergies({
    required this.id,
    required this.allergenName,
    required this.type,
    required this.severity,
  });

  factory Allergies.fromJson(Map<String, dynamic> json) =>
      _$AllergiesFromJson(json);

  Map<String, dynamic> toJson() => _$AllergiesToJson(this);

  @override
  List<Object?> get props => [id, allergenName, type, severity];

  Allergies copyWith({
    String? id,
    String? allergenName,
    String? type,
    String? severity,
  }) {
    return Allergies(
      id: id ?? this.id,
      allergenName: allergenName ?? this.allergenName,
      type: type ?? this.type,
      severity: severity ?? this.severity,
    );
  }
}
