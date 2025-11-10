// lib/models/top_playlist_model.dart
class TopPlayListModel {
  final String id;
  final String thumbnail;
  final String file;
  final String title;
  final List<HowToStart> howToStart;
  final String afterText;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  TopPlayListModel({
    required this.id,
    required this.thumbnail,
    required this.file,
    required this.title,
    required this.howToStart,
    required this.afterText,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TopPlayListModel.fromJson(Map<String, dynamic> json) {
    return TopPlayListModel(
      id: json['id'] as String? ?? 'unknown_id',
      thumbnail: json['thumbnail'] as String? ?? '',
      file: json['file'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled',
      howToStart: (json['howToStart'] as List<dynamic>?)
          ?.map((e) => HowToStart.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      afterText: json['afterText'] as String? ?? '',
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'file': file,
      'title': title,
      'howToStart': howToStart.map((e) => e.toJson()).toList(),
      'afterText': afterText,
      'viewCount': viewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class HowToStart {
  final String image;
  final String title;
  final String subtitle;

  HowToStart({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  factory HowToStart.fromJson(Map<String, dynamic> json) {
    return HowToStart(
      image: json['image'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'subtitle': subtitle,
    };
  }
}