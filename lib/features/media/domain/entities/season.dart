class Season {
  const Season({
    required this.id,
    this.name,
    required this.seasonNumber,
    this.episodeCount = 0,
    this.posterPath,
  });

  final int id;
  final String? name;
  final int seasonNumber;
  final int episodeCount;
  final String? posterPath;

  String get label => name ?? 'Season $seasonNumber';
}
