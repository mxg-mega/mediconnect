import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationSeeder {
  static Future<void> seedDummyData() async {
    final db = FirebaseFirestore.instance;
    
    // 1. Seed Global Medications
    final medications = [
      {
        'id': 'med_amox_500',
        'name': 'Amoxicillin 500mg',
        'manufacturer': 'GSK',
        'brandName': 'Amoxil',
        'dosage': '500 mg',
        'packaging': '10 capsules',
        'description': 'Antibiotic used for treating bacterial infections.',
        'benefitsAndUses': 'Treats chest infections, dental abscesses, and UTIs.',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'id': 'med_para_500',
        'name': 'Paracetamol 500mg',
        'manufacturer': 'Emzor',
        'brandName': 'Emzor Paracetamol',
        'dosage': '500 mg',
        'packaging': '12 tablets',
        'description': 'Pain reliever and fever reducer.',
        'benefitsAndUses': 'Treats headaches, muscle aches, arthritis, backache, toothaches.',
        'imageUrl': 'https://via.placeholder.com/150',
      }
    ];

    for (var med in medications) {
      await db.collection('medications').doc(med['id']).set(med);
    }

    // 2. Seed Pharmacy Listings (The Searchable Index)
    final listings = [
      {
        'id': 'list_pharm1_amox',
        'medicationId': 'med_amox_500',
        'medicationName': 'Amoxicillin 500mg',
        'pharmacyId': 'pharm1',
        'pharmacyName': 'Alpha Pharmacy',
        'price': 2500.0,
        'currency': 'NGN',
        'stockQuantity': 50,
        'stockStatus': 'inStock',
        // Dummy GPS near Abuja
        '_geoloc': {
          'lat': 9.0765,
          'lng': 7.3986,
        }
      },
      {
        'id': 'list_pharm2_amox',
        'medicationId': 'med_amox_500',
        'medicationName': 'Amoxicillin 500mg',
        'pharmacyId': 'pharm2',
        'pharmacyName': 'Omega Pharmacy',
        'price': 2700.0,
        'currency': 'NGN',
        'stockQuantity': 10,
        'stockStatus': 'lowStock',
        // Dummy GPS near Abuja
        '_geoloc': {
          'lat': 9.0800,
          'lng': 7.4000,
        }
      },
      {
        'id': 'list_pharm1_para',
        'medicationId': 'med_para_500',
        'medicationName': 'Paracetamol 500mg',
        'pharmacyId': 'pharm1',
        'pharmacyName': 'Alpha Pharmacy',
        'price': 500.0,
        'currency': 'NGN',
        'stockQuantity': 200,
        'stockStatus': 'inStock',
        '_geoloc': {
          'lat': 9.0765,
          'lng': 7.3986,
        }
      }
    ];

    for (var list in listings) {
      await db.collection('medication_listings').doc(list['id'] as String?).set(list);
    }
    
    print('Dummy data seeded successfully!');
  }
}
