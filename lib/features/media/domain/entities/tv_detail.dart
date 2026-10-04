import '../../../../core/constants/app_constants.dart';
import 'credits.dart';
import 'genre.dart';
import 'season.dart';

class TvDetail {
  const TvDetail({
    required this.id,
    required this.name,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.firstAirDate,
    this.voteAverage = 0.0,
    this.numberOfSeasons = 0,
    this.genres = const [],
    this.seasons = const [],
    this.credits,
  });

  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? firstAirDate;
  final double voteAverage;
  final int numberOfSeasons;
  final List<Genre> genres;
  final List<Season> seasons;
  final Credits? credits;

  String get posterUrl => AppConstants.posterUrl(posterPath);
  String get posterHdUrl => AppConstants.posterHdUrl(posterPath);
  String get backdropUrl => AppConstants.backdropUrl(backdropPath);
  String get year => (firstAirDate != null && firstAirDate!.length >= 4)
      ? firstAirDate!.substring(0, 4)
      : '';
  String get ratingLabel => voteAverage.toStringAsFixed(1);
  String get genreLabel => genres.map((g) => g.name).join(', ');
  List<Season> get regularSeasons =>
      seasons.where((s) => s.seasonNumber > 0).toList();
}
