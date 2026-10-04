import '../../domain/entities/movie_detail.dart';
import 'genre_model.dart';
import 'credits_model.dart';

class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required super.id,
    required super.title,
    super.overview,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    super.runtime,
    super.voteAverage = 0.0,
    super.genres = const [],
    super.credits,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) => MovieDetailModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? 'Untitled',
        overview: json['overview'] as String?,
        posterPath: json['poster_path'] as String?,
        backdropPath: json['backdrop_path'] as String?,
        releaseDate: json['release_date'] as String?,
        runtime: json['runtime'] as int?,
        voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
        genres: (json['genres'] as List<dynamic>?)
                ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>).toEntity())
                .toList() ??
            const [],
        credits: json['credits'] != null
            ? CreditsModel.fromJson(json['credits'] as Map<String, dynamic>).toEntity()
            : null,
      );

  MovieDetail toEntity() => MovieDetail(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        releaseDate: releaseDate,
        runtime: runtime,
        voteAverage: voteAverage,
        genres: genres,
        credits: credits,
      );
}
