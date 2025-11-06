// lib/feature/summary/model/topic_summary_model.dart


class TopicSummaryModel {
  final String topic;
  final List<String> occurrences;
  final int count;
  final String explanation;

  TopicSummaryModel({
    required this.topic,
    required this.occurrences,
    required this.count,
    required this.explanation,
  });

  /// Factory: JSON Map থেকে অবজেক্ট তৈরি
  factory TopicSummaryModel.fromJson(Map<String, dynamic> json) {
    return TopicSummaryModel(
      topic: json['topic'] as String,
      occurrences: (json['occurrences'] as List<dynamic>).cast<String>(),
      count: json['count'] as int,
      explanation: json['explanation'] as String,
    );
  }

  /// toJson: অবজেক্ট থেকে JSON Map
  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'occurrences': occurrences,
      'count': count,
      'explanation': explanation,
    };
  }

  /// Optional: copyWith for immutable updates
  TopicSummaryModel copyWith({
    String? topic,
    List<String>? occurrences,
    int? count,
    String? explanation,
  }) {
    return TopicSummaryModel(
      topic: topic ?? this.topic,
      occurrences: occurrences ?? this.occurrences,
      count: count ?? this.count,
      explanation: explanation ?? this.explanation,
    );
  }

  @override
  String toString() {
    return 'TopicSummaryModel(topic: $topic, occurrences: $occurrences, count: $count, explanation: ${explanation.substring(0, explanation.length.clamp(0, 100))}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TopicSummaryModel &&
        other.topic == topic &&
        other.occurrences == occurrences &&
        other.count == count &&
        other.explanation == explanation;
  }

  @override
  int get hashCode =>
      topic.hashCode ^ occurrences.hashCode ^ count.hashCode ^ explanation.hashCode;
}