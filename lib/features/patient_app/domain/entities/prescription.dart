import 'package:equatable/equatable.dart';

enum PrescriptionStatus {
  active,
  expired,
  used,
  cancelled;

  String get value {
    switch (this) {
      case PrescriptionStatus.active:
        return 'active';
      case PrescriptionStatus.expired:
        return 'expired';
      case PrescriptionStatus.used:
        return 'used';
      case PrescriptionStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case PrescriptionStatus.active:
        return 'Active';
      case PrescriptionStatus.expired:
        return 'Expired';
      case PrescriptionStatus.used:
        return 'Used';
      case PrescriptionStatus.cancelled:
        return 'Cancelled';
    }
  }

  static PrescriptionStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return PrescriptionStatus.active;
      case 'expired':
        return PrescriptionStatus.expired;
      case 'used':
        return PrescriptionStatus.used;
      case 'cancelled':
        return PrescriptionStatus.cancelled;
      default:
        return PrescriptionStatus.active;
    }
  }
}

class PrescribedMedication extends Equatable {
  final String medicationId; // Foreign key to Medication
  final String medicationName;
  final String dosage;
  final String frequency;
  final int quantity;
  final String? instructions;

  const PrescribedMedication({
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.quantity,
    this.instructions,
  });

  @override
  List<Object?> get props => [
    medicationId,
    medicationName,
    dosage,
    frequency,
    quantity,
    instructions,
  ];

  PrescribedMedication copyWith({
    String? medicationId,
    String? medicationName,
    String? dosage,
    String? frequency,
    int? quantity,
    String? instructions,
  }) {
    return PrescribedMedication(
      medicationId: medicationId ?? this.medicationId,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      quantity: quantity ?? this.quantity,
      instructions: instructions ?? this.instructions,
    );
  }
}

class Prescription extends Equatable {
  final String id; // Primary key
  final String patientId; // Foreign key to User
  final String imageUrl; // Prescription image/document
  final DateTime uploadDate;
  final DateTime? expiryDate; // Prescription expiry
  final String? doctorName; // Prescribing doctor
  final String? doctorLicense; // Doctor license number
  final String? hospital; // Hospital/clinic name
  final List<PrescribedMedication> medications; // Medications on prescription
  final PrescriptionStatus status; // active | expired | used | cancelled
  final String? notes; // Additional notes
  final bool isDigital; // Digital prescription vs scanned
  final String? prescriptionNumber; // Prescription reference number

  const Prescription({
    required this.id,
    required this.patientId,
    required this.imageUrl,
    required this.uploadDate,
    this.expiryDate,
    this.doctorName,
    this.doctorLicense,
    this.hospital,
    this.medications = const [],
    this.status = PrescriptionStatus.active,
    this.notes,
    this.isDigital = false,
    this.prescriptionNumber,
  });

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isActive {
    return status == PrescriptionStatus.active && !isExpired;
  }

  @override
  List<Object?> get props => [
    id,
    patientId,
    imageUrl,
    uploadDate,
    expiryDate,
    doctorName,
    doctorLicense,
    hospital,
    medications,
    status,
    notes,
    isDigital,
    prescriptionNumber,
  ];

  Prescription copyWith({
    String? id,
    String? patientId,
    String? imageUrl,
    DateTime? uploadDate,
    DateTime? expiryDate,
    String? doctorName,
    String? doctorLicense,
    String? hospital,
    List<PrescribedMedication>? medications,
    PrescriptionStatus? status,
    String? notes,
    bool? isDigital,
    String? prescriptionNumber,
  }) {
    return Prescription(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      imageUrl: imageUrl ?? this.imageUrl,
      uploadDate: uploadDate ?? this.uploadDate,
      expiryDate: expiryDate ?? this.expiryDate,
      doctorName: doctorName ?? this.doctorName,
      doctorLicense: doctorLicense ?? this.doctorLicense,
      hospital: hospital ?? this.hospital,
      medications: medications ?? this.medications,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isDigital: isDigital ?? this.isDigital,
      prescriptionNumber: prescriptionNumber ?? this.prescriptionNumber,
    );
  }
}
