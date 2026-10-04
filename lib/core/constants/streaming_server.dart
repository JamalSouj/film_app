/// Defines the available streaming embed servers.
///
/// Each server provides both movie and TV show embed URLs
/// with different URL patterns. The player can hot‑swap
/// between servers if one fails to load.
enum StreamingServer {
  /// VidSrc.me — default server (replacing Vidking due to emulator WebGL crashes).
  vidking(
    label: 'Server 1',
    moviePattern: 'https://vidsrc.me/embed/movie?tmdb={id}',
    tvPattern: 'https://vidsrc.me/embed/tv?tmdb={id}&season={season}&episode={episode}',
  ),

  /// VidSrc.cc — query‑parameter based URLs.
  vidsrc(
    label: 'Server 2',
    moviePattern: 'https://vidsrc.cc/v2/embed/movie/{id}',
    tvPattern:
        'https://vidsrc.cc/v2/embed/tv/{id}/{season}/{episode}',
  ),

  /// Embed.su — path‑segment based URLs.
  embedsu(
    label: 'Server 3',
    moviePattern: 'https://vidsrc.icu/embed/movie/{id}',
    tvPattern: 'https://vidsrc.icu/embed/tv/{id}/{season}/{episode}',
  ),

  /// VidSrc.net — original reliable vidsrc endpoint.
  vidsrcnet(
    label: 'Server 4',
    moviePattern: 'https://vidsrc.net/embed/movie/{id}',
    tvPattern: 'https://vidsrc.net/embed/tv/{id}/{season}/{episode}',
  );

  const StreamingServer({
    required this.label,
    required this.moviePattern,
    required this.tvPattern,
  });

  /// Human‑readable chip / dropdown label.
  final String label;

  /// URL template for movie embeds.
  /// Placeholder `{id}` is replaced with the TMDB ID.
  final String moviePattern;

  /// URL template for TV show embeds.
  /// Placeholders: `{id}`, `{season}`, `{episode}`.
  final String tvPattern;

  // ── URL builders ─────────────────────────────────────────

  /// Returns the fully resolved movie embed URL.
  String movieUrl(int tmdbId) =>
      moviePattern.replaceAll('{id}', tmdbId.toString());

  /// Returns the fully resolved TV show embed URL.
  String tvUrl(int tmdbId, int season, int episode) => tvPattern
      .replaceAll('{id}', tmdbId.toString())
      .replaceAll('{season}', season.toString())
      .replaceAll('{episode}', episode.toString());

  /// Convenience resolver that picks movie or TV based on [mediaType].
  String resolveUrl({
    required String mediaType,
    required int tmdbId,
    int season = 1,
    int episode = 1,
  }) {
    if (mediaType == 'movie') return movieUrl(tmdbId);
    return tvUrl(tmdbId, season, episode);
  }
}
