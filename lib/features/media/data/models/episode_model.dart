import '../../domain/entities/episode.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.id,
    required super.name,
    super.overview,
    required super.episodeNumber,
    required super.seasonNumber,
    super.stillPath,
    super.voteAverage = 0.0,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? 'Episode',
        overview: json['overview'] as String?,
        episodeNumber: json['episode_number'] as int,
        seasonNumber: json['season_number'] as int,
        stillPath: json['still_path'] as String?,
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      );

  Episode toEntity() => Episode(
        id: id,
        name: name,
        overview: overview,
        episodeNumber: episodeNumber,
        seasonNumber: seasonNumber,
        stillPath: stillPath,
        voteAverage: voteAverage,
      );
}
