// lib/feature/media/audio/model/audio_summay_model.dart
class PodcastTranscriptModel {
  final String? message;
  final String? summary;
  final int? wordCount;

  PodcastTranscriptModel({
    this.message,
    this.summary,
    this.wordCount,
  });

  factory PodcastTranscriptModel.fromJson(dynamic json) {
    if (json is String) {
      return PodcastTranscriptModel(summary: json);
    }

    if (json is Map<String, dynamic>) {
      return PodcastTranscriptModel(
        message: json['message'] as String?,
        summary: json['summary'] as String?,
        wordCount: json['word_count'] as int?,
      );
    }

    return PodcastTranscriptModel(summary: json.toString());
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'summary': summary,
    'word_count': wordCount,
  };

  @override
  String toString() {
    final truncated = summary != null
        ? '${summary!.substring(0, summary!.length.clamp(0, 100))}...'
        : 'null';
    return 'PodcastTranscriptModel(message: $message, summary: $truncated, wordCount: $wordCount)';
  }
}