import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/domain/entities/medication.dart';
import 'package:mediconnect/features/patient_app/data/models/mock_data.dart';

final medicationListProvider = Provider<List<Medication>>((ref) {
  // In a real application, this would fetch data from a repository
  return MockData.medications;
});