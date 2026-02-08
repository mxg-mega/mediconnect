import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/features/patient_app/data/models/mock_data.dart';

final pharmacyListProvider = Provider<List<Pharmacy>>((ref) {
  // In a real application, this would fetch data from a repository
  return MockData.pharmacies;
});