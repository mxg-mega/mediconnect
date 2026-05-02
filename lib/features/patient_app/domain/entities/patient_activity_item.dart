import 'package:equatable/equatable.dart';

enum ActivityItemType {
  search,
  medication,
  pharmacy,
}

class PatientActivityItem extends Equatable {
  final String id;
  final ActivityItemType type;
  final String title;
  final String? subtitle;
  final String? imagePath; // Local asset or network URL
  final DateTime timestamp;
  final bool isFavorite; // or bookmarked

  const PatientActivityItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.imagePath,
    required this.timestamp,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    subtitle,
    imagePath,
    timestamp,
    isFavorite,
  ];

  PatientActivityItem copyWith({
    String? id,
    ActivityItemType? type,
    String? title,
    String? subtitle,
    String? imagePath,
    DateTime? timestamp,
    bool? isFavorite,
  }) {
    return PatientActivityItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imagePath: imagePath ?? this.imagePath,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'subtitle': subtitle,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory PatientActivityItem.fromJson(Map<String, dynamic> json) {
    return PatientActivityItem(
      id: json['id'],
      type: ActivityItemType.values.firstWhere((e) => e.name == json['type']),
      title: json['title'],
      subtitle: json['subtitle'],
      imagePath: json['imagePath'],
      timestamp: DateTime.parse(json['timestamp']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
