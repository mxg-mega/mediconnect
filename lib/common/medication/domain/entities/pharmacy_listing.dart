import 'package:equatable/equatable.dart';

enum StockStatus {
  inStock,
  lowStock,
  outOfStock;

  String get value {
    switch (this) {
      case StockStatus.inStock:
        return 'inStock';
      case StockStatus.lowStock:
        return 'lowStock';
      case StockStatus.outOfStock:
        return 'outOfStock';
    }
  }

  String get displayName {
    switch (this) {
      case StockStatus.inStock:
        return 'In stock';
      case StockStatus.lowStock:
        return 'Low stock';
      case StockStatus.outOfStock:
        return 'Out of stock';
    }
  }

  static StockStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'instock':
        return StockStatus.inStock;
      case 'lowstock':
        return StockStatus.lowStock;
      case 'outofstock':
        return StockStatus.outOfStock;
      default:
        return StockStatus.outOfStock;
    }
  }
}

class PharmacyListing extends Equatable {
  final String id;
  final String medicationId;
  final String medicationName; // Helps with Algolia indexing/text search
  final String? medicationImageUrl;
  final String pharmacyId;
  final String pharmacyName;
  final double price;
  final String currency; // e.g. "NGN"
  final int stockQuantity;
  final StockStatus stockStatus;
  
  // Geography data specifically for Algolia sorting
  final double latitude;
  final double longitude;
  
  // Fields for UI (calculated or fetched live)
  final String distance; 
  final bool isPharmacyOpen;
  final String nextOpeningTime;

  const PharmacyListing({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    this.medicationImageUrl,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.price,
    this.currency = 'NGN',
    required this.stockQuantity,
    required this.stockStatus,
    required this.latitude,
    required this.longitude,
    this.distance = '',
    this.isPharmacyOpen = true,
    this.nextOpeningTime = '',
  });

  @override
  List<Object?> get props => [
        id,
        medicationId,
        medicationName,
        medicationImageUrl,
        pharmacyId,
        pharmacyName,
        price,
        currency,
        stockQuantity,
        stockStatus,
        latitude,
        longitude,
        distance,
        isPharmacyOpen,
        nextOpeningTime,
      ];

  PharmacyListing copyWith({
    String? id,
    String? medicationId,
    String? medicationName,
    String? medicationImageUrl,
    String? pharmacyId,
    String? pharmacyName,
    double? price,
    String? currency,
    int? stockQuantity,
    StockStatus? stockStatus,
    double? latitude,
    double? longitude,
    String? distance,
    bool? isPharmacyOpen,
    String? nextOpeningTime,
  }) {
    return PharmacyListing(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      medicationName: medicationName ?? this.medicationName,
      medicationImageUrl: medicationImageUrl ?? this.medicationImageUrl,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      stockStatus: stockStatus ?? this.stockStatus,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      isPharmacyOpen: isPharmacyOpen ?? this.isPharmacyOpen,
      nextOpeningTime: nextOpeningTime ?? this.nextOpeningTime,
    );
  }

  // Helper constructor to quickly generate from Algolia hit
  factory PharmacyListing.fromAlgolia(Map<String, dynamic> json) {
    // Algolia geo data is usually under _geoloc
    final geo = json['_geoloc'] as Map<String, dynamic>?;
    final lat = geo?['lat']?.toDouble() ?? 0.0;
    final lng = geo?['lng']?.toDouble() ?? 0.0;

    return PharmacyListing(
      id: json['objectID'] ?? json['id'] ?? '',
      medicationId: json['medicationId'] ?? '',
      medicationName: json['medicationName'] ?? 'Unknown Medication',
      medicationImageUrl: json['medicationImageUrl'],
      pharmacyId: json['pharmacyId'] ?? '',
      pharmacyName: json['pharmacyName'] ?? 'Unknown Pharmacy',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'NGN',
      stockQuantity: json['stockQuantity'] ?? 0,
      stockStatus: StockStatus.fromString(json['stockStatus'] ?? 'outOfStock'),
      latitude: lat,
      longitude: lng,
    );
  }
}
