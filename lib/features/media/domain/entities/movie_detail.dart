import '../../../../core/constants/app_constants.dart';
import 'credits.dart';
import 'genre.dart';

class MovieDetail {
  const MovieDetail({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.runtime,
    this.voteAverage = 0.0,
    this.genres = const [],
    this.credits,
  });

  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final int? runtime;
  final double voteAverage;
  final List<Genre> genres;
  final Credits? credits;

  String get posterUrl => AppConstants.posterUrl(posterPath);
  String get posterHdUrl => AppConstants.posterHdUrl(posterPath);
  String get backdropUrl => AppConstants.backdropUrl(backdropPath);
  String get year => (releaseDate != null && releaseDate!.length >= 4)
      ? releaseDate!.substring(0, 4)
      : '';
  String get ratingLabel => voteAverage.toStringAsFixed(1);
  String get runtimeLabel {
    if (runtime == null || runtime == 0) return '';
    final h = runtime! ~/ 60;
    final m = runtime! % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
  String get genreLabel => genres.map((g) => g.name).join(', ');
}
