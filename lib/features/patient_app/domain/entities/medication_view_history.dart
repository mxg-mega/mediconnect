import 'package:equatable/equatable.dart';

class MedicationViewHistory extends Equatable {
  final String id; // Primary key
  final String patientId; // Foreign key to User
  final String medicationId; // Foreign key to Medication
  final int viewCount; // Number of times viewed
  final DateTime lastViewedAt; // Last view timestamp
  final bool isBookmarked; // Saved for later
  final DateTime firstViewedAt; // First view timestamp
  final List<String> searchTerms; // Terms used to find this medication

  const MedicationViewHistory({
    required this.id,
    required this.patientId,
    required this.medicationId,
    this.viewCount = 1,
    required this.lastViewedAt,
    this.isBookmarked = false,
    required this.firstViewedAt,
    this.searchTerms = const [],
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    medicationId,
    viewCount,
    lastViewedAt,
    isBookmarked,
    firstViewedAt,
    searchTerms,
  ];

  MedicationViewHistory copyWith({
    String? id,
    String? patientId,
    String? medicationId,
    int? viewCount,
    DateTime? lastViewedAt,
    bool? isBookmarked,
    DateTime? firstViewedAt,
    List<String>? searchTerms,
  }) {
    return MedicationViewHistory(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicationId: medicationId ?? this.medicationId,
      viewCount: viewCount ?? this.viewCount,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      firstViewedAt: firstViewedAt ?? this.firstViewedAt,
      searchTerms: searchTerms ?? this.searchTerms,
    );
  }

  MedicationViewHistory incrementViewCount() {
    return copyWith(viewCount: viewCount + 1, lastViewedAt: DateTime.now());
  }

  MedicationViewHistory toggleBookmark() {
    return copyWith(isBookmarked: !isBookmarked);
  }
}
