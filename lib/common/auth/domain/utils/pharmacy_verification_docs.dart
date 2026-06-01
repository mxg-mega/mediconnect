import 'package:mediconnect/common/auth/domain/entities/pharmacy.dart';
import 'package:mediconnect/common/auth/domain/entities/pharmacy_verification_document.dart';
import 'package:mediconnect/core/utils/document_url_utils.dart';

/// Storage folder keys aligned with [PharmacyVerificationDocType.storageFolder].
abstract final class PharmacyVerificationSlotKeys {
  static const frontal = 'frontal';
  static const license = 'license';
  static const businessRegistration = 'business_registration';
  static const pcnCertificate = 'pcn_certificate';
  static const addressProof = 'address_proof';
  static const additional = 'additional';

  static const all = [
    frontal,
    license,
    businessRegistration,
    pcnCertificate,
    addressProof,
    additional,
  ];

  static int? licenseSlotIndex(String slotKey) => switch (slotKey) {
        license => 0,
        businessRegistration => 1,
        pcnCertificate => 2,
        addressProof => 3,
        additional => 4,
        _ => null,
      };

  static String? slotKeyFromDocTypeEnumIndex({
    required bool isFrontal,
    int? licenseIndex,
  }) {
    if (isFrontal) return frontal;
    return switch (licenseIndex) {
      0 => license,
      1 => businessRegistration,
      2 => pcnCertificate,
      3 => addressProof,
      4 => additional,
      _ => null,
    };
  }
}

class ResolvedVerificationSlot {
  final String slotKey;
  final PharmacyVerificationDocument document;

  const ResolvedVerificationSlot({
    required this.slotKey,
    required this.document,
  });
}

/// Resolves all verification slots from map + legacy URL fields.
List<ResolvedVerificationSlot> resolveVerificationSlots(Pharmacy pharmacy) {
  final legacyStatus = pharmacy.isVerified
      ? PharmacyVerificationDocStatus.verified
      : PharmacyVerificationDocStatus.pending;
  final fallbackDate = pharmacy.updatedAt;

  PharmacyVerificationDocument slotOrLegacy({
    required String slotKey,
    required String? legacyUrl,
    int? licenseIndex,
  }) {
    final fromMap = pharmacy.verificationDocuments[slotKey];
    if (fromMap != null && fromMap.hasFile) {
      return fromMap;
    }
    if (legacyUrl != null && legacyUrl.isNotEmpty) {
      return PharmacyVerificationDocument(
        url: legacyUrl,
        uploadedAt: fallbackDate,
        status: legacyStatus,
        contentType: DocumentUrlUtils.isImageUrl(legacyUrl)
            ? 'image/jpeg'
            : 'application/pdf',
      );
    }
    return const PharmacyVerificationDocument();
  }

  String? licenseUrl(int index) {
    if (index >= pharmacy.licenseDocumentUrls.length) return null;
    final v = pharmacy.licenseDocumentUrls[index];
    return v.isEmpty ? null : v;
  }

  return [
    ResolvedVerificationSlot(
      slotKey: PharmacyVerificationSlotKeys.frontal,
      document: slotOrLegacy(
        slotKey: PharmacyVerificationSlotKeys.frontal,
        legacyUrl: pharmacy.frontalImageUrl,
      ),
    ),
    ResolvedVerificationSlot(
      slotKey: PharmacyVerificationSlotKeys.license,
      document: slotOrLegacy(
        slotKey: PharmacyVerificationSlotKeys.license,
        legacyUrl: licenseUrl(0),
        licenseIndex: 0,
      ),
    ),
    ResolvedVerificationSlot(
      slotKey: PharmacyVerificationSlotKeys.businessRegistration,
      document: slotOrLegacy(
        slotKey: PharmacyVerificationSlotKeys.businessRegistration,
        legacyUrl: licenseUrl(1),
        licenseIndex: 1,
      ),
    ),
    ResolvedVerificationSlot(
      slotKey: PharmacyVerificationSlotKeys.pcnCertificate,
      document: slotOrLegacy(
        slotKey: PharmacyVerificationSlotKeys.pcnCertificate,
        legacyUrl: licenseUrl(2),
        licenseIndex: 2,
      ),
    ),
    ResolvedVerificationSlot(
      slotKey: PharmacyVerificationSlotKeys.addressProof,
      document: slotOrLegacy(
        slotKey: PharmacyVerificationSlotKeys.addressProof,
        legacyUrl: licenseUrl(3),
        licenseIndex: 3,
      ),
    ),
    ResolvedVerificationSlot(
      slotKey: PharmacyVerificationSlotKeys.additional,
      document: slotOrLegacy(
        slotKey: PharmacyVerificationSlotKeys.additional,
        legacyUrl: licenseUrl(4),
        licenseIndex: 4,
      ),
    ),
  ];
}

Map<String, PharmacyVerificationDocument> parseVerificationDocumentsMap(
  dynamic json,
) {
  if (json is! Map) return {};
  final result = <String, PharmacyVerificationDocument>{};
  json.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      result[key.toString()] = PharmacyVerificationDocument.fromJson(value);
    } else if (value is Map) {
      result[key.toString()] = PharmacyVerificationDocument.fromJson(
        Map<String, dynamic>.from(value),
      );
    }
  });
  return result;
}

Map<String, dynamic> verificationDocumentsToJson(
  Map<String, PharmacyVerificationDocument> docs,
) {
  return docs.map((key, doc) => MapEntry(key, doc.toJson()));
}

/// Applies slot upload to verification map + legacy URL fields.
Pharmacy applyVerificationSlotUpload({
  required Pharmacy pharmacy,
  required String slotKey,
  required String downloadUrl,
  required String contentType,
}) {
  final now = DateTime.now();
  final doc = PharmacyVerificationDocument(
    url: downloadUrl,
    uploadedAt: now,
    status: PharmacyVerificationDocStatus.pending,
    contentType: contentType,
  );

  final docs = Map<String, PharmacyVerificationDocument>.from(
    pharmacy.verificationDocuments,
  );
  docs[slotKey] = doc;

  var updated = pharmacy.copyWith(
    verificationDocuments: docs,
    updatedAt: now,
  );

  if (slotKey == PharmacyVerificationSlotKeys.frontal) {
    updated = updated.copyWith(frontalImageUrl: downloadUrl);
  } else {
    final index = PharmacyVerificationSlotKeys.licenseSlotIndex(slotKey);
    if (index != null) {
      final urls = List<String>.filled(5, '');
      for (var i = 0; i < updated.licenseDocumentUrls.length && i < 5; i++) {
        urls[i] = updated.licenseDocumentUrls[i];
      }
      urls[index] = downloadUrl;
      updated = updated.copyWith(licenseDocumentUrls: urls);
    }
  }

  return updated;
}

Pharmacy applyVerificationSlotDelete({
  required Pharmacy pharmacy,
  required String slotKey,
}) {
  final docs = Map<String, PharmacyVerificationDocument>.from(
    pharmacy.verificationDocuments,
  );
  docs.remove(slotKey);

  var updated = pharmacy.copyWith(
    verificationDocuments: docs,
    updatedAt: DateTime.now(),
  );

  if (slotKey == PharmacyVerificationSlotKeys.frontal) {
    updated = updated.copyWith(frontalImageUrl: null);
  } else {
    final index = PharmacyVerificationSlotKeys.licenseSlotIndex(slotKey);
    if (index != null) {
      final urls = List<String>.filled(5, '');
      for (var i = 0; i < updated.licenseDocumentUrls.length && i < 5; i++) {
        urls[i] = updated.licenseDocumentUrls[i];
      }
      urls[index] = '';
      updated = updated.copyWith(licenseDocumentUrls: urls);
    }
  }

  return updated;
}

List<String> normalizeLicenseSlots(List<String> current) {
  final slots = List<String>.filled(5, '');
  for (var i = 0; i < current.length && i < 5; i++) {
    slots[i] = current[i];
  }
  return slots;
}
