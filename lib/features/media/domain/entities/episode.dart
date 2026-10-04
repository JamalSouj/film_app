import '../../../../core/constants/app_constants.dart';

class Episode {
  const Episode({
    required this.id,
    required this.name,
    this.overview,
    required this.episodeNumber,
    required this.seasonNumber,
    this.stillPath,
    this.voteAverage = 0.0,
  });

  final int id;
  final String name;
  final String? overview;
  final int episodeNumber;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;

  String get shortLabel => 'E${episodeNumber.toString().padLeft(2, '0')}';
  String get stillUrl => AppConstants.backdropUrl(stillPath);
}
