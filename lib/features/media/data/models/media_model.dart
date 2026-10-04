import '../../domain/entities/media.dart';

class MediaModel extends Media {
  const MediaModel({
    required super.id,
    super.title,
    super.name,
    super.posterPath,
    super.backdropPath,
    super.overview,
    super.voteAverage = 0.0,
    super.mediaType,
    super.releaseDate,
    super.firstAirDate,
    super.genreIds = const [],
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
        id: json['id'] as int,
        title: json['title'] as String?,
        name: json['name'] as String?,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        overview: json['overview'] as String?,
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
        mediaType: json['media_type'] as String?,
        releaseDate: json['release_date'] as String?,
        firstAirDate: json['first_air_date'] as String?,
        genreIds: (json['genre_ids'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            const [],
      );

  Media toEntity() => Media(
        id: id,
        title: title,
        name: name,
        posterPath: posterPath,
        backdropPath: backdropPath,
        overview: overview,
        voteAverage: voteAverage,
        mediaType: mediaType,
        releaseDate: releaseDate,
        firstAirDate: firstAirDate,
        genreIds: genreIds,
      );
}
