import 'package:equatable/equatable.dart';

enum PharmacyVerificationDocStatus {
  pending,
  verified,
  rejected;

  static PharmacyVerificationDocStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'verified':
        return PharmacyVerificationDocStatus.verified;
      case 'rejected':
        return PharmacyVerificationDocStatus.rejected;
      case 'pending':
      default:
        return PharmacyVerificationDocStatus.pending;
    }
  }

  String get value => name;
}

class PharmacyVerificationDocument extends Equatable {
  final String? url;
  final DateTime? uploadedAt;
  final PharmacyVerificationDocStatus status;
  final String? contentType;

  const PharmacyVerificationDocument({
    this.url,
    this.uploadedAt,
    this.status = PharmacyVerificationDocStatus.pending,
    this.contentType,
  });

  bool get hasFile => url != null && url!.isNotEmpty;

  PharmacyVerificationDocument copyWith({
    String? url,
    DateTime? uploadedAt,
    PharmacyVerificationDocStatus? status,
    String? contentType,
    bool clearUrl = false,
  }) {
    return PharmacyVerificationDocument(
      url: clearUrl ? null : (url ?? this.url),
      uploadedAt: uploadedAt ?? this.uploadedAt,
      status: status ?? this.status,
      contentType: contentType ?? this.contentType,
    );
  }

  Map<String, dynamic> toJson() => {
        if (url != null && url!.isNotEmpty) 'url': url,
        if (uploadedAt != null) 'uploaded_at': uploadedAt!.toIso8601String(),
        'status': status.value,
        if (contentType != null) 'content_type': contentType,
      };

  factory PharmacyVerificationDocument.fromJson(Map<String, dynamic> json) {
    return PharmacyVerificationDocument(
      url: json['url'] as String?,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.tryParse(json['uploaded_at'] as String)
          : null,
      status: PharmacyVerificationDocStatus.fromString(json['status'] as String?),
      contentType: json['content_type'] as String?,
    );
  }

  @override
  List<Object?> get props => [url, uploadedAt, status, contentType];
}
