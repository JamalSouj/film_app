import '../../../../core/constants/app_constants.dart';

class Media {
  const Media({
    required this.id,
    this.title,
    this.name,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage = 0.0,
    this.mediaType,
    this.releaseDate,
    this.firstAirDate,
    this.genreIds = const [],
  });

  final int id;
  final String? title;
  final String? name;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final double voteAverage;
  final String? mediaType;
  final String? releaseDate;
  final String? firstAirDate;
  final List<int> genreIds;

  String get displayTitle => title ?? name ?? 'Unknown';
  String get displayDate => releaseDate ?? firstAirDate ?? '';
  String get year {
    final d = displayDate;
    return d.length >= 4 ? d.substring(0, 4) : '';
  }
  String get resolvedMediaType => mediaType ?? (title != null ? 'movie' : 'tv');
  String get posterUrl => AppConstants.posterUrl(posterPath);
  String get backdropUrl => AppConstants.backdropUrl(backdropPath);
  String get ratingLabel => voteAverage.toStringAsFixed(1);
}
