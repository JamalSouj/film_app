import '../../domain/entities/season.dart';

class SeasonModel extends Season {
  const SeasonModel({
    required super.id,
    super.name,
    required super.seasonNumber,
    super.episodeCount = 0,
    super.posterPath,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        id: json['id'] as int,
        name: json['name'] as String?,
        seasonNumber: json['season_number'] as int,
        episodeCount: json['episode_count'] as int? ?? 0,
        posterPath: json['poster_path'] as String?,
      );

  Season toEntity() => Season(
        id: id,
        name: name,
        seasonNumber: seasonNumber,
        episodeCount: episodeCount,
        posterPath: posterPath,
      );
}
