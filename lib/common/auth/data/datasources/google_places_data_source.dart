import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GooglePlacesDataSource {
  final Dio _dio;

  GooglePlacesDataSource() : _dio = Dio();

  Future<List<Map<String, dynamic>>> getNearbyPharmacies(double lat, double lng, {int radius = 5000}) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return [];

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
        queryParameters: {
          'location': '$lat,$lng',
          'radius': radius,
          'type': 'pharmacy',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          return List<Map<String, dynamic>>.from(data['results']);
        }
      }
      return [];
    } catch (e) {
      print('Google Places Error: $e');
      return [];
    }
  }
}
