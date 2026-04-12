import 'package:dio/dio.dart';
import 'package:mediconnect/common/domain/entities/medication.dart';
import 'package:mediconnect/features/pharmacist_app/domain/repositories/medication_catalog_repository.dart';

class MedicationCatalogRepositoryImpl implements MedicationCatalogRepository {
  final Dio _dio;
  static const String _baseUrl = 'https://api.fda.gov/drug/label.json';

  MedicationCatalogRepositoryImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<List<Medication>> searchMedications(String query) async {
    try {
      // Search by brand name or generic name in OpenFDA
      // query parameter format for OpenFDA: search=openfda.brand_name:"query"+openfda.generic_name:"query"
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'search': 'openfda.brand_name:"$query" openfda.generic_name:"$query"',
          'limit': 10,
        },
      );

      final results = response.data['results'] as List<dynamic>;
      return results.map((json) => _mapJsonToMedication(json)).toList();
    } catch (e) {
      // If the search fails or returns 404 (not found), return an empty list 
      // instead of throwing so the UI can handle the "no results" state gracefully.
      return [];
    }
  }

  @override
  Future<Medication?> getMedicationDetails(String id) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'search': 'id:"$id"',
          'limit': 1,
        },
      );

      final results = response.data['results'] as List<dynamic>;
      if (results.isEmpty) return null;

      return _mapJsonToMedication(results.first);
    } catch (e) {
      return null;
    }
  }

  Medication _mapJsonToMedication(Map<String, dynamic> json) {
    final openfda = json['openfda'] as Map<String, dynamic>? ?? {};
    final now = DateTime.now();

    // OpenFDA fields are often arrays
    final brandNames = List<String>.from(openfda['brand_name'] ?? []);
    final genericNames = List<String>.from(openfda['generic_name'] ?? []);
    final manufacturers = List<String>.from(openfda['manufacturer_name'] ?? []);
    
    // Technical data from the label
    final indications = (json['indications_and_usage'] as List<dynamic>?)?.first ?? '';
    final dosage = (json['dosage_and_administration'] as List<dynamic>?)?.first ?? '';
    final description = (json['description'] as List<dynamic>?)?.first ?? indications;

    return Medication(
      id: json['id'] ?? brandNames.first.toLowerCase().replaceAll(' ', '-'),
      name: genericNames.isNotEmpty ? genericNames.first : (brandNames.isNotEmpty ? brandNames.first : 'Unknown Medication'),
      brandNames: brandNames,
      category: 'Uncategorized', // API doesn't provide a clean category, user can edit
      manufacturer: manufacturers.isNotEmpty ? manufacturers.first : 'Unknown',
      dosageForms: [], // Extracted from label if needed
      strengths: [],
      description: _cleanHtml(description),
      usageInstructions: _cleanHtml(dosage),
      createdAt: now,
      updatedAt: now,
    );
  }

  String _cleanHtml(String text) {
    // Basic cleanup of API response text which can contain some formatting markers
    return text.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ' ').trim();
  }
}
