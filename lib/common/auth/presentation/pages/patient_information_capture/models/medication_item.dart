import 'package:mediconnect/features/patient_app/domain/entities/medical_history.dart';

class MedicationItem {
  final String id;
  final String medicationName;
  final String strength;
  final String form;
  final String prescribedBy;
  final String prescriptionDate;
  final RecoveryStatus? recoveryStatus;

  MedicationItem({
    required this.id,
    required this.medicationName,
    required this.strength,
    required this.form,
    required this.prescribedBy,
    required this.prescriptionDate,
    this.recoveryStatus,
  });

  MedicationItem copyWith({
    String? id,
    String? medicationName,
    String? strength,
    String? form,
    String? prescribedBy,
    String? prescriptionDate,
    RecoveryStatus? recoveryStatus,
  }) {
    return MedicationItem(
      id: id ?? this.id,
      medicationName: medicationName ?? this.medicationName,
      strength: strength ?? this.strength,
      form: form ?? this.form,
      prescribedBy: prescribedBy ?? this.prescribedBy,
      prescriptionDate: prescriptionDate ?? this.prescriptionDate,
      recoveryStatus: recoveryStatus ?? this.recoveryStatus,
    );
  }
}
