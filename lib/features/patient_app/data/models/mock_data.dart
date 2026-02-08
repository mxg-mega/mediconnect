import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/domain/entities/medication.dart';

class MockData {
  static final List<Pharmacy> pharmacies = [
    Pharmacy(
      id: '1',
      name: 'New-Health Pharmacy Ltd',
      address: '123 Main St, Abuja',
      phoneNumber: '123-456-7890',
      email: 'info@newhealth.com',
      businessEmail: 'biz@newhealth.com',
      location: const GeoLocation(latitude: 9.0765, longitude: 7.3986),
      rating: const PharmacyRating(averageRating: 4.0, totalReviews: 37),
      frontalImageUrl: 'https://picsum.photos/seed/ph1/300/200',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Pharmacy(
      id: '2',
      name: 'Apogee Pharmacy',
      address: '456 Oak Ave, Abuja',
      phoneNumber: '987-654-3210',
      email: 'info@apogee.com',
      businessEmail: 'biz@apogee.com',
      location: const GeoLocation(latitude: 9.0765, longitude: 7.3986),
      rating: const PharmacyRating(averageRating: 4.8, totalReviews: 91),
      frontalImageUrl: 'https://picsum.photos/seed/ph2/300/200',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
     Pharmacy(
      id: '3',
      name: 'HealthPlus Pharmacy',
      address: '789 Pine Rd, Abuja',
      phoneNumber: '555-555-5555',
      email: 'info@healthplus.com',
      businessEmail: 'biz@healthplus.com',
      location: const GeoLocation(latitude: 9.0765, longitude: 7.3986),
      rating: const PharmacyRating(averageRating: 4.5, totalReviews: 120),
      frontalImageUrl: 'https://picsum.photos/seed/ph3/300/200',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  static final List<Medication> medications = [
    Medication(
      id: '1',
      name: 'Penicillin',
      brandNames: ['Pen-Vee K'],
      category: 'Antibiotic',
      manufacturer: 'GSK',
      dosageForms: ['Tablet'],
      strengths: ['500mg'],
      imageUrls: ['https://picsum.photos/seed/med1/300/200'],
      rating: const MedicationRating(averageRating: 4.8, totalReviews: 264),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Medication(
      id: '2',
      name: 'Ampicillin',
      brandNames: ['Omnipen'],
      category: 'Antibiotic',
      manufacturer: 'Sandoz',
      dosageForms: ['Capsule'],
      strengths: ['250mg'],
      imageUrls: ['https://picsum.photos/seed/med2/300/200'],
      rating: const MedicationRating(averageRating: 4.7, totalReviews: 198),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
     Medication(
      id: '3',
      name: 'Ibuprofen',
      brandNames: ['Advil', 'Motrin'],
      category: 'Pain reliever',
      manufacturer: 'Pfizer',
      dosageForms: ['Tablet'],
      strengths: ['200mg'],
      imageUrls: ['https://picsum.photos/seed/med3/300/200'],
      rating: const MedicationRating(averageRating: 4.9, totalReviews: 540),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
}

