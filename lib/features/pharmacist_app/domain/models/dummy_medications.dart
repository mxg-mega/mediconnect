import 'package:mediconnect/features/pharmacist_app/domain/models/medication.dart';

final List<Medication> dummyMedications = [
  Medication(
    id: '1',
    name: 'Amoxicillin 500mg',
    brand: 'Amoxil',
    manufacturer: 'GSK',
    stock: 72,
    packSize: "10's",
    price: 2500,
    imageUrl: 'assets/images/amoxicillin_gsk.png',
  ),
  Medication(
    id: '2',
    name: 'Amoxicillin 500mg',
    brand: 'Generic',
    manufacturer: 'Teva',
    stock: 131,
    packSize: "10's",
    price: 2200,
    imageUrl: 'assets/images/amoxicillin_gsk.png',
  ),
  Medication(
    id: '3',
    name: 'Ibuprofen 500mg',
    brand: 'Advil',
    manufacturer: 'Pfizer',
    stock: 3,
    packSize: "100's",
    price: 22500,
    imageUrl: 'assets/images/ibuprofen_pfizer.png',
  ),
  Medication(
    id: '4',
    name: 'Metformin 500mg',
    brand: 'Prinivil',
    manufacturer: 'Merck',
    stock: 5,
    packSize: "30's",
    price: 6000,
    imageUrl: 'assets/images/metformin_merck.png',
  ),
];
