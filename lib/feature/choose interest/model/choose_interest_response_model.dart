// lib/feature/choose_interest/model/choose_interest_response_model.dart
class ChooseInterestResponseModel {
  final int? count;
  final int? nextOffset;  // ← camelCase field
  final int? total;
  final double? took;
  final List<ChooseInterestItem>? results;

  ChooseInterestResponseModel({
    this.count,
    this.nextOffset,
    this.total,
    this.took,
    this.results,
  });

  factory ChooseInterestResponseModel.fromJson(Map<String, dynamic> json) {
    return ChooseInterestResponseModel(
      count: json['count'] as int?,
      nextOffset: json['next_offset'] as int?,  // ← Read from snake_case
      total: json['total'] as int?,
      took: (json['took'] as num?)?.toDouble(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => ChooseInterestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'next_offset': nextOffset,
    'total': total,
    'took': took,
    'results': results?.map((e) => e.toJson()).toList(),
  };
}

class ChooseInterestItem {
  final String? audio;
  final int? audioLengthSec;
  final String? rss;
  final String? descriptionHighlighted;
  final String? descriptionOriginal;
  final String? titleHighlighted;
  final String? titleOriginal;
  final String? title;
  final String? description;
  final List<String>? transcriptsHighlighted;
  final String? image;
  final String? thumbnail;
  final int? itunesId;
  final int? pubDateMs;
  final String? id;
  final String? listennotesUrl;
  final bool? explicitContent;
  final String? link;
  final String? guidFromRss;
  final Podcast? podcast;

  ChooseInterestItem({
    this.audio,
    this.audioLengthSec,
    this.rss,
    this.descriptionHighlighted,
    this.descriptionOriginal,
    this.titleHighlighted,
    this.titleOriginal,
    this.title,
    this.description,
    this.transcriptsHighlighted,
    this.image,
    this.thumbnail,
    this.itunesId,
    this.pubDateMs,
    this.id,
    this.listennotesUrl,
    this.explicitContent,
    this.link,
    this.guidFromRss,
    this.podcast,
  });

  factory ChooseInterestItem.fromJson(Map<String, dynamic> json) {
    return ChooseInterestItem(
      audio: json['audio'] as String?,
      audioLengthSec: json['audio_length_sec'] as int?,
      rss: json['rss'] as String?,
      description: json['description'] as String?,
      title: json['title'] as String?,
      descriptionHighlighted: json['description_highlighted'] as String?,
      descriptionOriginal: json['description_original'] as String?,
      titleHighlighted: json['title_highlighted'] as String?,
      titleOriginal: json['title_original'] as String?,
      transcriptsHighlighted:
      (json['transcripts_highlighted'] as List<dynamic>?)?.cast<String>(),
      image: json['image'] as String?,
      thumbnail: json['thumbnail'] as String?,
      itunesId: json['itunes_id'] as int?,
      pubDateMs: json['pub_date_ms'] as int?,
      id: json['id'] as String?,
      listennotesUrl: json['listennotes_url'] as String?,
      explicitContent: json['explicit_content'] as bool?,
      link: json['link'] as String?,
      guidFromRss: json['guid_from_rss'] as String?,
      podcast: json['podcast'] != null
          ? Podcast.fromJson(json['podcast'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'audio': audio,
    'audio_length_sec': audioLengthSec,
    'rss': rss,
    'description': description,
    'description_highlighted': descriptionHighlighted,
    'description_original': descriptionOriginal,
    'title_highlighted': titleHighlighted,
    'title_original': titleOriginal,
    'transcripts_highlighted': transcriptsHighlighted,
    'image': image,
    'title': title,
    'thumbnail': thumbnail,
    'itunes_id': itunesId,
    'pub_date_ms': pubDateMs,
    'id': id,
    'listennotes_url': listennotesUrl,
    'explicit_content': explicitContent,
    'link': link,
    'guid_from_rss': guidFromRss,
    'podcast': podcast?.toJson(),
  };
}

class Podcast {
  final String? listennotesUrl;
  final String? id;
  final String? titleHighlighted;
  final String? titleOriginal;
  final String? publisherHighlighted;
  final String? publisherOriginal;
  final String? image;
  final String? thumbnail;
  final List<int>? genreIds;
  final String? listenScore;
  final String? listenScoreGlobalRank;

  Podcast({
    this.listennotesUrl,
    this.id,
    this.titleHighlighted,
    this.titleOriginal,
    this.publisherHighlighted,
    this.publisherOriginal,
    this.image,
    this.thumbnail,
    this.genreIds,
    this.listenScore,
    this.listenScoreGlobalRank,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      listennotesUrl: json['listennotes_url'] as String?,
      id: json['id'] as String?,
      titleHighlighted: json['title_highlighted'] as String?,
      titleOriginal: json['title_original'] as String?,
      publisherHighlighted: json['publisher_highlighted'] as String?,
      publisherOriginal: json['publisher_original'] as String?,
      image: json['image'] as String?,
      thumbnail: json['thumbnail'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)?.cast<int>(),
      listenScore: json['listen_score'] as String?,
      listenScoreGlobalRank: json['listen_score_global_rank'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'listennotes_url': listennotesUrl,
    'id': id,
    'title_highlighted': titleHighlighted,
    'title_original': titleOriginal,
    'publisher_highlighted': publisherHighlighted,
    'publisher_original': publisherOriginal,
    'image': image,
    'thumbnail': thumbnail,
    'genre_ids': genreIds,
    'listen_score': listenScore,
    'listen_score_global_rank': listenScoreGlobalRank,
  };
}