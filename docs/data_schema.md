# MedConnect Data Schema Documentation

## Overview

This document defines the complete data schema for the MedConnect application, supporting both patient and pharmacist user types. The schema is designed to work with Firebase/Firestore but structured to be backend-agnostic for future migration to REST API + SQL databases.

## Backend Architecture

### Recommended Stack: Firebase + Optional REST API Migration

**Phase 1: Firebase Implementation**
- **Firebase Auth**: Email/phone verification, OTP, security
- **Firestore**: NoSQL database for flexible data structure
- **Firebase Storage**: File storage for images, documents, prescriptions
- **Firebase Functions**: Server-side logic and API endpoints

**Phase 2: Migration Path (When Needed)**
- Complex analytics queries
- Advanced reporting requirements
- Cost optimization at scale
- Regulatory compliance needs

## Core Entities

### 1. User Entity (Base)

**File**: `lib/common/auth/domain/entities/user_entity.dart`

```dart
class UserEntity {
  final String id;                    // Primary key
  final String email;                 // Required, unique
  final String firstName;             // Required
  final String lastName;              // Required
  final String phoneNumber;           // Required, unique
  final String? address;              // Optional
  final UserType userType;            // patient | pharmacist
  final String? pharmacyId;           // For pharmacists only
  final DateTime? dateOfBirth;        // For patients
  final String? gender;               // male | female | other
  final String? profileImageUrl;      // Optional profile picture
  final String? whatsappNumber;       // For pharmacists
  final VerificationStatus verificationStatus; // verified | pending | rejected
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final bool notificationsEnabled;
  final String themePreference;       // light | dark | system
}
```

**Validation Rules**:
- Email must be valid format
- Phone number must be valid format
- UserType must be either 'patient' or 'pharmacist'
- If userType is 'pharmacist', pharmacyId is required
- If userType is 'patient', dateOfBirth is required

### 2. Patient Profile Entity

**File**: `lib/features/patient_app/domain/entities/patient_profile.dart`

```dart
class PatientProfile {
  final String id;                    // Same as User.id
  final String userId;                // Foreign key to User
  final String fullName;              // Computed from firstName + lastName
  final DateTime dateOfBirth;
  final String gender;                // male | female | other
  final String? bloodType;            // A+ | A- | B+ | B- | AB+ | AB- | O+ | O-
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelation;
  final MedicalHistoryPrivacyLevel medicalHistoryPrivacy; // private | shared_with_pharmacists | public
  final List<String> allowedPharmacistIds; // Pharmacists who can view medical history
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### 3. Medical History Entity

**File**: `lib/features/patient_app/domain/entities/medical_history.dart`

```dart
class MedicalHistory {
  final String id;                    // Primary key
  final String patientId;             // Foreign key to User
  final List<MedicalCondition> conditions;
  final List<CurrentMedication> currentMedications;
  final List<Diagnosis> diagnoses;
  final List<Allergy> allergies;
  final List<Prescription> prescriptions;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class MedicalCondition {
  final String id;
  final String name;                  // Condition name
  final String? description;
  final DateTime diagnosedDate;
  final ConditionStatus status;       // active | resolved | chronic
  final String? notes;
}

class CurrentMedication {
  final String id;
  final String medicationId;          // Foreign key to Medication
  final String medicationName;
  final String dosage;
  final String frequency;              // daily | twice_daily | as_needed
  final DateTime startDate;
  final DateTime? endDate;
  final String? prescribedBy;         // Doctor name
  final String? notes;
}

class Diagnosis {
  final String id;
  final String conditionName;
  final String? location;             // Body part affected
  final DateTime diagnosisDate;
  final String? doctorName;
  final String? hospital;
  final RecoveryStatus recoveryStatus; // cured | not_cured | ongoing
  final List<String> treatmentMedications;
  final String? treatmentEffectiveness; // effective | partially_effective | ineffective
  final String? challengesFaced;
  final String? notes;
}

class Allergy {
  final String id;
  final String allergenName;          // Drug name or substance
  final AllergyType type;             // drug | food | environmental
  final AllergySeverity severity;    // mild | moderate | severe
  final List<String> symptoms;
  final DateTime firstOccurrence;
  final String? notes;
}
```

### 4. Pharmacy Entity (Extended)

**File**: `lib/common/auth/domain/entities/pharmacy.dart`

```dart
class Pharmacy {
  final String id;                    // Primary key
  final String name;                  // Required
  final String address;              // Required
  final String phoneNumber;           // Required
  final String email;                 // Required
  final String businessEmail;         // Separate from owner email
  final PharmacyType type;            // retail | wholesale
  final String? licenseNumber;
  final String? description;
  final String? frontalImageUrl;      // Main pharmacy image
  final String? interiorImageUrl;     // Interior view
  final String? logoUrl;              // Pharmacy logo
  final List<String> licenseDocumentUrls; // License verification docs
  final String? pcnRegistrationNumber;
  final List<OperatingHours> operatingHours;
  final GeoLocation location;        // lat/lng coordinates
  final PharmacyRating rating;       // Average rating and count
  final bool isVerified;             // Admin verified
  final bool isFeatured;             // Featured pharmacy
  final List<String> employeeIds;    // Pharmacist IDs
  final DateTime createdAt;
  final DateTime updatedAt;
}

class OperatingHours {
  final String dayOfWeek;            // monday | tuesday | etc.
  final String openTime;             // HH:mm format
  final String closeTime;             // HH:mm format
  final bool isClosed;               // If closed on this day
}

class GeoLocation {
  final double latitude;
  final double longitude;
  final String? address;             // Human readable address
}

class PharmacyRating {
  final double averageRating;        // 1.0 - 5.0
  final int totalReviews;
  final Map<String, int> ratingBreakdown; // {"1": 5, "2": 3, etc.}
}
```

### 5. Inventory Item Entity

**File**: `lib/features/pharmacist_app/domain/entities/inventory_item.dart`

```dart
class InventoryItem {
  final String id;                    // Primary key
  final String pharmacyId;            // Foreign key to Pharmacy
  final String medicationId;          // Foreign key to Medication
  final String brandName;             // Brand name of the medication
  final int quantityInStock;          // Current stock
  final String? batchNumber;          // Batch/lot number
  final DateTime expiryDate;          // Expiry date
  final double purchasePrice;         // Cost price
  final double sellingPrice;          // Retail price
  final int minimumStockLevel;        // Alert threshold
  final StockStatus stockStatus;      // in_stock | low_stock | out_of_stock
  final String? supplierName;         // Supplier information
  final DateTime lastRestocked;       // Last restock date
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### 6. Medication Entity (Master Catalog)

**File**: `lib/common/domain/entities/medication.dart`

```dart
class Medication {
  final String id;                    // Primary key
  final String name;                  // Generic name
  final List<String> brandNames;      // Array of brand names
  final String category;             // Therapeutic class
  final String manufacturer;          // Manufacturer name
  final List<String> dosageForms;     // tablet | capsule | syrup | injection
  final List<String> strengths;       // 500mg | 10ml | etc.
  final String? description;          // Drug description
  final String? usageInstructions;    // How to use
  final List<String> sideEffects;     // Common side effects
  final List<String> contraindications; // When not to use
  final bool prescriptionRequired;    // Prescription needed
  final List<String> imageUrls;        // Product images
  final MedicationRating rating;      // Average rating
  final List<String> alternativeIds; // Alternative medications
  final DateTime createdAt;
  final DateTime updatedAt;
}

class MedicationRating {
  final double averageRating;        // 1.0 - 5.0
  final int totalReviews;
  final Map<String, int> ratingBreakdown;
}
```

### 7. Pharmacy Review Entity

**File**: `lib/features/patient_app/domain/entities/pharmacy_review.dart`

```dart
class PharmacyReview {
  final String id;                    // Primary key
  final String patientId;             // Foreign key to User (reviewer)
  final String pharmacyId;            // Foreign key to Pharmacy
  final int rating;                   // 1-5 stars
  final String? reviewText;           // Optional review text
  final ServiceAspects serviceAspects; // Detailed ratings
  final DateTime submittedAt;
  final int helpfulVotes;             // Count of helpful votes
  final bool isVerified;              // Verified purchase
  final String? visitDate;            // When they visited
}

class ServiceAspects {
  final int helpfulness;              // 1-5 rating
  final int availability;            // 1-5 rating
  final int cleanliness;              // 1-5 rating
  final int pricing;                  // 1-5 rating
  final int staffKnowledge;           // 1-5 rating
}
```

### 8. Medication Review Entity

**File**: `lib/features/patient_app/domain/entities/medication_review.dart`

```dart
class MedicationReview {
  final String id;                    // Primary key
  final String patientId;             // Foreign key to User (reviewer)
  final String medicationId;          // Foreign key to Medication
  final int rating;                   // 1-5 stars
  final String? reviewText;           // Optional review text
  final int effectivenessRating;     // 1-5 rating
  final List<String> sideEffectsExperienced; // Side effects they had
  final String? conditionTreated;     // What they used it for
  final DateTime submittedAt;
  final int helpfulVotes;             // Count of helpful votes
  final bool isVerifiedPurchase;      // Verified they bought it
  final String? dosageUsed;           // Dosage they took
  final int durationOfUse;           // Days/weeks used
}
```

### 9. Medication View History Entity

**File**: `lib/features/patient_app/domain/entities/medication_view_history.dart`

```dart
class MedicationViewHistory {
  final String id;                    // Primary key
  final String patientId;             // Foreign key to User
  final String medicationId;          // Foreign key to Medication
  final int viewCount;                // Number of times viewed
  final DateTime lastViewedAt;        // Last view timestamp
  final bool isBookmarked;            // Saved for later
  final DateTime firstViewedAt;       // First view timestamp
  final List<String> searchTerms;     // Terms used to find this medication
}
```

### 10. Prescription Entity

**File**: `lib/features/patient_app/domain/entities/prescription.dart`

```dart
class Prescription {
  final String id;                    // Primary key
  final String patientId;             // Foreign key to User
  final String imageUrl;              // Prescription image/document
  final DateTime uploadDate;
  final DateTime? expiryDate;          // Prescription expiry
  final String? doctorName;            // Prescribing doctor
  final String? doctorLicense;         // Doctor license number
  final String? hospital;             // Hospital/clinic name
  final List<PrescribedMedication> medications; // Medications on prescription
  final PrescriptionStatus status;    // active | expired | used | cancelled
  final String? notes;                // Additional notes
  final bool isDigital;               // Digital prescription vs scanned
  final String? prescriptionNumber;   // Prescription reference number
}

class PrescribedMedication {
  final String medicationId;          // Foreign key to Medication
  final String medicationName;
  final String dosage;
  final String frequency;
  final int quantity;
  final String? instructions;
}
```

### 11. Pharmacist Profile Entity

**File**: `lib/features/pharmacist_app/domain/entities/pharmacist_profile.dart`

```dart
class PharmacistProfile {
  final String id;                    // Same as User.id
  final String userId;                // Foreign key to User
  final String pharmacyId;            // Foreign key to Pharmacy
  final String fullName;              // Computed from firstName + lastName
  final String licenseNumber;         // Pharmacist license
  final String? specialization;       // Specialization area
  final int yearsOfExperience;        // Years in practice
  final List<String> certifications; // Additional certifications
  final String? bio;                   // Professional bio
  final List<String> languages;       // Languages spoken
  final bool isAvailableForConsultation; // Available for patient consultations
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

## Enums and Constants

### UserType
```dart
enum UserType {
  patient,
  pharmacist,
  unknown;
}
```

### VerificationStatus
```dart
enum VerificationStatus {
  verified,
  pending,
  rejected;
}
```

### PharmacyType
```dart
enum PharmacyType {
  retail,
  wholesale;
}
```

### StockStatus
```dart
enum StockStatus {
  inStock,
  lowStock,
  outOfStock;
}
```

### ConditionStatus
```dart
enum ConditionStatus {
  active,
  resolved,
  chronic;
}
```

### RecoveryStatus
```dart
enum RecoveryStatus {
  cured,
  notCured,
  ongoing;
}
```

### AllergyType
```dart
enum AllergyType {
  drug,
  food,
  environmental;
}
```

### AllergySeverity
```dart
enum AllergySeverity {
  mild,
  moderate,
  severe;
}
```

### MedicalHistoryPrivacyLevel
```dart
enum MedicalHistoryPrivacyLevel {
  private,
  sharedWithPharmacists,
  public;
}
```

### PrescriptionStatus
```dart
enum PrescriptionStatus {
  active,
  expired,
  used,
  cancelled;
}
```

## Firestore Collections Structure

### Collection: `users`
```
users/{userId}
├── id: string
├── email: string
├── firstName: string
├── lastName: string
├── phoneNumber: string
├── address: string?
├── userType: string
├── pharmacyId: string?
├── dateOfBirth: timestamp?
├── gender: string?
├── profileImageUrl: string?
├── whatsappNumber: string?
├── verificationStatus: string
├── createdAt: timestamp
├── updatedAt: timestamp
├── lastLoginAt: timestamp?
├── notificationsEnabled: boolean
└── themePreference: string
```

### Collection: `pharmacies`
```
pharmacies/{pharmacyId}
├── id: string
├── name: string
├── address: string
├── phoneNumber: string
├── email: string
├── businessEmail: string
├── type: string
├── licenseNumber: string?
├── description: string?
├── frontalImageUrl: string?
├── interiorImageUrl: string?
├── logoUrl: string?
├── licenseDocumentUrls: array
├── pcnRegistrationNumber: string?
├── operatingHours: array
├── location: object
├── rating: object
├── isVerified: boolean
├── isFeatured: boolean
├── employeeIds: array
├── createdAt: timestamp
└── updatedAt: timestamp
```

### Collection: `medications`
```
medications/{medicationId}
├── id: string
├── name: string
├── brandNames: array
├── category: string
├── manufacturer: string
├── dosageForms: array
├── strengths: array
├── description: string?
├── usageInstructions: string?
├── sideEffects: array
├── contraindications: array
├── prescriptionRequired: boolean
├── imageUrls: array
├── rating: object
├── alternativeIds: array
├── createdAt: timestamp
└── updatedAt: timestamp
```

### Collection: `medical_history`
```
medical_history/{patientId}
├── id: string
├── patientId: string
├── conditions: array
├── currentMedications: array
├── diagnoses: array
├── allergies: array
├── prescriptions: array
├── createdAt: timestamp
└── updatedAt: timestamp
```

### Collection: `inventory`
```
inventory/{inventoryItemId}
├── id: string
├── pharmacyId: string
├── medicationId: string
├── brandName: string
├── quantityInStock: number
├── batchNumber: string?
├── expiryDate: timestamp
├── purchasePrice: number
├── sellingPrice: number
├── minimumStockLevel: number
├── stockStatus: string
├── supplierName: string?
├── lastRestocked: timestamp
├── createdAt: timestamp
└── updatedAt: timestamp
```

### Collection: `reviews`
```
reviews/pharmacy_reviews/{reviewId}
├── id: string
├── patientId: string
├── pharmacyId: string
├── rating: number
├── reviewText: string?
├── serviceAspects: object
├── submittedAt: timestamp
├── helpfulVotes: number
├── isVerified: boolean
└── visitDate: string?

reviews/medication_reviews/{reviewId}
├── id: string
├── patientId: string
├── medicationId: string
├── rating: number
├── reviewText: string?
├── effectivenessRating: number
├── sideEffectsExperienced: array
├── conditionTreated: string?
├── submittedAt: timestamp
├── helpfulVotes: number
├── isVerifiedPurchase: boolean
├── dosageUsed: string?
└── durationOfUse: number
```

### Collection: `view_history`
```
view_history/{patientId}/medications/{medicationId}
├── id: string
├── patientId: string
├── medicationId: string
├── viewCount: number
├── lastViewedAt: timestamp
├── isBookmarked: boolean
├── firstViewedAt: timestamp
└── searchTerms: array
```

### Collection: `prescriptions`
```
prescriptions/{prescriptionId}
├── id: string
├── patientId: string
├── imageUrl: string
├── uploadDate: timestamp
├── expiryDate: timestamp?
├── doctorName: string?
├── doctorLicense: string?
├── hospital: string?
├── medications: array
├── status: string
├── notes: string?
├── isDigital: boolean
└── prescriptionNumber: string?
```

## Security Rules (Firestore)

### Users Collection
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Medical History Collection
```javascript
match /medical_history/{patientId} {
  allow read, write: if request.auth != null && request.auth.uid == patientId;
  // Allow pharmacists to read if patient has granted permission
  allow read: if request.auth != null && 
    exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
    get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'pharmacist' &&
    exists(/databases/$(database)/documents/users/$(patientId)/patient_profile/profile) &&
    get(/databases/$(database)/documents/users/$(patientId)/patient_profile/profile).data.allowedPharmacistIds[request.auth.uid] == true;
}
```

### Pharmacies Collection
```javascript
match /pharmacies/{pharmacyId} {
  allow read: if true; // Public read access
  allow write: if request.auth != null && 
    exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
    get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'pharmacist' &&
    get(/databases/$(database)/documents/users/$(request.auth.uid)).data.pharmacyId == pharmacyId;
}
```

## Indexes for Performance

### Composite Indexes
1. `pharmacies` collection:
   - `type` + `isVerified` + `rating.averageRating`
   - `location.latitude` + `location.longitude`

2. `inventory` collection:
   - `pharmacyId` + `medicationId`
   - `pharmacyId` + `stockStatus`
   - `expiryDate` + `stockStatus`

3. `reviews` collection:
   - `pharmacyId` + `submittedAt`
   - `medicationId` + `submittedAt`
   - `patientId` + `submittedAt`

4. `view_history` collection:
   - `patientId` + `lastViewedAt`
   - `patientId` + `isBookmarked`

## Data Validation Rules

### User Entity
- Email: Valid email format, unique
- Phone: Valid phone format, unique
- UserType: Must be 'patient' or 'pharmacist'
- If pharmacist: pharmacyId required
- If patient: dateOfBirth required

### Pharmacy Entity
- Name: Required, min 2 characters
- Address: Required, min 10 characters
- Phone: Valid phone format
- Email: Valid email format
- Business Email: Valid email format, different from owner email
- License Number: Required for verification
- Location: Valid latitude/longitude coordinates

### Medication Entity
- Name: Required, min 2 characters
- Brand Names: At least one brand name
- Category: Required
- Manufacturer: Required
- Dosage Forms: At least one form
- Strengths: At least one strength
- Prescription Required: Boolean

### Inventory Item Entity
- Quantity: Non-negative integer
- Purchase Price: Positive number
- Selling Price: Positive number, >= purchase price
- Expiry Date: Future date
- Minimum Stock Level: Non-negative integer

### Review Entities
- Rating: Integer between 1-5
- Review Text: Max 1000 characters
- Patient ID: Must exist in users collection
- Pharmacy/Medication ID: Must exist in respective collections

## Migration Notes for REST API

### SQL Schema Equivalents

#### Users Table
```sql
CREATE TABLE users (
    id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    address TEXT,
    user_type ENUM('patient', 'pharmacist') NOT NULL,
    pharmacy_id VARCHAR(255),
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other'),
    profile_image_url VARCHAR(500),
    whatsapp_number VARCHAR(20),
    verification_status ENUM('verified', 'pending', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP,
    notifications_enabled BOOLEAN DEFAULT TRUE,
    theme_preference ENUM('light', 'dark', 'system') DEFAULT 'system',
    FOREIGN KEY (pharmacy_id) REFERENCES pharmacies(id)
);
```

#### Pharmacies Table
```sql
CREATE TABLE pharmacies (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    business_email VARCHAR(255) NOT NULL,
    type ENUM('retail', 'wholesale') NOT NULL,
    license_number VARCHAR(100),
    description TEXT,
    frontal_image_url VARCHAR(500),
    interior_image_url VARCHAR(500),
    logo_url VARCHAR(500),
    pcn_registration_number VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    average_rating DECIMAL(3, 2) DEFAULT 0.00,
    total_reviews INT DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## Example Seed Data

### Sample Medications
```json
{
  "id": "med_001",
  "name": "Paracetamol",
  "brandNames": ["Panadol", "Tylenol", "Calpol"],
  "category": "Analgesic",
  "manufacturer": "GSK",
  "dosageForms": ["tablet", "syrup", "suppository"],
  "strengths": ["500mg", "250mg", "120mg/5ml"],
  "description": "Pain reliever and fever reducer",
  "prescriptionRequired": false,
  "rating": {
    "averageRating": 4.2,
    "totalReviews": 150
  }
}
```

### Sample Pharmacy
```json
{
  "id": "pharm_001",
  "name": "City Health Pharmacy",
  "address": "123 Main Street, Lagos, Nigeria",
  "phoneNumber": "+234-801-234-5678",
  "email": "info@cityhealthpharmacy.com",
  "businessEmail": "orders@cityhealthpharmacy.com",
  "type": "retail",
  "licenseNumber": "PCN-LAG-2023-001",
  "description": "Your trusted neighborhood pharmacy",
  "location": {
    "latitude": 6.5244,
    "longitude": 3.3792,
    "address": "123 Main Street, Lagos, Nigeria"
  },
  "rating": {
    "averageRating": 4.5,
    "totalReviews": 89
  },
  "isVerified": true,
  "isFeatured": false
}
```

This schema provides a comprehensive foundation for the MedConnect application, supporting all required features while maintaining flexibility for future enhancements and backend migrations.


---

# MedConnect Data Schema Implementation Summary

## Overview
Successfully implemented a comprehensive data schema for the MedConnect application supporting both patient and pharmacist user types. The schema is designed to work with Firebase/Firestore but structured to be backend-agnostic for future migration to REST API + SQL databases.

## ✅ Completed Implementation

### 1. Core Documentation
- **DATA_SCHEMA.md**: Comprehensive documentation with all entity definitions, field types, constraints, relationships, Firestore collections structure, security rules, and migration notes for REST API transition.

### 2. Extended Existing Entities
- **UserEntity** (`lib/common/auth/domain/entities/user_entity.dart`): Extended with patient/pharmacist specific fields, verification status, timestamps, and settings
- **Pharmacy** (`lib/common/auth/domain/entities/pharmacy.dart`): Expanded with pharmacy type, business email, images, verification docs, operating hours, location, ratings, and featured status

### 3. Shared Entities
- **Medication** (`lib/common/domain/entities/medication.dart`): Master catalog with generic names, brand names, categories, manufacturers, dosage forms, strengths, descriptions, side effects, contraindications, and ratings

### 4. Patient-Specific Entities
- **PatientProfile** (`lib/features/patient_app/domain/entities/patient_profile.dart`): Personal details, emergency contacts, privacy settings
- **MedicalHistory** (`lib/features/patient_app/domain/entities/medical_history.dart`): Comprehensive medical data with sub-entities:
  - MedicalCondition: Current and past conditions
  - CurrentMedication: Active prescriptions
  - Diagnosis: Medical diagnoses with treatment outcomes
  - Allergy: Drug, food, and environmental allergies
- **Prescription** (`lib/features/patient_app/domain/entities/prescription.dart`): Digital prescriptions with doctor info, medications, and status tracking
- **PharmacyReview** (`lib/features/patient_app/domain/entities/pharmacy_review.dart`): Patient feedback on pharmacies with service aspects
- **MedicationReview** (`lib/features/patient_app/domain/entities/medication_review.dart`): Patient feedback on medications with effectiveness ratings
- **MedicationViewHistory** (`lib/features/patient_app/domain/entities/medication_view_history.dart`): Track viewed medications with bookmarks

### 5. Pharmacist-Specific Entities
- **PharmacistProfile** (`lib/features/pharmacist_app/domain/entities/pharmacist_profile.dart`): Professional details, license, specialization, certifications
- **InventoryItem** (`lib/features/pharmacist_app/domain/entities/inventory_item.dart`): Pharmacy stock management with batch tracking, expiry dates, pricing, and stock status

### 6. Data Models with JSON Serialization
- **UserModel** (`lib/common/auth/data/models/user_model.dart`): Extended to match UserEntity
- **MedicationModel** (`lib/common/domain/models/medication_model.dart`): With MedicationRatingModel
- **PharmacyModel** (`lib/common/auth/data/models/pharmacy_model.dart`): With OperatingHoursModel, GeoLocationModel, PharmacyRatingModel
- **PatientProfileModel** (`lib/features/patient_app/data/models/patient_profile_model.dart`)
- **InventoryItemModel** (`lib/features/pharmacist_app/data/models/inventory_item_model.dart`)

### 7. Enums and Constants
- UserType, VerificationStatus, PharmacyType, StockStatus
- ConditionStatus, RecoveryStatus, AllergyType, AllergySeverity
- MedicalHistoryPrivacyLevel, PrescriptionStatus

## 🏗️ Architecture Features

### Backend Recommendation
- **Phase 1**: Firebase (Auth + Firestore + Storage) for rapid development
- **Phase 2**: Optional migration to REST API + SQL for complex analytics and cost optimization

### Data Relationships
1. **User → Pharmacy**: One-to-one (pharmacist) or none (patient)
2. **Pharmacy → Inventory Items**: One-to-many
3. **Medication → Inventory Items**: One-to-many (same medication in multiple pharmacies)
4. **Patient → Medical History**: One-to-one
5. **Patient → Reviews**: One-to-many
6. **Patient → View History**: One-to-many
7. **Pharmacy → Reviews**: One-to-many (received)

### Security & Privacy
- Medical history encryption support
- Granular privacy controls (private, shared with pharmacists, public)
- Firestore security rules for data access control
- HIPAA compliance considerations

### Business Logic
- Automatic stock status determination
- Expiry date tracking and alerts
- Profit margin calculations
- Rating aggregations
- Age calculations from date of birth

## 📁 File Structure Created

```
lib/
├── common/
│   ├── auth/
│   │   ├── data/models/
│   │   │   ├── user_model.dart (extended)
│   │   │   └── pharmacy_model.dart (new)
│   │   └── domain/entities/
│   │       ├── user_entity.dart (extended)
│   │       └── pharmacy.dart (expanded)
│   └── domain/
│       ├── entities/
│       │   └── medication.dart (new)
│       └── models/
│           └── medication_model.dart (new)
├── features/
│   ├── patient_app/
│   │   ├── data/models/
│   │   │   └── patient_profile_model.dart
│   │   └── domain/entities/
│   │       ├── patient_profile.dart
│   │       ├── medical_history.dart
│   │       ├── prescription.dart
│   │       ├── pharmacy_review.dart
│   │       ├── medication_review.dart
│   │       └── medication_view_history.dart
│   └── pharmacist_app/
│       ├── data/models/
│       │   └── inventory_item_model.dart
│       └── domain/entities/
│           ├── pharmacist_profile.dart
│           └── inventory_item.dart
└── DATA_SCHEMA.md (comprehensive documentation)
```

## 🔄 Next Steps

1. **Generate JSON serialization code**: Run `flutter packages pub run build_runner build` to generate `.g.dart` files
2. **Implement repositories**: Create repository implementations for data access
3. **Add validation**: Implement form validation using the entity constraints
4. **Create use cases**: Implement business logic use cases
5. **Set up Firebase**: Configure Firestore collections and security rules
6. **Add tests**: Create unit tests for entities and models

## 🎯 Key Benefits

- **Scalable**: Clean architecture with separation of concerns
- **Flexible**: Backend-agnostic design for easy migration
- **Secure**: Built-in privacy controls and security considerations
- **Comprehensive**: Covers all requirements for both user types
- **Maintainable**: Well-documented with clear relationships
- **Future-proof**: Easy to extend with new features

The data schema is now ready for implementation and provides a solid foundation for the MedConnect application.
