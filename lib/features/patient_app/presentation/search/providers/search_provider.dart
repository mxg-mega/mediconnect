import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mediconnect/common/auth/data/datasources/google_places_data_source.dart';
import 'package:mediconnect/common/auth/data/models/pharmacy_model.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
// Note: We need a Medication model but since it's an MVP, we'll map Algolia hits.

// 1. Search Query State
final patientSearchQueryProvider = StateProvider<String>((ref) => '');

// 2. Algolia Configurations (Replace with real keys)
final algoliaAppId = 'OP2GYSZBVO';
final algoliaSearchKey = '930fb872e30ed7255650e613502bf05d';

final medicationsSearchClientProvider = Provider<HitsSearcher>((ref) {
  return HitsSearcher(
    applicationID: algoliaAppId,
    apiKey: algoliaSearchKey,
    indexName: 'medications_index',
  );
});

final pharmaciesSearchClientProvider = Provider<HitsSearcher>((ref) {
  return HitsSearcher(
    applicationID: algoliaAppId,
    apiKey: algoliaSearchKey,
    indexName: 'businesses_index',
  );
});

final googlePlacesDataSourceProvider = Provider<GooglePlacesDataSource>((ref) {
  return GooglePlacesDataSource();
});

// 3. Search Results Providers
final medicationSearchResultsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final query = ref.watch(patientSearchQueryProvider);
  final searcher = ref.watch(medicationsSearchClientProvider);
  
  searcher.query(query);
  
  return searcher.responses.map((response) {
    return response.hits.map((hit) => hit).toList();
  }).handleError((error) {
    print('Algolia Medication Search Error: $error');
  });
});

final pharmacySearchResultsProvider = StreamProvider<List<Pharmacy>>((ref) {
  final query = ref.watch(patientSearchQueryProvider);
  final searcher = ref.watch(pharmaciesSearchClientProvider);
  
  searcher.query(query);
  
  return searcher.responses.map((response) {
    return response.hits.map((hit) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(hit);
      data['id'] = hit['objectID'];
      if (data['location'] == null) {
         data['location'] = {'latitude': 0.0, 'longitude': 0.0};
      }
      return PharmacyModel.fromJson(data).toEntity();
    }).toList();
  }).handleError((error) {
    print('Algolia Pharmacy Search Error: $error');
  });
});

// 4. Combined Pharmacy Results
final combinedPharmacySearchResultsProvider = FutureProvider<List<Pharmacy>>((ref) async {
  final algoliaStream = ref.watch(pharmacySearchResultsProvider.future);
  
  // Try to get Algolia first
  List<Pharmacy> medconnectPharmacies = [];
  try {
    medconnectPharmacies = await algoliaStream;
  } catch (_) {}

  // Fetch Google Places
  List<Pharmacy> googlePharmacies = [];
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium));
        
        final placesSource = ref.read(googlePlacesDataSourceProvider);
        final places = await placesSource.getNearbyPharmacies(position.latitude, position.longitude);
        
        googlePharmacies = places.map((p) {
           return Pharmacy(
             id: p['place_id'] ?? '',
             name: p['name'] ?? 'Pharmacy',
             email: '',
             businessEmail: '',
             phoneNumber: '',
             licenseNumber: '',
             isVerified: false,
             address: p['vicinity'] ?? '',
             location: GeoLocation(
               latitude: p['geometry']?['location']?['lat'] ?? 0.0,
               longitude: p['geometry']?['location']?['lng'] ?? 0.0,
             ),
             createdAt: DateTime.now(),
             updatedAt: DateTime.now(),
           );
        }).toList();
      }
    }
  } catch (e) {
    print('Error fetching places: $e');
  }

  // If there's a search query, filter google pharmacies manually (since Places nearby search isn't a text search per se, though we could use textSearch)
  final query = ref.watch(patientSearchQueryProvider).toLowerCase();
  if (query.isNotEmpty) {
    googlePharmacies = googlePharmacies.where((p) => p.name.toLowerCase().contains(query)).toList();
  }

  // Merge lists, prioritizing MedConnect
  final allPharmacies = <Pharmacy>[...medconnectPharmacies];
  
  // Filter out duplicates (if any overlapping place names)
  for (var p in googlePharmacies) {
    if (!allPharmacies.any((existing) => existing.name.toLowerCase() == p.name.toLowerCase())) {
      allPharmacies.add(p);
    }
  }

  return allPharmacies;
});
