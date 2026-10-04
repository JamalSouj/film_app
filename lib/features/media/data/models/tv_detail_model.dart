import '../../domain/entities/tv_detail.dart';
import 'genre_model.dart';
import 'credits_model.dart';
import 'season_model.dart';

class TvDetailModel extends TvDetail {
  const TvDetailModel({
    required super.id,
    required super.name,
    super.overview,
    super.posterPath,
    super.backdropPath,
    super.firstAirDate,
    super.voteAverage = 0.0,
    super.numberOfSeasons = 0,
    super.genres = const [],
    super.seasons = const [],
    super.credits,
  });

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? 'Untitled',
        overview: json['overview'] as String?,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        firstAirDate: json['first_air_date'] as String?,
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
        numberOfSeasons: json['number_of_seasons'] as int? ?? 0,
        genres: (json['genres'] as List<dynamic>?)
                ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>).toEntity())
                .toList() ??
            const [],
        seasons: (json['seasons'] as List<dynamic>?)
                ?.map((e) => SeasonModel.fromJson(e as Map<String, dynamic>).toEntity())
                .toList() ??
            const [],
        credits: json['credits'] != null
            ? CreditsModel.fromJson(json['credits'] as Map<String, dynamic>).toEntity()
            : null,
      );

  TvDetail toEntity() => TvDetail(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        firstAirDate: firstAirDate,
        voteAverage: voteAverage,
        numberOfSeasons: numberOfSeasons,
        genres: genres,
        seasons: seasons,
        credits: credits,
      );
}
