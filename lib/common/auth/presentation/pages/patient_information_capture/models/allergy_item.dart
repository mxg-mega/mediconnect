import 'package:mediconnect/features/patient_app/domain/entities/medical_history.dart';

class AllergyItem {
  final String id;
  final String symptoms;
  final String allergenType;
  final AllergySeverity severity;

  AllergyItem({
    required this.id,
    required this.symptoms,
    required this.allergenType,
    required this.severity,
  });

  AllergyItem copyWith({
    String? id,
    String? symptoms,
    String? allergenType,
    AllergySeverity? severity,
  }) {
    return AllergyItem(
      id: id ?? this.id,
      symptoms: symptoms ?? this.symptoms,
      allergenType: allergenType ?? this.allergenType,
      severity: severity ?? this.severity,
    );
  }
}
