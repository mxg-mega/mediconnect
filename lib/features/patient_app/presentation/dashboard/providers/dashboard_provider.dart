import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mediconnect/common/auth/data/models/pharmacy_model.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/data/models/user_model.dart';
import 'package:mediconnect/common/auth/presentation/providers/auth_provider.dart';

class DashboardState {
  final UserModel? user;
  final List<Pharmacy> nearbyPharmacies;
  final bool isLoading;
  final String? error;

  DashboardState({
    this.user,
    this.nearbyPharmacies = const [],
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    UserModel? user,
    List<Pharmacy>? nearbyPharmacies,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      user: user ?? this.user,
      nearbyPharmacies: nearbyPharmacies ?? this.nearbyPharmacies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final Ref ref;
  
  DashboardNotifier(this.ref) : super(DashboardState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    final user = ref.read(currentUserProvider);
    state = state.copyWith(user: user);
    
    await fetchNearbyPharmacies();
  }

  Future<void> fetchNearbyPharmacies() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      Position? position;
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
            position = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium)
            );
          }
        }
      } catch (e) {
        // Location failed, fallback to arbitrary location or skip distance sorting
      }

      final center = position != null 
          ? GeoFirePoint(GeoPoint(position.latitude, position.longitude))
          : GeoFirePoint(const GeoPoint(0, 0)); // Fallback

      // Radius in km
      const double radius = 50.0;
      
      // We query the businesses collection. For MVP, if we fail to get location, we just fetch a few businesses.
      if (position == null) {
        final snap = await FirebaseFirestore.instance.collection('businesses').limit(10).get();
        final pharmacies = snap.docs.map((d) => PharmacyModel.fromJson(d.data()).toEntity()).toList();
        state = state.copyWith(nearbyPharmacies: pharmacies, isLoading: false);
        return;
      }

      // Perform geo query
      final collectionReference = FirebaseFirestore.instance.collection('businesses');
      final snap = await GeoCollectionReference(collectionReference).fetchWithin(
        center: center,
        radiusInKm: radius,
        field: 'geo',
        geopointFrom: (data) => (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
        strictMode: true,
      );

      final pharmacies = snap.map((docSnap) {
        final data = docSnap.data() as Map<String, dynamic>;
        return PharmacyModel.fromJson(data).toEntity();
      }).toList();

      state = state.copyWith(nearbyPharmacies: pharmacies, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref);
});
